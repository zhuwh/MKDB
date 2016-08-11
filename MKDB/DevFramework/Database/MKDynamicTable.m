//
//  MKDynamicTable.m
//  MKDB
//
//  Created by zhuwh on 16/8/10.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "MKDynamicTable.h"
#import "MKDynamicManagerTable.h"

@implementation MKDynamicTable

- (NSString *)tableName{
    return [NSString stringWithFormat:@"%@_%@",self.dynamicTableName,self.key];
}

- (BOOL) onCreateWithDatabase : (FMDatabase*) db{
    if (self.key) {
        return [super onCreateWithDatabase:db];
    }
    return YES;
}

- (BOOL) onAlterWithDatabase : (FMDatabase*) db oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV{
    
    MKDynamicManagerTable *managerTable = [MKDynamicManagerTable new];
    NSArray* array = [managerTable queryWithDatabase:db columns:nil whereClause:@"dynamic=?" whereArgs:@[[self dynamicTableName]] sortOrder:nil];
    for (NSDictionary *data in array) {
        NSString* key = data[@"key"];
        self.key = key;
        [self onAlterDynamicWithDatabase:db oldVersion:oldV newVersion:newV];
    }
    self.key = nil;
    return YES;
}

- (BOOL)onAlterDynamicWithDatabase:(FMDatabase*) db oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV{
    return [super onAlterWithDatabase:db oldVersion:oldV newVersion:newV];
}
@end
