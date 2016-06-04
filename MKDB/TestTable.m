//
//  TestTable.m
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "TestTable.h"
#import "TestRecord.h"
#import "AppDefine.h"

@implementation TestTable

- (NSString *)tableName{
    return @"test";
}

- (NSDictionary *)columnInfo{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name":@"TEXT",
             @"age":@"INTEGER",
             @"tomas":@"TEXT NOT NULL"
             };
}

- (NSString*) contentUri{
    return CONTENT_URI_TEST;
}

- (Class) recordClass{
    return [TestRecord class];
}

- (void) settingsWithDatabase:(FMDatabase*) db createOrAlert:(BOOL)createOrAlert oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV{
    
}

@end
