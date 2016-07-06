/* Copyright 2010-2012 The MathWorks, Inc. */
#include "v4l2_capture.h"
#ifdef MATLAB_MEX_FILE
#include "mex.h"
#endif /* #ifdef MATLAB_MEX_FILE */


/* 
#define _MW_V4L2_DEBUG_
#define _MW_V4L2_DEBUG_LVL2_
*/

/* Forward declarations */
static void terminateDevice(MW_videoInfo_t *h);
static void videoCaptureCleanup(void);
static void destroyDevice(MW_videoInfo_t *h);

/* Global data */
static MW_videoInfo_t hVideoDev[MW_NUM_MAX_VIDEO_DEVICES];
#if (defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER))
 static char errMsg[ERR_MSG_BUF_SIZE];
#endif

/* Include appropriate code generation files */
/* depending on OS */
#if defined(__linux__) 
 #include "v4l2_capture_linux.c"
#endif
#if defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER)
 #include "v4l2_capture_simulation.c"
#endif

/* Return a handle to device instance given device names */
static MW_videoInfo_t *getDeviceHandle(const uint8_T *devName)
{
	int devIndx = -1;
	unsigned int i;

	/* We have to search all entries since blocks can be called out of order */
	for (i = 0; i < MW_NUM_MAX_VIDEO_DEVICES; i++) {
		if ((hVideoDev[i].fd != 0) && (strcmp((const char *)hVideoDev[i].devName, (const char *)devName) == 0)) {
			devIndx = i;
			break;
		}
	}

	if (devIndx == -1) {
		return NULL;
	}
	else {
        return(&hVideoDev[i]);
	}
}

/* Return number of bytes required to store a single horizontal line */
/* of image given format */
uint32_T getBytesPerLine(uint32_T pixelFormat, uint32_T width)
{
	uint32_T bytesPerLine;

	switch (pixelFormat) {
		case MW_YCBCR422:
			bytesPerLine = 2 * width;
			break;
		case MW_RGB:
			bytesPerLine = 3 * width;
			break;
		default:
            bytesPerLine = 0;
			break;
	}

	return bytesPerLine;
}

#if (0)
/* Return chroma dimensions (relative to luminance) given image format */
static void getChromaDims(uint32_T pixelFormat, uint32_T yWidth, uint32_T *cWidth, uint32_T *cHeight)
{
	switch (pixelFormat) {
		case YUYV:
		case UYVY:
			*cWidth  = yWidth >> 1;
			*cHeight = yWidth;
			break;
		case GREY:
		case Y16:  /* Grey with 16-bpp */
        case YUV422P:
		case YUV420:
		case YVU420:
		case Y41P:
        case YUV411P:
        case NV12:
		case NV21:
        case YUV444:
		case YUV555:
		case YUV565:
		case YUV32:
            *cWidth  = 0;
			*cHeight = 0;
			break;
	}
}
#endif

/* Create a new device instance */
static MW_videoInfo_t *newDevice(void)
{
    MW_videoInfo_t *h;
	uint32_T i;

    /* Find an unused video device */
	h = NULL;
	for (i = 0; i < MW_NUM_MAX_VIDEO_DEVICES; i++) {
		if (hVideoDev[i].fd == 0) {
			h = &hVideoDev[i];
			memset(h, 0, sizeof(MW_videoInfo_t));
			h->fd = -1; /* -1 indicates device is not opened yet  */
			break;
		}
	}
	if (h == NULL) {
		MW_ERROR_EXIT1("Too many video devices. Number of video devices must be smaller than %d\n",
			MW_NUM_MAX_VIDEO_DEVICES);
	}

	return h;
}

/* Destroy a device instance */
static void destroyDevice(MW_videoInfo_t *h)
{
	if (h != NULL) {
	    memset(h, 0, sizeof(MW_videoInfo_t));
	}
}

