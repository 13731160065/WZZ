#pragma mark - @interface

/**
 功能:
 快速创建单例
 使用方法:
 1.将 SIN_INTERFACE(类名) 添加到.h中
 2.将 SIN_IMPLEMENTATION(类名) 添加到.m中
 */
#define singleton_interface(class) SIN_INTERFACE(class)
#define singleton_implementation(class) SIN_IMPLEMENTATION(class)

/**
 重写init方法，让init方法读取nib文件
 使用方法:
 将 INITXIB(NSString_NibName) 添加到.m中
 */
#define INITXIB(NSString_NibName) INITXIB_M(NSString_NibName)

#pragma mark end

#pragma mark - @implementation

// .h
#define SIN_INTERFACE(class) + (instancetype)shared##class;

// .m
#define SIN_IMPLEMENTATION(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)shared##class \
{ \
if (_instance == nil) { \
_instance = [[class alloc] init]; \
} \
\
return _instance; \
}

//.m
#define INITXIB_M(NSString_NibName) \
- (instancetype)init {\
return [[NSBundle mainBundle] loadNibNamed:NSString_NibName owner:nil options:nil][0];\
}

#pragma mark end