#if !defined(USING_MAP_DATUM)

	#include "europa-1.dmm"
	#include "europa-2.dmm"
	#include "europa-3.dmm"
	#include "europa-4.dmm"

	#include "europa_areas.dm"
	#include "europa_unit_testing.dm"

	#define USING_MAP_DATUM /datum/map/europa

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Europa.

#endif
