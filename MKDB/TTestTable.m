//
//  TTestTable.m
//  MKDB
//
//  Created by zhuwh on 16/8/11.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "TTestTable.h"
#import "AppDefine.h"

@implementation TTestTable

- (NSString *)dynamicTableName{
    return @"testdynamic";
}

- (NSDictionary *)columnInfo{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name":@"TEXT",
             @"age":@"INTEGER",
             @"tomas":@"TEXT NOT NULL"
             };
}

//- (Class) recordClass{
//    return nil;
//}

- (NSString*) contentUri{
    return CONTENT_URI_TEST_DYNAMIC;
}
@end
