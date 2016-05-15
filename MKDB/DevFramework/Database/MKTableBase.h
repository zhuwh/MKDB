//
//  MKTableBase.h
//  TgxIM
//
//  Created by zhuwh on 16/5/13.
//  Copyright © 2016年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@protocol MKTableBaseProtocol <NSObject>

@required
- (NSString *)tableName;
- (NSDictionary *)columnInfo;
- (NSString*) contentUri;

@optional
- (Class) recordClass;
- (BOOL) insertWithDatabase : (FMDatabase*) db values:(NSDictionary*)values;
- (int) deleteWithDatabase : (FMDatabase*) db whereClause:(NSString*)whereClause whereArgs:(NSArray *) whereArgs;
- (int) updateWithDatabase : (FMDatabase*) db values:(NSDictionary*)values whereClause:(NSString*)whereClause whereArgs:(NSArray*)whereArgs;
- (NSArray*) queryWithDatabase:(FMDatabase*) db columns:(NSArray*)columns  whereClause:(NSString*)whereClause whereArgs:(NSArray *) whereArgs sortOrder:(NSString*)sortOrder;
@end

@interface MKTableBase : NSObject
@property(copy,nonatomic,readonly) NSString* tableUri;
@property (weak,nonatomic,readonly) id<MKTableBaseProtocol> child;

- (BOOL) onCreateWithDatabase : (FMDatabase*) db;
- (BOOL) onAlterWithDatabase : (FMDatabase*) db oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV;

@end
