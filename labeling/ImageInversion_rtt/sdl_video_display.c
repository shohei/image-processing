/* Copyright 2012 The MathWorks, Inc. */
#if !defined(EXT_MODE)
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "sdl_video_display.h"



/* Local defines */
#define MW_SDL_NUM_MAX_WINDOWS     (1)
#define MW_SDL_SCREEN_ORIGIN_X (100)
#define MW_SDL_SCREEN_ORIGIN_Y (100)
#define MW_SDL_SCREEN_BPP      (32)
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
 #define MW_SDL_RMASK (0xff000000)
 #define MW_SDL_GMASK (0x00ff0000)
 #define MW_SDL_BMASK (0x0000ff00)
#else
 #define MW_SDL_RMASK (0x000000ff)
 #define MW_SDL_GMASK (0x0000ff00)
 #define MW_SDL_BMASK (0x00ff0000)
#endif

/*#define _DEBUG (1)*/


/* Static window info structure */
typedef struct {
	SDL_Rect src;
    SDL_Rect dest; 
    SDL_Surface *image;
	SDL_Overlay *ovl;
	int pixelFormat;
    int pixelOrder;
    int rowMajor;
    int width;
    int height;
} WindowInfo_t;

typedef struct {
    volatile int enabled;
    volatile int isVideoModeSet;
	SDL_Event event;
    SDL_Surface *screen;
    WindowInfo_t windowInfo[MW_SDL_NUM_MAX_WINDOWS];
} DisplayInfo_t;

/* The variable is initialized to 0 when DLL is loaded */
static DisplayInfo_t dispInfo;

/* Forward declarations */
static void MW_windowShutdown(int window);
static void MW_globalVideoShutdown(void);
static void MW_pollSDLEvent(void);
void MW_SDLCleanup(void);

/* Initialize required SDL subsystems */
static int MW_globalVideoInit(void)
{   
#ifdef __linux__
    /* Make sure that DISPLAY environment variable is defined. If not, 
     * SDL does not start properly in X11 based implementations */
    char *tmp;

    tmp = getenv("DISPLAY");
#ifdef _DEBUG
    if (tmp != NULL) {
        printf("Using DISPLAY=%s\n", tmp);
    } else {
        printf("DISPLAY environment variable is not defined.\n");
    }
#endif /* _DEBUG */
    if (tmp == NULL) {
        if (setenv("DISPLAY", ":0.0", 0) == -1) {
            /* This is not an error condition. Just print out a warning. 
             * SDL might be running without X11 */
            fprintf(stderr, "Unable to set DISPLAY to :0.0\n");
        }
        tmp = getenv("DISPLAY");
        if (tmp != NULL) {
            printf("DISPLAY set to '%s'\n", tmp);
        } else {
            printf("Could not set DISPLAY to ':0.0'.\n");
        }
    }
    fflush(stdout);
    fflush(stderr);
#endif
    
    /* Initialize video module only if it not initialized */
    if (!SDL_WasInit(SDL_INIT_VIDEO)) {
        /* SDL_INIT_NOPARACHUTE: don't catch fatal signals */
        /* SDL_INIT_VIDEO: initialize VIDEO subsystem */
        if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_NOPARACHUTE) < 0) {
            fprintf(stderr, "Unable to init SDL: %s\n", SDL_GetError());
            fflush(stderr);
            return -1;
        }
    }
    
#ifdef _DEBUG
    {
        SDL_version sdlVer;
            
        sdlVer = *SDL_Linked_Version();
        fprintf(stdout, "SDL runtime version: %d.%d.%d\n", 
                sdlVer.major, sdlVer.minor, sdlVer.patch);
        fflush(stdout);
    }
#endif /* _DEBUG */
    
    return 0;    
}

/* Handles QUIT event. We ignore all other events. If we catch
 * a QUIT event, we uninitialize the SDL surface and close SDL 
 * screen. We return 0 to make sure SDL does not pass the event
 * to the main application (an issue in WINDOWS) 
 */