/* Check device parameters for validity */
/* 1. Each video device must use a unique device name */
/* 2. Live video capture is not supported in Windows  */
static void checkDeviceParams(const uint8_T *devName, uint32_T simOutput, uint32_T pixelFormat, uint32_T imWidth)
{
    MW_videoInfo_t *h;

#if (defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER)) && !defined(__linux__)
	/* Check if live video capture in simulation is supported */
	if (simOutput == SIM_OUTPUT_LIVE_VIDEO) {
	    MW_ERROR_EXIT("Live video capture is not supported on Windows platforms. "
			"Select a simulation output that generates a synthetic image.\n");
	}
#endif

	/* Check if we have a device instance with the same name */
	h = getDeviceHandle(devName);
	if (h != NULL) {
	    MW_ERROR_EXIT1("Each Video Capture block must use a unique Video device name. "
			"Video device name %s is already used.", devName);
	}

	/* Check that pixel format is in range */
	if ((pixelFormat != MW_YCBCR422) && (pixelFormat != MW_RGB)) {
		MW_ERROR_EXIT1("Unknown Pixel format %d.", pixelFormat);
	}

	/* Image width must be even in YCbCr 4:2:2 mode */
	if ((pixelFormat == MW_YCBCR422) && ((imWidth & 0x1) != 0)) {
		MW_ERROR_EXIT1("%s: Image width must be even when Pixel order is YCbCr 4:2:2. "
			"This format has half as many chroma samples as that of luminance plane.",  devName);
	}
}

/* Initialization routine for video capture module */
void MW_videoCaptureInit
(
        const uint8_T *devName, /* p1 */
        int32_T roiTop,         /* p2 */
        int32_T roiLeft,        /* p3 */
        int32_T roiWidth,       /* p4 */
        int32_T roiHeight,      /* p5 */
        uint32_T imWidth,       /* p6 */
        uint32_T imHeight,      /* p7 */
        uint32_T pixelFormat,   /* p8 */
        uint32_T pixelOrder,    /* p9 */
        uint32_T simOutput,     /* p10 */
        real_T sampleTime       /* p11 */
)
{
    MW_videoInfo_t *h;
    unsigned int i;

	/* Check device parameters for validity */
	checkDeviceParams(devName, simOutput, pixelFormat, imWidth);

	/* Create a new video device instance */
    h                       = newDevice();
    h->devName = (uint8_T*)malloc(strlen((char*)devName)+1);
    if (h->devName == NULL) {
        MW_ERROR_EXIT("Memory allocation error.");
    }
	strcpy((char*)h->devName, (char*)devName);
    h->roi.top              = roiTop;         /* Stores cropping rectangle (ROI from block mask) */
	h->roi.left             = roiLeft;
	h->roi.width            = roiWidth;
	h->roi.height           = roiHeight;
    h->imFormat.width       = imWidth;        /* Capture width */
    h->imFormat.height      = imHeight;       /* Capture height */
	h->imFormat.pln12Width  = 0;              /* Used for chroma sub-sampled formats */
	h->imFormat.pixelFormat = pixelFormat;    /* Stores image size and pixel format */
    h->pixelOrder           = pixelOrder;     /* Interleave / planar selection */
	h->hRgbRefLine          = NULL;
    h->frameRate            = 1.0/sampleTime; /* Frame rate */
    h->simOutput            = simOutput;      /* Generated output in simulation */
	h->frmCount             = 0;
    h->v4l2BufCount         = 0;
    h->v4l2CaptureStarted   = 0;
    for (i = 0; i < MW_NUM_V4L2_BUFFERS; i++) {
        h->frm[i].start  = NULL;
        h->frm[i].length = 0;
    }

#ifdef MATLAB_MEX_FILE
	/* Register cleanup-function */
	mexAtExit(videoCaptureCleanup);
#endif
    
	/* Open and initialize device */
#if (defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER)) && defined(__linux__) 
	/* Simulation && Linux */
	if (h->simOutput == SIM_OUTPUT_LIVE_VIDEO) {
#ifdef _MW_V4L2_DEBUG_LVL2_
        printf("\nOpening V4L2 device %s\n", devName);
#endif
	    openV4L2Device(h);
	    initV4L2Device(h);
	}
	else {
		openSimDevice(h);
		initSimDevice(h);
	}
#elif (defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER)) && !defined(__linux__) 
	/* Normal or Rapid Accelerator && not Linux */
    openSimDevice(h);
    initSimDevice(h);
#else
	/* Code generation */
    openV4L2Device(h);
	initV4L2Device(h);
#endif
}

