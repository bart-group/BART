//
//  TimeUtil.h
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/7/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef BARTApplication_TimeUtil_h
#define BARTApplication_TimeUtil_h

#include <time.h>
#include <sys/time.h>
#include <math.h>

/**
 * Utility header for time measurement using standard C routines and types.
 */

// ###########
// # Structs
// ###########

typedef struct {
	long secs;  // Time in whole seconds
	long usecs; // Rest time in micro seconds (always less than 1 million)
} TimeDiff;

typedef struct timeval TimeVal;


// #########################
// # Function declarations
// #########################

TimeVal now();

TimeDiff*  newTimeDiff(TimeVal* start, 
                       TimeVal* end);

char* newTimeDiffString(TimeDiff* t);

double asDouble(TimeVal*);
double asDouble(TimeDiff*);
double asDouble(long secs, long usecs);



// ########################
// # Function definitions
// ########################

TimeVal now() 
{
    TimeVal now;
    
    struct timezone tz;
    tz.tz_minuteswest = 60;
    tz.tz_dsttime = DST_MET;
    
    gettimeofday(&now, &tz);
    
    return now;
}

TimeDiff* newTimeDiff (TimeVal* start, TimeVal* end)
{
	TimeDiff* diff = (TimeDiff*) malloc (sizeof(TimeDiff));
	
	if (start->tv_sec == end->tv_sec) {
		diff->secs = 0;
		diff->usecs = end->tv_usec - start->tv_usec;
	} else {
		diff->usecs = 1000000 - start->tv_usec;
		diff->secs = end->tv_sec - (start->tv_sec + 1);
		diff->usecs += end->tv_usec;
		if (diff->usecs >= 1000000) {
			diff->usecs -= 1000000;
			diff->secs += 1;
		}
	}
	
	return diff;
}

char* newTimeDiffString(TimeDiff* t) {        
    if (t == NULL) {
        return NULL;
    } else {
        char* s = (char*) malloc((1                          // optional signum
                                  + long(log10(t->secs)) + 1 // number of digits showing the seconds
                                  + 6                        // number of digits showing microseconds (past decimal dot) 
                                  + 1)                       // Null termination of the string
                                 * sizeof(char));
        
        sprintf(s, "%ld.%06ld", t->secs, t->usecs);
        
        return s;
    }
}

double asDouble(TimeVal* tv)
{
    return asDouble(tv->tv_sec, tv->tv_usec);
}

double asDouble(TimeDiff* td) 
{
    return asDouble(td->secs, td->usecs);
}

double asDouble(long secs, long usecs)
{
    return ((double) secs) + (usecs / 1000000.0);
}

#endif