static int MW_eventFilter(const SDL_Event *event)
{    
    if(event->type == SDL_QUIT) {        
#if defined(MATLAB_MEX_FILE) 
		MW_SDLCleanup();
#else
		return 1; /* This enables QUIT event to be caught in SDL_pollEvents */
#endif
    }    
    
    /* Ignore all events. QUIT is handled above */
    return 0;
}


/* Initializes SDL screen */
static int MW_screenInit(void) {
    char sdlEnvPos[40];
    WindowInfo_t *currWindow = &(dispInfo.windowInfo[0]);
    
#ifndef __linux__
    /* Set up the screen */
    /* "SDL_VIDEO_CENTERED=center", "SDL_VIDEO_WINDOW_POS=x,y" */
    sprintf(sdlEnvPos, "SDL_VIDEO_WINDOW_POS=%d,%d", 
            MW_SDL_SCREEN_ORIGIN_X, MW_SDL_SCREEN_ORIGIN_Y);

    SDL_putenv(sdlEnvPos);     
#endif
    SDL_WM_SetCaption("SDL Video Display", NULL); 
	dispInfo.screen = SDL_SetVideoMode(currWindow->width, 
            currWindow->height, MW_SDL_SCREEN_BPP, 
            SDL_DOUBLEBUF | SDL_SWSURFACE);
	if(dispInfo.screen == NULL) {
        fprintf(stderr, "Unable to set video mode: %s\n", SDL_GetError());
		fflush(stderr);
		return -1;    
	}
  
	/* Install an event filter to catch WM quit event */
    SDL_SetEventFilter(&MW_eventFilter); 

    return 0;
}

/* Set the parameters of the video window */
static void MW_setWindowParams
(
    int window, 
    int pixelFormat, 
    int pixelOrder, 
    int rowMajor, 
    int width, 
    int height
)
{
    WindowInfo_t *currWindow = &(dispInfo.windowInfo[window]);
    
	/* Sanity check on input parameters */
    assert((window >= 0) && (window < MW_SDL_NUM_MAX_WINDOWS));
	assert((pixelFormat > 0) && (pixelFormat < MW_SDL_PIXEL_FORMAT_RESERVED));
	assert((pixelOrder > 0) && (pixelOrder < MW_SDL_PIXEL_ORDER_RESERVED));
    
    /* Set source and destination rectangles */
    currWindow->pixelFormat = pixelFormat;
    currWindow->pixelOrder  = pixelOrder;
	currWindow->image       = NULL;
    currWindow->ovl         = NULL;

	/* Set width & height of the SDL screen */
	if (currWindow->pixelOrder == MW_SDL_PIXEL_ORDER_INTERLEAVED) {
		/* Interleaved formats are assumed to be directly coming from 
		the input device, hence row major format */
        currWindow->rowMajor = 1; 
	}
	else {
		currWindow->rowMajor = rowMajor;
	}
    if (currWindow->rowMajor) {
		if (currWindow->pixelOrder == MW_SDL_PIXEL_ORDER_INTERLEAVED) {
			if (currWindow->pixelFormat == MW_SDL_PIXEL_FORMAT_RGB) {
				assert((width % 3) == 0);
				currWindow->width  = width / 3; /* (1R + 1G + 1B)x(height) */
                currWindow->height = height;
			}
			else {
				assert((width & 0x1) == 0);
				currWindow->width  = width / 2; /* (1Y + 0.5Cb + 0.5Cr)x(height) */
                currWindow->height = height;
			}
		}
		else {
            currWindow->width  = width;
            currWindow->height = height;
		}
    } 
    else {
		/* No interleaved format in column major */
        currWindow->width  = height;
        currWindow->height = width;
    }
}