/* Device termination function */
static void terminateDevice(MW_videoInfo_t *h)
{
	/* De-allocate buffers and close device file */
    if (h != NULL) {
#if (defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER)) && defined(__linux__) 
	    if (h->simOutput == SIM_OUTPUT_LIVE_VIDEO) {
	        closeV4L2Device(h);
	    }
	    else {
		    closeSimDevice(h);
	    }
#elif (defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER)) && !defined(__linux__)
	    closeSimDevice(h);
#else
	    /* We are generating code */
	    closeV4L2Device(h);
#endif
        if(h->devName) {
            free(h->devName);
        }
        destroyDevice(h);
    }
}

/* Simulink interface for video capture terminate function */
void MW_videoCaptureTerminate(const uint8_T *devName)
{
    MW_videoInfo_t *h = getDeviceHandle(devName);

#ifdef _MW_V4L2_DEBUG_LVL2_
	printf("\nTerminate for device %s\n", devName);
#endif
    if (h != NULL) {
        terminateDevice(h);
    }
}


/* Outputs an image frame */
/* In simulation mode either a synthetic image or live video (on Linux only) */
/* is output. In code generation, always outputs live video */
void MW_videoCaptureOutput(const uint8_T *devName, uint8_T *pln0, uint8_T *pln1, uint8_T *pln2)
{
	MW_videoInfo_t *h = getDeviceHandle(devName);

#if (defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER)) && defined(__linux__) 
	if (h->simOutput == SIM_OUTPUT_LIVE_VIDEO) {
        readV4L2Frame(h, pln0, pln1, pln2);
	}
	else {
        genSimOutput(h, pln0, pln1, pln2);
	}
#elif (defined(MATLAB_MEX_FILE) || defined(RSIM_WITH_SL_SOLVER)) && !defined(__linux__) 
	genSimOutput(h, pln0, pln1, pln2);
#else
	readV4L2Frame(h, pln0, pln1, pln2);
	if (h->pixelOrder == PIXEL_ORDER_PLANAR) {
		/*interleaved2planar(pln0, pln0);*/
	}
#endif
	h->frmCount++;
}

/* Clean-up routine that gets executed */
/* when MW_ERROR_EXIT? macro is called */
static void videoCaptureCleanup(void) {
	uint32_T i;

	for (i = 0; i < MW_NUM_MAX_VIDEO_DEVICES; i++) {
#ifdef _MW_V4L2_DEBUG_LVL2_
        printf("Cleaning up resources for %s. PID = %d\n", hVideoDev[i].devName, getpid());
#endif
		terminateDevice(&hVideoDev[i]);
	}
}


/* Use this routine for stand-alone build */
#ifdef _MW_STANDALONE_BUILD_
int main(int argc, char **argv)
{
    char *devName = "/dev/video0";
    static int fd = -1;
    struct v4l2_rect mwUserRoi = {0, 0, 2*160, 2*120};
    struct v4l2_pix_format mwUserFmt = {320, 240, GREY };

    fd = openDevice(devName);
    initDevice(fd, devName, &mwUserRoi, &mwUserFmt);
    closeDevice(fd, devName);

    return(EXIT_SUCCESS);
}
#endif /*#ifdef _MW_STANDALONE_BUILD_*/
