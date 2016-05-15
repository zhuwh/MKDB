//
//  AppContext.m
//  TgxIM
//
//  Created by zhuwh on 16/5/12.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "AppContext.h"
#import <UIKit/UIDevice.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import "TestDatabaseManager.h"

@interface AppContext()

@property (strong,nonatomic) UIDevice *device;
@property (copy,nonatomic) NSString *ip;
@property (copy,nonatomic) NSString *currentFomatTime;

@end



@implementation AppContext

SingletonM(Instance)

#pragma mark - overrided methods
- (instancetype)init
{
    self = [super init];
    if (self) {
//        _databaseManager = [[MKDatabaseManagerBase alloc]init];
        _databaseManager = [TestDatabaseManager new];
    }
    return self;
}


#pragma mark - getters and setters

- (UIDevice *)device
{
    if (_device == nil) {
        _device = [UIDevice currentDevice];
    }
    return _device;
}

- (NSString *)ip
{
    if (_ip == nil) {
        _ip = @"Error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        _ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return _ip;
}
- (NSString*)currentFomatTime{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormater stringFromDate:[NSDate date]];
}


@end
