//
//  MKTableBase.m
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "MKTableBase.h"
#import "MKRecord.h"
#import <objc/runtime.h>

#define getColumnMethod(obj,type,key) [obj type##ForColumn:key]

@interface MKTableBase()

@property (weak,nonatomic) id<MKTableBaseProtocol> child;
@property(copy,nonatomic,readwrite) NSString* tableUri;
@end

@implementation MKTableBase

- (instancetype)init{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(MKTableBaseProtocol)]) {
        self.child = (id<MKTableBaseProtocol>)self;
    }else{
        NSException *exception = [NSException exceptionWithName:@"MKTableBase init error" reason:@"the child class must conforms to protocol: <MKTableBaseProtocol>" userInfo:nil];
        @throw exception;
    }
    return self;
}

- (BOOL) onCreateWithDatabase : (FMDatabase*) db{
    NSString* tableName = [self.child tableName];
    NSDictionary* columnInfo = [self.child columnInfo];
    
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    [columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        NSString *safeColumnName = columnName;
        NSString *safeDescription = columnDescription;
        [columnList addObject:[NSString stringWithFormat:@"%@ %@", safeColumnName, safeDescription]];
        
    }];
    NSString *columns = [columnList componentsJoinedByString:@","];
    NSString *sql =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);",tableName,columns];
    return [db executeUpdate:sql];
}

- (BOOL) onAlterWithDatabase : (FMDatabase*) db oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV{
    NSString* tableName = [self.child tableName];
    NSString *sql =  [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    [db executeUpdate:sql];
    [self onCreateWithDatabase:db];
    return YES;
}

-(NSString*) tableUri{
    return [self.child contentUri];
}

- (BOOL) insertWithDatabase : (FMDatabase*) db values:(NSDictionary*)values{
    NSString* tableName = [self.child tableName];
    NSString *columns = [[values allKeys] componentsJoinedByString:@","];
    NSUInteger count = [[values allKeys] count];
    NSMutableArray* marksArray = [NSMutableArray arrayWithCapacity:count];
    for (int i =0; i<count; i++) {
        [marksArray addObject:@"?"];
    }
    NSString *marks = [marksArray componentsJoinedByString:@","];
    NSString *sql =  [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@) ;",tableName,columns,marks];
    BOOL result = [db executeUpdate:sql withArgumentsInArray:[values allValues]];
    if(!result){
        NSLog(@"error = %@", [db lastErrorMessage]);
    }
    return result;
}

- (int) deleteWithDatabase : (FMDatabase*) db whereClause:(NSString*)whereClause whereArgs:(NSArray *) whereArgs{
    NSString* tableName = [self.child tableName];
    NSString* deleteWhere = @"";
    if (whereClause) {
        deleteWhere = [NSString stringWithFormat:@" WHERE %@",whereClause];
    }
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@%@ ;",tableName,deleteWhere];
    BOOL result = [db executeUpdate:sql withArgumentsInArray:whereArgs];
    if(!result){
        NSLog(@"error = %@", [db lastErrorMessage]);
        return 0;
    }
    return  [db changes];
}

- (int) updateWithDatabase : (FMDatabase*) db values:(NSDictionary*)values whereClause:(NSString*)whereClause whereArgs:(NSArray*)whereArgs{
    NSString* tableName = [self.child tableName];
    NSMutableArray* setValuesArray = [NSMutableArray array];
    NSArray *columns = [values allKeys];
    for (NSString* column in columns) {
        NSString* value = [values objectForKey:column];
        NSString* obj = nil;
        if ([value isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@ = '%@'",column,value];
        }else{
            obj = [NSString stringWithFormat:@"%@ = %@",column,value];
        }
        [setValuesArray addObject:obj];
    }
    NSString *setValues = [setValuesArray componentsJoinedByString:@","];
    NSString* updateWhere = @"";
    if (whereClause) {
        updateWhere = [NSString stringWithFormat:@" WHERE %@",whereClause];
    }
    NSString *sql =  [NSString stringWithFormat:@"UPDATE %@ SET %@%@ ;",tableName,setValues,updateWhere];
    BOOL result = [db executeUpdate:sql withArgumentsInArray:whereArgs];
    if(!result){
        NSLog(@"error = %@", [db lastErrorMessage]);
        return 0;
    }
    return [db changes];
}

- (NSArray*) queryWithDatabase:(FMDatabase*) db columns:(NSArray*)columns  whereClause:(NSString*)whereClause whereArgs:(NSArray *) whereArgs sortOrder:(NSString*)sortOrder{
    NSString* tableName = [self.child tableName];
    NSString*  selectColumns = @"*";
    if (columns||columns.count!=0) {
        selectColumns = [columns componentsJoinedByString:@","];
    }
    NSString* selectWhere = @"";
    if (whereClause) {
        selectWhere = [NSString stringWithFormat:@" WHERE %@",whereClause];
    }
    NSString* selectOrder = @"";
    if (sortOrder) {
        selectOrder = [NSString stringWithFormat:@" ORDER BY %@",sortOrder];
    }
    NSString* sql = [NSString stringWithFormat:@"SELECT %@ FROM %@%@%@ ;",selectColumns,tableName,selectWhere,selectOrder];
    FMResultSet* rs = [db executeQuery:sql withArgumentsInArray:whereArgs];
    NSMutableArray* array = [NSMutableArray array];
    while ([rs next]) {
        NSDictionary* dic = [rs resultDictionary];
        if([self.child recordClass]){
            id<MKRecordProtocol> record = [[self.child recordClass] new];
            [self dictionary:dic toEntity:record];
            [array addObject:record];
        }else{
            [array addObject:dic];
        }
    }
    return array;
}

- (void) dictionary:(NSDictionary *)dict toEntity:(NSObject*)entity{
    if (dict && entity) {
        for (NSString *keyName in [dict allKeys]) {
            //构建出属性的set方法
             NSString *methodName = [NSString stringWithFormat:@"set%@%@:", [[keyName substringToIndex:1] uppercaseString], [keyName substringFromIndex:1]];
            SEL methodSelector = NSSelectorFromString(methodName);
            if ([entity respondsToSelector:methodSelector]) {
                 NSString* value = [dict objectForKey:keyName];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [entity performSelector:methodSelector withObject:value];
#pragma clang diagnostic pop
            }
        }
        
    }
}
@end
