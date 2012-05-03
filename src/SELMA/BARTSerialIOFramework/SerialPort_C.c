/*
 *  SerialPort_C.c
 *  
 *
 *  Created by Karsten Molka on 04.05.10.
 *  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */

#include "SerialPort_C.h"

// Hold the original termios attributes so we can reset them
static struct termios gOriginalTTYAttrs;

// Returns an iterator across all known modems. Caller is responsible for
// releasing the iterator when iteration is complete.
kern_return_t FindModems(io_iterator_t *matchingServices)
{
    kern_return_t			kernResult; 
    CFMutableDictionaryRef	classesToMatch;
	
	/*! @function IOServiceMatching
	 @abstract Create a matching dictionary that specifies an IOService class match.
	 @discussion A very common matching criteria for IOService is based on its class. IOServiceMatching will create a matching dictionary that specifies any IOService of a class, or its subclasses. The class is specified by C-string name.
	 @param name The class name, as a const C-string. Class matching is successful on IOService's of this class or any subclass.
	 @result The matching dictionary created, is returned on success, or zero on failure. The dictionary is commonly passed to IOServiceGetMatchingServices or IOServiceAddNotification which will consume a reference, otherwise it should be released with CFRelease by the caller. */
	
    // Serial devices are instances of class IOSerialBSDClient
    classesToMatch = IOServiceMatching(kIOSerialBSDServiceValue);
    if (classesToMatch == NULL)
    {
        printf("IOServiceMatching returned a NULL dictionary.\n");
    }
    else {
		/*!
		 @function CFDictionarySetValue
		 Sets the value of the key in the dictionary.
		 @param theDict The dictionary to which the value is to be set. If this
		 parameter is not a valid mutable CFDictionary, the behavior is
		 undefined. If the dictionary is a fixed-capacity dictionary and
		 it is full before this operation, and the key does not exist in
		 the dictionary, the behavior is undefined.
		 @param key The key of the value to set into the dictionary. If a key 
		 which matches this key is already present in the dictionary, only
		 the value is changed ("add if absent, replace if present"). If
		 no key matches the given key, the key-value pair is added to the
		 dictionary. If added, the key is retained by the dictionary,
		 using the retain callback provided
		 when the dictionary was created. If the key is not of the sort
		 expected by the key retain callback, the behavior is undefined.
		 @param value The value to add to or replace into the dictionary. The value
		 is retained by the dictionary using the retain callback provided
		 when the dictionary was created, and the previous value if any is
		 released. If the value is not of the sort expected by the
		 retain or release callbacks, the behavior is undefined.
		 */
        CFDictionarySetValue(classesToMatch,
                             CFSTR(kIOSerialBSDTypeKey),
                             //CFSTR(kIOSerialBSDRS232Type)
							 CFSTR(kIOSerialBSDAllTypes))
		;
       
    }
    
    /*! @function IOServiceGetMatchingServices
	 @abstract Look up registered IOService objects that match a matching dictionary.
	 @discussion This is the preferred method of finding IOService objects currently registered by IOKit. IOServiceAddNotification can also supply this information and install a notification of new IOServices. The matching information used in the matching dictionary may vary depending on the class of service being looked up.
	 @param masterPort The master port obtained from IOMasterPort().
	 @param matching A CF dictionary containing matching information, of which one reference is consumed by this function. IOKitLib can contruct matching dictionaries for common criteria with helper functions such as IOServiceMatching, IOOpenFirmwarePathMatching.
	 @param existing An iterator handle is returned on success, and should be released by the caller when the iteration is finished.
	 @result A kern_return_t error code. */
	
    kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, classesToMatch, matchingServices);    
    if (KERN_SUCCESS != kernResult)
    {
        printf("IOServiceGetMatchingServices returned %d\n", kernResult);
		goto exit;
    }
	
exit:
    return kernResult;
}

