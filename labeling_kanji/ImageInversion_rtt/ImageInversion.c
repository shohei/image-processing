/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: ImageInversion.c
 *
 * Code generated for Simulink model 'ImageInversion'.
 *
 * Model version                  : 1.3
 * Simulink Coder version         : 8.8 (R2015a) 09-Feb-2015
 * TLC version                    : 8.8 (Jan 19 2015)
 * C/C++ source code generated on : Tue Feb  2 19:37:36 2016
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "ImageInversion.h"
#include "ImageInversion_private.h"
#include "ImageInversion_dt.h"

/* Block signals (auto storage) */
B_ImageInversion_T ImageInversion_B;

/* Real-time model */
RT_MODEL_ImageInversion_T ImageInversion_M_;
RT_MODEL_ImageInversion_T *const ImageInversion_M = &ImageInversion_M_;

/* Model output function */
void ImageInversion_output(void)
{
  int32_T i;

  /* S-Function (v4l2_video_capture_sfcn): '<Root>/V4L2 Video Capture' */
  MW_videoCaptureOutput(ImageInversion_ConstP.V4L2VideoCapture_p1,
                        ImageInversion_B.V4L2VideoCapture_o1,
                        ImageInversion_B.V4L2VideoCapture_o2,
                        ImageInversion_B.V4L2VideoCapture_o3);

  /* Sum: '<Root>/Sum' incorporates:
   *  Constant: '<Root>/Constant'
   */
  for (i = 0; i < 76800; i++) {
    ImageInversion_B.Sum[i] = (uint8_T)(ImageInversion_P.Constant_Value -
      ImageInversion_B.V4L2VideoCapture_o1[i]);
  }

  /* End of Sum: '<Root>/Sum' */

  /* Sum: '<Root>/Sum1' incorporates:
   *  Constant: '<Root>/Constant'
   */
  for (i = 0; i < 76800; i++) {
    ImageInversion_B.Sum1[i] = (uint8_T)(ImageInversion_P.Constant_Value -
      ImageInversion_B.V4L2VideoCapture_o2[i]);
  }

  /* End of Sum: '<Root>/Sum1' */

  /* Sum: '<Root>/Sum2' incorporates:
   *  Constant: '<Root>/Constant'
   */
  for (i = 0; i < 76800; i++) {
    ImageInversion_B.Sum2[i] = (uint8_T)(ImageInversion_P.Constant_Value -
      ImageInversion_B.V4L2VideoCapture_o3[i]);
  }

  /* End of Sum: '<Root>/Sum2' */

  /* S-Function (sdl_video_display_sfcn): '<Root>/SDL Video Display' */
  MW_SDL_videoDisplayOutput(ImageInversion_B.Sum, ImageInversion_B.Sum1,
    ImageInversion_B.Sum2);
}

/* Model update function */
void ImageInversion_update(void)
{
  /* signal main to stop simulation */
  {                                    /* Sample time: [0.1s, 0.0s] */
    if ((rtmGetTFinal(ImageInversion_M)!=-1) &&
        !((rtmGetTFinal(ImageInversion_M)-ImageInversion_M->Timing.taskTime0) >
          ImageInversion_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(ImageInversion_M, "Simulation finished");
    }

    if (rtmGetStopRequested(ImageInversion_M)) {
      rtmSetErrorStatus(ImageInversion_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  ImageInversion_M->Timing.taskTime0 =
    (++ImageInversion_M->Timing.clockTick0) * ImageInversion_M->Timing.stepSize0;
}

/* Model initialize function */
void ImageInversion_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)ImageInversion_M, 0,
                sizeof(RT_MODEL_ImageInversion_T));
  rtmSetTFinal(ImageInversion_M, -1);
  ImageInversion_M->Timing.stepSize0 = 0.1;

  /* External mode info */
  ImageInversion_M->Sizes.checksums[0] = (627431664U);
  ImageInversion_M->Sizes.checksums[1] = (1423153118U);
  ImageInversion_M->Sizes.checksums[2] = (215680453U);
  ImageInversion_M->Sizes.checksums[3] = (3141334173U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    ImageInversion_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(ImageInversion_M->extModeInfo,
      &ImageInversion_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(ImageInversion_M->extModeInfo,
                        ImageInversion_M->Sizes.checksums);
    rteiSetTPtr(ImageInversion_M->extModeInfo, rtmGetTPtr(ImageInversion_M));
  }

  /* block I/O */
  (void) memset(((void *) &ImageInversion_B), 0,
                sizeof(B_ImageInversion_T));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    ImageInversion_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  /* Start for S-Function (v4l2_video_capture_sfcn): '<Root>/V4L2 Video Capture' */
  MW_videoCaptureInit(ImageInversion_ConstP.V4L2VideoCapture_p1, 0, 0, 0, 0,
                      320U, 240U, 2U, 2U, 1U, 0.1);

  /* Start for S-Function (sdl_video_display_sfcn): '<Root>/SDL Video Display' */
  MW_SDL_videoDisplayInit(1, 1, 1, 320, 240);
}

/* Model terminate function */
void ImageInversion_terminate(void)
{
  /* Terminate for S-Function (v4l2_video_capture_sfcn): '<Root>/V4L2 Video Capture' */
  MW_videoCaptureTerminate(ImageInversion_ConstP.V4L2VideoCapture_p1);

  /* Terminate for S-Function (sdl_video_display_sfcn): '<Root>/SDL Video Display' */
  MW_SDL_videoDisplayTerminate(320, 240);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
