#ifndef SINCOS_COMPAT_H
#define SINCOS_COMPAT_H

#include <math.h>

// Define a sincos compatibility function for macOS and ARM64
static inline void sincos(double x, double *s, double *c) {
    *s = sin(x);
    *c = cos(x);
}

#endif
