//
//  DatabaseManager.m
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "TestDatabaseManager.h"
#import "TestTable.h"
#import "TTestTable.h"

@implementation TestDatabaseManager

- (NSString*) databaseName{
    return @"MKDB.db";
}

- (uint32_t) databaseVersion{
    return 8;
}

- (void) onAddTableToArray:(NSMutableArray<Class>*) array{
    [array addObject:TestTable.class];
    [array addObject:TTestTable.class];
}

@end