/* Initialize an SDL surface representing Video Display window */
static int MW_windowInit(int window)
{
    WindowInfo_t *currWindow = &(dispInfo.windowInfo[window]);
    
	/* Set source and destination rectangles */
    currWindow->src.x  = 0;
    currWindow->src.y  = 0;
    currWindow->src.w  = currWindow->width;
    currWindow->src.h  = currWindow->height;
    currWindow->dest.x = 0;
    currWindow->dest.y = 0;
    currWindow->dest.w = currWindow->width;
    currWindow->dest.h = currWindow->height;
	if (currWindow->pixelFormat == MW_SDL_PIXEL_FORMAT_RGB) {
		currWindow->image = SDL_CreateRGBSurface(SDL_SWSURFACE, 
				currWindow->width, currWindow->height, 
				MW_SDL_SCREEN_BPP, 
				MW_SDL_RMASK, 
				MW_SDL_GMASK, 
				MW_SDL_BMASK, 
				0);
		if (currWindow->image == NULL) {
            fprintf(stderr, "Unable to create RGB surface: %s\n", SDL_GetError());
		    return -1; 
		}
	} else {
        currWindow->ovl = SDL_CreateYUVOverlay(currWindow->width, 
                currWindow->height, 
			    SDL_YUY2_OVERLAY, 
			    dispInfo.screen);
		if (currWindow->ovl == NULL) {
			fprintf(stderr, "Unable to create YUV overlay: %s\n", SDL_GetError());
		    return -1;    
		}
	}

	return 0;
}

/* Free SDL surface allocated for displaying video */
static void MW_windowShutdown(int window)
{
	WindowInfo_t *currWindow = &(dispInfo.windowInfo[window]);

    if (SDL_WasInit(SDL_INIT_VIDEO)) {
        if (currWindow->pixelFormat == MW_SDL_PIXEL_FORMAT_RGB) {
            SDL_FreeSurface(dispInfo.windowInfo[window].image);
            dispInfo.windowInfo[window].image = NULL;
        }
        else {
            SDL_FreeYUVOverlay(dispInfo.windowInfo[window].ovl);
			dispInfo.windowInfo[window].ovl = NULL;
        }
    }
}

/* Destroy the SDL screen */
static void MW_globalVideoShutdown(void)
{
    if (SDL_WasInit(SDL_INIT_VIDEO)) {
        SDL_QuitSubSystem(SDL_INIT_VIDEO);
    }
}

/* Callback function for MEX exit events */
void MW_SDLCleanup(void)
{
    MW_windowShutdown(0);
	MW_globalVideoShutdown();
    dispInfo.enabled = 0;
}

/* Polls for SDL events. Closes the SDL screen if QUIT event is 
 * detected
 */
static void MW_pollSDLEvent(void)
{
	if (dispInfo.enabled) {
	    while (SDL_PollEvent(&(dispInfo.event))) {
            if (dispInfo.event.type == SDL_QUIT) {
                MW_SDLCleanup(); /* Modifies dispInfo.enabled */
            }
        }
    }
}

