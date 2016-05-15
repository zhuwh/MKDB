//
//  TestRecord.h
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "MKRecord.h"

@interface TestRecord : MKRecord<MKRecordProtocol>{
}

@property (nonatomic, strong) NSNumber *primaryKey;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tomas;

@end
