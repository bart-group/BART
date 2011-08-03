/*
 *  SerialPort_C.h
 *  SerialPortSample
 *
 *  Created by Karsten Molka on 04.05.10.
 *  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <paths.h>
#include <termios.h>
#include <sysexits.h>
#include <sys/param.h>
#include <sys/select.h>
#include <sys/time.h>
#include <time.h>
#include <AvailabilityMacros.h>


#ifdef __MWERKS__
#define __CF_USE_FRAMEWORK_INCLUDES__
#endif

#include <CoreFoundation/CoreFoundation.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#if defined(MAC_OS_X_VERSION_10_3) && (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_3)
#include <IOKit/serial/ioss.h>
#endif
#include <IOKit/IOBSD.h>

// Apple internal modems default to local echo being on. If your modem has local echo disabled,
// undefine the following macro.
#define LOCAL_ECHO

#define kATCommandString	"AT\r"

#ifdef LOCAL_ECHO
#define kOKResponseString	"AT\r\r\nOK\r\n"
#else
#define kOKResponseString	"\r\nOK\r\n"
#endif

#define BAUD_ERR 1000
#define PARITY_ERR 1001
#define BITS_ERR 1002
#define DEVICENAME_ERR 1003
#define ModemInit_ERR 1010

typedef struct {
	int		secs;
	int		usecs;
} TIME_DIFF;

enum {
    kNumRetries = 3
};

// Hold the original termios attributes so we can reset them
static struct termios gOriginalTTYAttrs;

// Function prototypes
kern_return_t FindModems(io_iterator_t *matchingServices);
kern_return_t GetModemPath(io_iterator_t serialPortIterator, char *bsdPath, CFIndex maxPathSize, const char* deviceName, int lengthDeviceName);
int OpenSerialPort(const char *bsdPath, int baud, int parity, int bits, int *portDescriptor);
static char *LogString(char *str);
Boolean InitializeModemAndStartComm(int portDescriptor);

extern int FindAndOpenModem(const char *modemPath, int lengthModemPath, int baud, int parity, int bits, int *portDescriptor);
extern int InitAndStartModem(int portDescriptor);
extern int CloseSerialPort(int portDescriptor);
extern char ReadData(int fileDescriptor);

extern TIME_DIFF * my_difftime (struct timeval * start, struct timeval * end);