/* Draw a YUYV overlay onto the screen */
static void MW_drawYUV(int window, Uint8 *yPtr, Uint8 *uPtr, Uint8 *vPtr)
{
	WindowInfo_t *currWindow = &(dispInfo.windowInfo[window]);
	
	/* Return if YUV overlay is not initialized */
	if (currWindow->ovl == NULL) {
		return;
	}

    /* Fill in pixel data - the pitches array contains the length of a line in each plane */
	if (SDL_LockYUVOverlay(currWindow->ovl) < 0) {
		return;
	}
    if (currWindow->pixelOrder == MW_SDL_PIXEL_ORDER_INTERLEAVED) {
		Uint8 *yuyvPtr;
		int i, lineSize = 2 * (currWindow->ovl->w); /* 1Y + 0.5Cb + 0.5Cr */
		
		/* There is no distinction between row/column major in interleaved formats */
		yuyvPtr = currWindow->ovl->pixels[0];
		if ((currWindow->ovl->pitches[0] - lineSize) != 0) {
			/* Copy one line at a time */
			for (i = 0; i < currWindow->ovl->h; i++) {
				memcpy(yuyvPtr, yPtr, lineSize);
				yuyvPtr += currWindow->ovl->pitches[0];
				yPtr    += lineSize;
			}
		}
		else {
			/* Copy entire image frame */
			memcpy(yuyvPtr, yPtr, lineSize * (currWindow->ovl->h));
		}
    } 
    else {
        Uint8 *yuyvPtr;
        int i, j;
		int yuyvAdvance;
        
		if (currWindow->rowMajor) {
			yuyvPtr    = currWindow->ovl->pixels[0];
			yuyvAdvance = currWindow->ovl->pitches[0] - (2 * (currWindow->ovl->w));
			for (i = 0; i < currWindow->ovl->h; i++) {
				for (j = 0; j < ((currWindow->ovl->w) >> 1); j++) {
				   *yuyvPtr++ = *yPtr++;
				   *yuyvPtr++ = *uPtr++;
				   *yuyvPtr++ = *yPtr++;
				   *yuyvPtr++ = *vPtr++;
				}
				yuyvPtr += yuyvAdvance; 
			}
		}
		else {
            yuyvAdvance = currWindow->ovl->pitches[0] - 4;
			for (i = 0; i < ((currWindow->ovl->w) >> 1); i++) {
				yuyvPtr = currWindow->ovl->pixels[0] + (i << 2);
		        for (j = 0; j < (currWindow->ovl->h); j++) {
				   *yuyvPtr++ = yPtr[0]; 
				   *yuyvPtr++ = *uPtr++;
                   *yuyvPtr++ = yPtr[currWindow->ovl->h];
				   *yuyvPtr++ = *vPtr++;
				   yuyvPtr   += yuyvAdvance;
				   yPtr      += 1;
				}
				yPtr += currWindow->ovl->h;
			}
	    }
    }
    SDL_UnlockYUVOverlay(currWindow->ovl);

	/* Display YUV data on the screen */
    SDL_DisplayYUVOverlay(currWindow->ovl, &(currWindow->dest));
}

/* Draws an RGB image to SDL screen */
static void MW_drawRGB(int window, Uint8 *rPtr, Uint8 *gPtr, Uint8 *bPtr)
{
	WindowInfo_t *currWindow = &(dispInfo.windowInfo[window]);
	Uint32 *imgPtr;
	Uint8 Rshift, Gshift, Bshift;
	SDL_Surface *image;
	int i;

	/* Return if RGB surface is not initialized */
	if (currWindow->image == NULL) {
		return;
	}

	/* Lock */
    if(SDL_MUSTLOCK(dispInfo.screen)) {
        if(SDL_LockSurface(dispInfo.screen) < 0) return;
    }

	/* Draw according to pixel format */
	if (currWindow->pixelOrder == MW_SDL_PIXEL_ORDER_INTERLEAVED) {
		/* There is no distinction between row/column major in interleaved formats */
		image = currWindow->image;
		Rshift = image->format->Rshift;
		Gshift = image->format->Gshift;
		Bshift = image->format->Bshift;
		imgPtr = (Uint32 *) (image->pixels);
		for (i = 0; i < (image->w * image->h); i++) {
		    *imgPtr++ = (rPtr[0] << (Rshift)) |      /* gPtr and bPtr are not used */
					    (rPtr[1] << (Gshift)) |
					    (rPtr[2] << (Bshift));
			rPtr += 3;
		}
	}
	else {
		image = currWindow->image;
		Rshift = image->format->Rshift;
		Gshift = image->format->Gshift;
		Bshift = image->format->Bshift;
		imgPtr = (Uint32 *) (image->pixels);
		if (currWindow->rowMajor) {
			for (i = 0; i < (image->w * image->h); i++) {
				*imgPtr++ = (*rPtr++ << (Rshift)) | 
							(*gPtr++ << (Gshift)) |
							(*bPtr++ << (Bshift));
			}
		}
		else { /* Column major */
			int j; 

			for (i = 0; i < image->w; i++) {
				for (j = 0; j < image->h; j++) {
					*imgPtr = (*rPtr++ << (Rshift)) | 
							  (*gPtr++ << (Gshift)) |
							  (*bPtr++ << (Bshift));
					imgPtr += image->w;
				}
				imgPtr = ((Uint32 *) (image->pixels)) + i;
			}
		}
	}

	/* Unlock */
    if(SDL_MUSTLOCK(dispInfo.screen)) {
        SDL_UnlockSurface(dispInfo.screen);
    }

    /* Draw onto the screen */
    SDL_BlitSurface(image, &(currWindow->src), dispInfo.screen, &(currWindow->dest));
    SDL_Flip(dispInfo.screen);
}