// Given an iterator across a set of modems, return the BSD path to the first one.
// If no modems are found the path name is set to an empty string.
kern_return_t GetModemPath(io_iterator_t serialPortIterator, char *bsdPath, CFIndex maxPathSize, const char* deviceName, int lengthDeviceName)
{
    io_object_t		modemService;
    kern_return_t	kernResult = DEVICENAME_ERR;
    Boolean			modemFound = false;
    
    // Initialize the returned path
    *bsdPath = '\0';
    
    // Iterate across all modems found. In this example, we bail after finding the first modem.
    while ( (modemService = IOIteratorNext(serialPortIterator)) && !modemFound )
    {
        CFTypeRef	bsdPathAsCFString;
		
		// Get the callout device's path (/dev/cu.xxxxx). The callout device should almost always be
		// used: the dialin device (/dev/tty.xxxxx) would be used when monitoring a serial port for
		// incoming calls, e.g. a fax listener.
		
		bsdPathAsCFString = IORegistryEntryCreateCFProperty(modemService,
                                                            CFSTR(kIOCalloutDeviceKey),
                                                            kCFAllocatorDefault,
                                                            0);
        if (bsdPathAsCFString)
        {
            Boolean result;
            
            // Convert the path from a CFString to a C (NUL-terminated) string for use
			// with the POSIX open() call.
			
			result = CFStringGetCString(bsdPathAsCFString,
                                        bsdPath,
                                        maxPathSize, 
                                        kCFStringEncodingUTF8);
            CFRelease(bsdPathAsCFString);
            
            if (result)
			{
                int ret = strcmp(bsdPath, deviceName);
                printf("Modem found with BSD path: %s while searching for %s", bsdPath, deviceName);
                if (ret == 0) {
                    modemFound = true;
                    kernResult = KERN_SUCCESS;
                }
            }
        }
		
       printf("\n");
		
        // Release the io_service_t now that we are done with it.
		
		(void) IOObjectRelease(modemService);
    }
	
    return kernResult;
}

