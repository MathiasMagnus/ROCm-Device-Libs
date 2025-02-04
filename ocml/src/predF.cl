/*===--------------------------------------------------------------------------
 *                   ROCm Device Libraries
 *
 * This file is distributed under the University of Illinois Open Source
 * License. See LICENSE.TXT for details.
 *===------------------------------------------------------------------------*/

#include "mathF.h"

CONSTATTR float
MATH_MANGLE(pred)(float x)
{
    int ix = AS_INT(x);
    int mx = SIGNBIT_SP32 - ix;
    mx = ix < 0 ? mx : ix;
    int t = mx - BUILTIN_CLASS_F32(x, CLASS_NNOR|CLASS_NSUB|CLASS_NZER|CLASS_PZER|CLASS_PSUB|CLASS_PNOR|CLASS_PINF);
    int r = SIGNBIT_SP32 - t;
    r = t < 0 ? r : t;
    return AS_FLOAT(r);
}

