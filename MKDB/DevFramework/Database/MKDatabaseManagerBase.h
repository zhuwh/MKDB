//
//  MKDatabaseManager.h
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "MKTableBase.h"
#import "MKRecord.h"

@protocol MKDatabaseProtocol <NSObject>

@required
- (NSString*) databaseName;
- (uint32_t) databaseVersion;
- (void) onAddTableToArray:(NSMutableArray<Class>*) array;

@end

@interface MKDatabaseManagerBase : NSObject

@property (strong,nonatomic,readonly)FMDatabaseQueue* queue;

- (void) insertWithUri:(NSString*)uri values:(NSDictionary*)values;
- (void) insertWithUri:(NSString*)uri recordObject:(MKRecord*)object;
- (int) deleteWithUri:(NSString*)uri whereClause:(NSString*)whereClause whereArgs:(NSArray *) whereArgs;
- (int) deleteWithUri:(NSString*)uri recordObject:(MKRecord*)object;
- (int) updateWithUri : (NSString*) uri values:(NSDictionary*)values whereClause:(NSString*)whereClause whereArgs:(NSArray*)whereArgs;
- (int) updateWithUri : (NSString*) uri recordObject:(MKRecord*)object;
- (NSArray*) queryWithUri:(NSString*)uri columns:(NSArray*)columns  whereClause:(NSString*)whereClause whereArgs:(NSArray *) whereArgs sortOrder:(NSString*)sortOrder;
- (void)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
- (NSArray*) executeQuery:(NSString*)sql withArgumentsInArray:(NSArray *)arguments ;

-(void) create;
-(void) drop;

@end
