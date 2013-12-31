const static int LOG_LEVEL_DEBUG = 2;
const static int  LOG_LEVEL_WARNING = 1;
const static int  LOG_LEVEL_ERROR =0;
#ifdef __DEBUG__
#import "MiniLoggerClient.h"

#define LOG_DEBUG(...)    LogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"General",LOG_LEVEL_DEBUG,__VA_ARGS__)
#define LOG_WARNING(...)    LogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"Warning",LOG_LEVEL_WARNING,__VA_ARGS__)
#define LOG_ERROR(...)    LogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"ERROR",LOG_LEVEL_ERROR,__VA_ARGS__)

#else

#define LOG_DEBUG(...)
#define LOG_WARNING(...)
#define LOG_ERROR(...)
#define LOG_IMAGE(imagedata,width,height)

#endif