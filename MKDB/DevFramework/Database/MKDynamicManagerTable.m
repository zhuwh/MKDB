//
//  MKDynamicManagerTable.m
//  MKDB
//
//  Created by zhuwh on 16/8/10.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "MKDynamicManagerTable.h"

@implementation MKDynamicManagerTable

- (NSString *)tableName{
    return @"MKDynamicManagerTable";
}

- (NSDictionary *)columnInfo{
    return @{
             @"tid":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"dynamic":@"TEXT",
             @"key":@"TEXT"
             };
}

- (NSString*) contentUri{
    return MK_IDENTITY_DYNAMIC_MANAGER_SYS;
}

- (Class) recordClass{
    return nil;
}

- (void) settingsWithDatabase:(FMDatabase*) db createOrAlert:(BOOL)createOrAlert oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV{
    
}
@end