/* Draws an image frame to SDL display screen */
void MW_drawFrame(int window, Uint8 *pln0, Uint8 *pln1, Uint8 *pln2)
{
    WindowInfo_t *currWindow = &(dispInfo.windowInfo[window]);
    
    if (currWindow->pixelFormat == MW_SDL_PIXEL_FORMAT_RGB) {
        MW_drawRGB(0, pln0, pln1, pln2);
    }
    else {
        MW_drawYUV(0, pln0, pln1, pln2);
    }
}


/* SIMULINK interface functions */
/* Simulink interface for START function */
void MW_SDL_videoDisplayInit
(
    int pixelFormat, 
    int pixelOrder, 
    int rowMajor,
    int width, 
    int height 
)
{
    /* Initialize to enabled */
    dispInfo.enabled        = 1;
    dispInfo.isVideoModeSet = 0;
    
    /* Store video window parameters */
    MW_setWindowParams(0, pixelFormat, pixelOrder, 
                       rowMajor, width, height);
    if (MW_globalVideoInit() < 0) {
        dispInfo.enabled = 0;
        return;
    }
#if (0)
    if ((MW_screenInit() < 0) || (MW_windowInit(0) < 0)) {
        MW_globalVideoShutdown();
        dispInfo.enabled = 0;
        return;
    }
    dispInfo.enabled = 1;

	/* Process first few WM events */
	MW_pollSDLEvent(); 
#endif
#ifdef MATLAB_MEX_FILE
	/* Register cleanup-function */
	mexAtExit(MW_SDLCleanup);
#endif
}

/* Simulink interface for OUTPUT function */
void MW_SDL_videoDisplayOutput(Uint8 *pln0, Uint8 *pln1, Uint8 *pln2)
{
    /* SDL_pollEvent can only be called from the thread that sets the video 
     * mode. Hence we do the video mode initialization here. */
    if (dispInfo.isVideoModeSet == 0) {
        dispInfo.isVideoModeSet = 1;
        if ((MW_screenInit() < 0) || (MW_windowInit(0) < 0)) {
            MW_globalVideoShutdown();
            dispInfo.enabled = 0;
        } 
        else {
            dispInfo.enabled = 1;

            /* Process first few WM events */
            MW_pollSDLEvent(); 
       }
    }
    
    /* If window is closed, do not update */
    if (dispInfo.enabled) {    
        MW_drawFrame(0, pln0, pln1, pln2);
        MW_pollSDLEvent();
    }
}

/* Simulink interface for TERMINATE function */
void MW_SDL_videoDisplayTerminate(int width, int height)
{
    dispInfo.isVideoModeSet = 0;
    if (dispInfo.enabled) {
#ifdef MATLAB_MEX_FILE
		/* In simulation, stop event does not close the screen.
		   We just destroy the surface created to draw images. */
        MW_windowShutdown(0);
#else
        /* Destroy the SDL surfaces and the screen. */
		/* Note that this call modifies dispInfo.screen */
		MW_SDLCleanup();
#endif
    }
}
#endif /* !defined(EXT_MODE) */

/* EOF */