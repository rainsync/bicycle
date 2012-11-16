#include "bool.h"
#include "geometry.h"
#include <math.h>

void convex_hull(point in[], int n, polygon *hull);
void sort_and_remove_duplicates(point in[], int *n);
BOOL leftlower(point *p1, point *p2);
BOOL smaller_angle(point *p1, point *p2);