// Given the path to a serial device, open the device and configure it.
// Return the file descriptor associated with the device.
int OpenSerialPort(const char *bsdPath, int baud, int parenb, int parodd, int bits, int *portDescriptor)
{
    int				fileDescriptor = -1;
    int				handshake;
    struct termios	options;
    
    // Open the serial port read/write, with no controlling terminal, and don't wait for a connection.
    // The O_NONBLOCK flag also causes subsequent I/O on the device to be non-blocking.
    // See open(2) ("man 2 open") for details.
    
    fileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (fileDescriptor == -1)
    {
        printf("Error opening serial port %s - %s(%d).\n",
               bsdPath, strerror(errno), errno);
        goto error;
    }
    *portDescriptor = fileDescriptor;
	
    // Note that open() follows POSIX semantics: multiple open() calls to the same file will succeed
    // unless the TIOCEXCL ioctl is issued. This will prevent additional opens except by root-owned
    // processes.
    // See tty(4) ("man 4 tty") and ioctl(2) ("man 2 ioctl") for details.
    
    if (ioctl(fileDescriptor, TIOCEXCL) == -1)
    {
        printf("Error setting TIOCEXCL on %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
        goto error;
    }
    
    // Now that the device is open, clear the O_NONBLOCK flag so subsequent I/O will block.
    // See fcntl(2) ("man 2 fcntl") for details.
    
    if (fcntl(fileDescriptor, F_SETFL, 0) == -1)
    {
        printf("Error clearing O_NONBLOCK %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
        goto error;
    }
    
    // Get the current options and save them so we can restore the default settings later.
    if (tcgetattr(fileDescriptor, &gOriginalTTYAttrs) == -1)
    {
        printf("Error getting tty attributes %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
        goto error;
    }
	
    // The serial port attributes such as timeouts and baud rate are set by modifying the termios
    // structure and then calling tcsetattr() to cause the changes to take effect. Note that the
    // changes will not become effective without the tcsetattr() call.
    // See tcsetattr(4) ("man 4 tcsetattr") for details.
    
    options = gOriginalTTYAttrs;
    
    // Print the current input and output baud rates.
    // See tcsetattr(4) ("man 4 tcsetattr") for details.
    
    printf("Current input baud rate is %d\n", (int) cfgetispeed(&options));
    printf("Current output baud rate is %d\n", (int) cfgetospeed(&options));
    
    // Set raw input (non-canonical) mode, with reads blocking until either a single character 
    // has been received or a one second timeout expires.
    // See tcsetattr(4) ("man 4 tcsetattr") and termios(4) ("man 4 termios") for details.
    
    cfmakeraw(&options);
    options.c_cc[VMIN] = 0;
    options.c_cc[VTIME] = 0;
	
    // The baud rate, word length, and handshake options can be set as follows:
    
    
    // check parameters bsdPath, baud, parity, bits
    switch (baud) {
        case B57600:
            break;
        case B38400:
            break;
        case B19200:            
            break;
        case B9600:
            break;
        case B4800:
            break;
        case B2400:
            break;
        default:
            return BAUD_ERR;
            break;
    }
    
    switch (bits) {
        case CS8:
            break;
        case CS7:
            break;
        case CS6:
            break;
        case CS5:
            break;
        case 8:
            bits = CS8;
            break;
        case 7:
            bits = CS7;
            break;
        case 6:
            bits = CS6;
            break;
        case 5:
            bits = CS5;
            break;
        default:
            return BITS_ERR;
            break;
    }
    
    cfsetspeed(&options, baud);		// Set baud  
    
    if (PARENB == parenb){
        options.c_cflag |= (bits 	   | 	// Use xx bit words
                            CCTS_OFLOW | 	// CTS flow control of output
                            CRTS_IFLOW);	// RTS flow control of input
    }
    else{
        options.c_cflag |= (bits 	   | 	// Use xx bit words
                            parenb	   | 	// Parity enable
                            parodd     |    // if parity is enabled set this to use odd parity
                            CCTS_OFLOW | 	// CTS flow control of output
                            CRTS_IFLOW);	// RTS flow control of input
	}
    
#if defined(MAC_OS_X_VERSION_10_4) && (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_4)
	// Starting with Tiger, the IOSSIOSPEED ioctl can be used to set arbitrary baud rates
	// other than those specified by POSIX. The driver for the underlying serial hardware
	// ultimately determines which baud rates can be used. This ioctl sets both the input
	// and output speed. 
	
	speed_t speed = 14400; // Set 14400 baud
    if (ioctl(fileDescriptor, IOSSIOSPEED, &speed) == -1)
    {
        printf("Error calling ioctl(..., IOSSIOSPEED, ...) %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
    }
#endif
    
    // Print the new input and output baud rates. Note that the IOSSIOSPEED ioctl interacts with the serial driver 
	// directly bypassing the termios struct. This means that the following two calls will not be able to read
	// the current baud rate if the IOSSIOSPEED ioctl was used but will instead return the speed set by the last call
	// to cfsetspeed.
    
    printf("Input baud rate changed to %d\n", (int) cfgetispeed(&options));
    printf("Output baud rate changed to %d\n", (int) cfgetospeed(&options));
	
	
    
    // Cause the new options to take effect immediately.
    if (tcsetattr(fileDescriptor, TCSANOW, &options) == -1)
    {
        printf("Error setting tty attributes %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
        goto error;
    }
	
    // To set the modem handshake lines, use the following ioctls.
    // See tty(4) ("man 4 tty") and ioctl(2) ("man 2 ioctl") for details.
    
    if (ioctl(fileDescriptor, TIOCSDTR) == -1) // Assert Data Terminal Ready (DTR)
    {
        printf("Error asserting DTR %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
    }
    
    if (ioctl(fileDescriptor, TIOCCDTR) == -1) // Clear Data Terminal Ready (DTR)
    {
        printf("Error clearing DTR %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
    }
    
    handshake = TIOCM_DTR | TIOCM_RTS | TIOCM_CTS | TIOCM_DSR;
    if (ioctl(fileDescriptor, TIOCMSET, &handshake) == -1)
		// Set the modem lines depending on the bits set in handshake
    {
        printf("Error setting handshake lines %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
    }
    
    // To read the state of the modem lines, use the following ioctl.
    // See tty(4) ("man 4 tty") and ioctl(2) ("man 2 ioctl") for details.
    
    if (ioctl(fileDescriptor, TIOCMGET, &handshake) == -1)
		// Store the state of the modem lines in handshake
    {
        printf("Error getting handshake lines %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
    }
    
    printf("Handshake lines currently set to %d\n", handshake);
	
#if defined(MAC_OS_X_VERSION_10_3) && (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_3)
	unsigned long mics = 1UL;
	
	// Set the receive latency in microseconds. Serial drivers use this value to determine how often to
	// dequeue characters received by the hardware. Most applications don't need to set this value: if an
	// app reads lines of characters, the app can't do anything until the line termination character has been
	// received anyway. The most common applications which are sensitive to read latency are MIDI and IrDA
	// applications.
	
	if (ioctl(fileDescriptor, IOSSDATALAT, &mics) == -1)
	{
		// set latency to 1 microsecond
        printf("Error setting read latency %s - %s(%d).\n",
			   bsdPath, strerror(errno), errno);
        goto error;
	}
#endif
    
    // Success
    return 0;
    
    // Failure path
error:
    if (fileDescriptor != -1)
    {
        close(fileDescriptor);
    }
    
    return -1;
}

// Replace non-printable characters in str with '\'-escaped equivalents.
// This function is used for convenient logging of data traffic.
char *LogString(char *str)
{
    static char     buf[2048];
    char            *ptr = buf;
    int             i;
	
    *ptr = '\0';
	
    while (*str)
	{
		if (isprint(*str))
		{
			*ptr++ = *str++;
		}
		else {
			switch(*str)
			{
				case ' ':
					*ptr++ = *str;
					break;
					
				case 27:
					*ptr++ = '\\';
					*ptr++ = 'e';
					break;
					
				case '\t':
					*ptr++ = '\\';
					*ptr++ = 't';
					break;
					
				case '\n':
					*ptr++ = '\\';
					*ptr++ = 'n';
					break;
					
				case '\r':
					*ptr++ = '\\';
					*ptr++ = 'r';
					break;
					
				default:
					i = *str;
					(void)sprintf(ptr, "\\%03o", i);
					ptr += 4;
					break;
			}
			
			str++;
		}
		
		*ptr = '\0';
	}
	
    return buf;
}

// Given the file descriptor for a modem device, attempt to initialize the modem by sending it
// a standard AT command and reading the response. If successful, the modem's response will be "OK".
// Return true if successful, otherwise false.
int initializeModemAndStartComm(int fileDescriptor) {
    ssize_t		numBytes;		// Number of bytes read or written
    
    // Send an AT command to the modem
    numBytes = write(fileDescriptor, kATCommandString, strlen(kATCommandString));
        
    if (numBytes == -1) {
        printf("Error writing to modem - %s(%d).\n", strerror(errno), errno);
    }
    else {
        printf("Wrote %ld bytes \"%s\"\n", numBytes, LogString(kATCommandString));
    }
		
    if (numBytes < strlen(kATCommandString)) {
        return ModemInit_ERR;
    }
		
    printf("Looking for \"%s\"\n", LogString(kOKResponseString));
    
    //TODO Test auf OK String
    
    //return "true"
    return 1; 
}

char ReadData(int fileDescriptor, int *isValid) {
    
    char        buffer[1];	// Input buffer
    char        *bufPtr;		// Current char in buffer
    ssize_t     numBytes;		// Number of bytes read or written

    *isValid = 0;
    
    bufPtr = buffer;

    numBytes = read(fileDescriptor, bufPtr, 1);
    if (numBytes == -1)
    {
        printf("Error reading from modem - %s(%d).\n", strerror(errno), errno);
        return '\n';
    }
    else if (numBytes > 0)
    {
        *isValid = 1;
        return bufPtr[0];
    }
    
    // printf("Nothing read.\n");
    usleep(50);
    return 0;
}

              

// Given the file descriptor for a serial device, close that device.
int CloseSerialPort(int fileDescriptor)
{

    
    // Block until all written output has been sent from the device.
    // Note that this call is simply passed on to the serial device driver. 
	// See tcsendbreak(3) ("man 3 tcsendbreak") for details.
    if (tcflow(fileDescriptor, TCIOFF) == -1)
    {
        printf("Error waiting for drain - %s(%d).\n",
			   strerror(errno), errno);
    }
    
    // Traditionally it is good practice to reset a serial port back to
    // the state in which you found it. This is why the original termios struct
    // was saved.
    if (tcsetattr(fileDescriptor, TCSANOW, &gOriginalTTYAttrs) == -1)
    {
        printf("Error resetting tty attributes - %s(%d).\n",
			   strerror(errno), errno);
    }
	
    close(fileDescriptor);
    
    return 0;
}


int FindAndOpenModem(const char *modemPath, int lengthModemPath, int baud, int parenb, int parodd, int bits, int *portDescriptor) {
 
    int			fileDescriptor;
    kern_return_t	kernResult; // on PowerPC this is an int (4 bytes)
	/*
	 *	error number layout as follows (see mach/error.h):
	 *
	 *	hi		 		       lo
	 *	| system(6) | subsystem(12) | code(14) |
	 */
	
    io_iterator_t	serialPortIterator;
    char		bsdPath[MAXPATHLEN];
	
    kernResult = FindModems(&serialPortIterator);
    if(kernResult != KERN_SUCCESS){
        return kernResult;
    }
    kernResult = GetModemPath(serialPortIterator, bsdPath, sizeof(bsdPath), modemPath, lengthModemPath);
    if(kernResult != KERN_SUCCESS){
        return kernResult;
    }
    
    IOObjectRelease(serialPortIterator);	// Release the iterator.
    
    // Now open the modem port we found, initialize the modem, then close it
    if (!bsdPath[0])
    {
        printf("No modem port found.\n");
        return EX_UNAVAILABLE;
    }
	
    int err = OpenSerialPort(bsdPath, baud, parenb, parodd, bits, &fileDescriptor);
    if (err != 0) {
        return err;
    }
    if (-1 == fileDescriptor)
    {
        return EX_IOERR;
    }
	else {
		printf("Modem bsdPath opend.\n");
	}
	
    *portDescriptor = fileDescriptor;

    return EX_OK;    
}

int InitAndStartModem(int portDescriptor) {
	
    if (initializeModemAndStartComm(portDescriptor))
    {
        printf("Modem initialized successfully.\n");
    }
    else {
        printf("Could not initialize modem.\n");
    }
	
    return EX_OK;
}

TIME_DIFF * my_difftime (struct timeval * start, struct timeval * end)
{
	TIME_DIFF * diff = (TIME_DIFF *) malloc ( sizeof (TIME_DIFF) );
	
	if (start->tv_sec == end->tv_sec) {
		diff->secs = 0;
		diff->usecs = end->tv_usec - start->tv_usec;
	}
	else {
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



