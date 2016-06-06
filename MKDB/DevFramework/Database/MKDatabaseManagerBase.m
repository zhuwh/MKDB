//
//  MKDatabaseManager.m
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "MKDatabaseManagerBase.h"
#import <stdarg.h>

@interface MKDatabaseManagerBase()

@property (weak,nonatomic) id<MKDatabaseProtocol> child;
@property (strong,nonatomic,readwrite)FMDatabaseQueue* queue;
//@property (strong,nonatomic,readwrite) NSMutableArray<MKTableBase*> *tableArray;
@property (strong,nonatomic,readwrite) NSMutableDictionary<NSString*,MKTableBase*> *tableDictionary;

@end


@implementation MKDatabaseManagerBase

- (instancetype)init{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(MKDatabaseProtocol)]) {
        self.child = (id<MKDatabaseProtocol>)self;
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* dbpath = [docsdir stringByAppendingPathComponent:[_child databaseName]];
        NSLog(@"DB_PATH:%@",dbpath);
        self.queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            uint32_t curVersion = [db userVersion];
            NSLog(@"TGX_DB_VERSION:%@",[NSString stringWithFormat:@"%d",curVersion]);
            //            self.tableArray = [NSMutableArray new];
            self.tableDictionary = [NSMutableDictionary dictionary];
            
            NSMutableArray<Class> *array = [NSMutableArray array];
            [self.child onAddTableToArray:array];
            for (Class clzz in array) {
                MKTableBase* table = [clzz new];
                
                [self.tableDictionary setObject:table forKey:[table tableUri]];
            }
            
            int version = [self.child databaseVersion];
            if(curVersion!=version){
                if(curVersion==0){
                    //新创建
                    [self onCreateWithDatabase:db];
                    [db setUserVersion:version];
                }else{
                    if (curVersion<version) {
                        [self onUpgradeWithDatabase:db oldVersion:curVersion newVersion:version];
                        [db setUserVersion:version];
                    }else{
                        [self onDownWithDatabase:db oldVersion:curVersion newVersion:version];
                        [db setUserVersion:version];
                    }
                }
                
            }
        }];
    }else{
        NSException *exception = [NSException exceptionWithName:@"MKDatabaseManagerBase init error" reason:@"the child class must conforms to protocol: <MKDatabaseProtocol>" userInfo:nil];
        @throw exception;
    }
    return self;
}

- (void) onCreateWithDatabase:(FMDatabase *)db{
    NSArray<MKTableBase*> *tableArray = [self.tableDictionary allValues];
    for (MKTableBase* table in tableArray) {
        [table onCreateWithDatabase:db];
        id<MKTableBaseProtocol> protocol = (id<MKTableBaseProtocol>)table;
        [protocol settingsWithDatabase:db createOrAlert:YES oldVersion:0 newVersion:0];
    }
}

- (void) onUpgradeWithDatabase:(FMDatabase *)db oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV{
    NSArray<MKTableBase*> *tableArray = [self.tableDictionary allValues];
    for (MKTableBase* table in tableArray) {
        [table onAlterWithDatabase:db oldVersion:oldV newVersion:newV];
        id<MKTableBaseProtocol> protocol = (id<MKTableBaseProtocol>)table;
        [protocol settingsWithDatabase:db createOrAlert:NO oldVersion:oldV newVersion:newV];
    }
}

- (void) onDownWithDatabase:(FMDatabase *)db oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV{
    NSArray<MKTableBase*> *tableArray = [self.tableDictionary allValues];
    for (MKTableBase* table in tableArray) {
        [table onAlterWithDatabase:db oldVersion:oldV newVersion:newV];
        id<MKTableBaseProtocol> protocol = (id<MKTableBaseProtocol>)table;
        [protocol settingsWithDatabase:db createOrAlert:NO oldVersion:oldV newVersion:newV];
    }
}


-(void) insertWithUri:(NSString*)uri values:(NSDictionary*)values {
    [[self queue] inDatabase:^(FMDatabase *db) {
        MKTableBase* table = [self.tableDictionary objectForKey:uri];
        [table.child insertWithDatabase:db values:values];
    }];
}

- (void) insertWithUri:(NSString*)uri recordObject:(MKRecord*)object{
    [[self queue] inDatabase:^(FMDatabase *db) {
        MKTableBase* table = [self.tableDictionary objectForKey:uri];
        [table.child insertWithDatabase:db recordObject:object];
    }];
}

- (int) deleteWithUri:(NSString*)uri whereClause:(NSString*)whereClause whereArgs:(NSArray *) whereArgs{
    __block int num = 0;
    [[self queue] inDatabase:^(FMDatabase *db) {
        MKTableBase* table = [self.tableDictionary objectForKey:uri];
        num = [table.child deleteWithDatabase:db whereClause:whereClause whereArgs:whereArgs];
    }];
    return num;
}

- (int) deleteWithUri:(NSString*)uri recordObject:(MKRecord*)object{
    __block int num = 0;
    [[self queue] inDatabase:^(FMDatabase *db) {
        MKTableBase* table = [self.tableDictionary objectForKey:uri];
        num = [table.child deleteWithDatabase:db recordObject:object];
    }];
    return num;
}

- (int) updateWithUri : (NSString*) uri values:(NSDictionary*)values whereClause:(NSString*)whereClause whereArgs:(NSArray*)whereArgs{
    __block int num = 0;
    [[self queue] inDatabase:^(FMDatabase *db) {
        MKTableBase* table = [self.tableDictionary objectForKey:uri];
        num = [table.child updateWithDatabase:db values:values whereClause:whereClause whereArgs:whereArgs];
    }];
    return num;
}

- (int) updateWithUri : (NSString*) uri recordObject:(MKRecord*)object{
    __block int num = 0;
    [[self queue] inDatabase:^(FMDatabase *db) {
        MKTableBase* table = [self.tableDictionary objectForKey:uri];
        num = [table.child updateWithDatabase:db recordObject:object];
    }];
    return num;
}

- (NSArray*) queryWithUri:(NSString*)uri columns:(NSArray*)columns  whereClause:(NSString*)whereClause whereArgs:(NSArray *) whereArgs sortOrder:(NSString*)sortOrder{
    __block NSArray* array = [NSArray array];
    [[self queue] inDatabase:^(FMDatabase *db) {
        MKTableBase* table = [self.tableDictionary objectForKey:uri];
        array = [table.child queryWithDatabase:db columns:columns whereClause:whereClause whereArgs:whereArgs sortOrder:sortOrder];
    }];
    return array;
}


- (void)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments {
    [[self queue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql withArgumentsInArray:arguments];
    }];
}

- (NSArray*) executeQuery:(NSString*)sql withArgumentsInArray:(NSArray *)arguments {
    __block NSMutableArray* array = nil;
    [[self queue] inDatabase:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:sql withArgumentsInArray:arguments];
        while ([rs next]) {
            [array addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return array;
}
@end
