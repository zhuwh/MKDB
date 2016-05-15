//
//  TgxSingleton.h
//  PushSdk4Oc
//
//  Created by zhuwh on 16/4/5.
//  Copyright © 2016年 mark. All rights reserved.
//

// .h文件
#define SingletonH(name) + (instancetype)shared##name;

// .m文件
#define SingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    _instance = [[self alloc] init]; \
    }); \
    return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instance; \
}