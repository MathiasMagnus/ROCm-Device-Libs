/*===--------------------------------------------------------------------------
 *                   ROCm Device Libraries
 *
 * This file is distributed under the University of Illinois Open Source
 * License. See LICENSE.TXT for details.
 *===------------------------------------------------------------------------*/

#include "mathD.h"

CONSTATTR double2
MATH_MANGLE(cexp)(double2 z)
{
    double x = z.s0;
    double y = z.s1;
    double cy;
    double sy = MATH_MANGLE(sincos)(y, &cy);
    bool g = x > 709.0;
    double ex = MATH_MANGLE(exp)(x - (g ? 1.0f : 0.0f));
    const double e1 =  0x1.5bf0a8b145769p+1;
    cy *= g ? e1 : 1.0;
    sy *= g ? e1 : 1.0;
    double rr = ex * cy;
    double ri = ex * sy;

    if (!FINITE_ONLY_OPT()) {
        bool isfinite = BUILTIN_ISFINITE_F64(y);
        if (BUILTIN_CLASS_F64(x, CLASS_NINF)) {
            rr = 0.0;
            ri = isfinite ? ri : 0.0;
        }
        if (BUILTIN_CLASS_F64(x, CLASS_PINF)) {
            rr = isfinite ? rr : AS_DOUBLE(PINFBITPATT_DP64);
            ri = isfinite ? ri : AS_DOUBLE(QNANBITPATT_DP64);
            ri = y == 0.0 ? y : ri;
        }
        ri = (BUILTIN_ISNAN_F64(x) & (y == 0.0)) ? y : ri;
    }

    return (double2)(rr, ri);
}

