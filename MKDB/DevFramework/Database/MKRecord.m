//
//  MKRecord.m
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "MKRecord.h"


@interface MKRecord()
//@property(weak,nonatomic,readwrite) id<MKRecordProtocol> child;

@end

@implementation MKRecord
- (instancetype)init{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(MKRecordProtocol)]) {
//        self.child = (id<MKTableBaseProtocol>)self;
    }else{
        NSException *exception = [NSException exceptionWithName:@"MKRecord init error" reason:@"the child class must conforms to protocol: <MKRecordProtocol>" userInfo:nil];
        @throw exception;
    }
    return self;
}
@end
