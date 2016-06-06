//
//  TestRecord.h
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "MKDB.h"

@interface TestRecord : MKRecord<MKRecordProtocol>{
}

@property (nonatomic, copy) NSNumber *primaryKey;
@property (nonatomic, copy) NSNumber *age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tomas;

@end
