MKDB [![Build Status](https://travis-ci.org/zhuwh/MKDB.svg?branch=master)](https://travis-ci.org/zhuwh/MKDB) [![CocoaPods](https://img.shields.io/cocoapods/l/MKDB.svg)](https://github.com/zhuwh/MKDB/blob/master/LICENSE) [![CocoaPods](https://img.shields.io/cocoapods/v/MKDB.svg)](https://cocoapods.org/?q=MKDB)
=====

基于FMDB 的持久层操作库

##数据库与表的定义
 * 创建 MKRecord 类

TestRecord.h
```
#import "MKDB.h"

@interface TestRecord : MKRecord<MKRecordProtocol>{
}

@property (nonatomic, copy) NSNumber *primaryKey;
@property (nonatomic, copy) NSNumber *age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tomas;

@end
```
TestRecord.m
```
#import "TestRecord.h"

@implementation TestRecord

- (NSString*) bindPrimaryKey{
    return @"primaryKey"; //指定主键字段
}

@end
```
 * 创建 MKTable 类

TestTable.h
```
#import "MKDB.h"

@interface TestTable : MKTableBase<MKTableBaseProtocol>
@end
```
TestTable.m
```
#import "TestTable.h"
#import "TestRecord.h"
#import "AppDefine.h"

@implementation TestTable

- (NSString *)tableName{
    return @"test";  //定义表名
}

//定义表字段
- (NSDictionary *)columnInfo{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name":@"TEXT",
             @"age":@"INTEGER",
             @"tomas":@"TEXT NOT NULL"
             };
}

//操作表要用到的标识
- (NSString*) contentUri{
    return CONTENT_URI_TEST;
}

//绑定的Record类，如没有指定(return nil) 数据返回是NSDictionary类型，返之就是指定的Record类型的对象
- (Class) recordClass{
    return [TestRecord class];
}

- (void) settingsWithDatabase:(FMDatabase*) db createOrAlert:(BOOL)createOrAlert oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV{
    
}

@end
```
 * 创建 MKDatabaseManagerBase 类
 TestDatabaseManager.h
```
#import "MKDB.h"

@interface TestDatabaseManager : MKDatabaseManagerBase<MKDatabaseProtocol>
@end
```
 TestDatabaseManager.m
```
#import "TestDatabaseManager.h"
#import "TestTable.h"

@implementation TestDatabaseManager

//定义数据库名
- (NSString*) databaseName{
    return @"MKDB.db";
}
//定义数据库版本号
- (uint32_t) databaseVersion{
    return 6;
}

//把表添加到数据库中
- (void) onAddTableToArray:(NSMutableArray<Class>*) array{
    [array addObject:TestTable.class];
}

@end

```
##表的增册改查操作
 * 插入
当 MKTable 类中recordClass返回为nil时
```
    [databaseManager insertWithUri:CONTENT_URI_TEST values:@{@"name":[NSNull null],@"age":[NSNumber numberWithLongLong:LONG_LONG_MAX],@"tomas":@"this is tomas"}];
```
当指定了具体的类型时
```
    TestRecord *record = [TestRecord new];
    record.age = [NSNumber numberWithInt:18];
    record.tomas = @"hahah";
    [databaseManager insertWithUri:CONTENT_URI_TEST recordObject:record];
```
 * 删除
当 MKTable 类中recordClass返回为nil时
```
[databaseManager deleteWithUri:CONTENT_URI_TEST whereClause:nil whereArgs:nil];
```
当指定了具体的类型时
```
    TestRecord *record = [TestRecord new];
    record.primaryKey = [NSNumber numberWithInt:1];
    [[[AppContext sharedInstance] databaseManager] deleteWithUri:CONTENT_URI_TEST recordObject:record];
```
 * 修改
当 MKTable 类中recordClass返回为nil时
```
    NSDictionary* dic = @{@"name":@"mark22",@"age":[NSNumber numberWithInt:20]};
    [databaseManager updateWithUri:CONTENT_URI_TEST values:dic whereClause:@"age=?" whereArgs:@[[NSNumber numberWithLongLong:LONG_LONG_MAX]]];
```
当指定了具体的类型时
```
    TestRecord *record = [TestRecord new];
    record.primaryKey = [NSNumber numberWithInt:2];
    record.age = [NSNumber numberWithInt:32];
    record.tomas = @"wowowow";
    [databaseManager updateWithUri:CONTENT_URI_TEST recordObject:record];
```
 * 查询
当 MKTable 类中recordClass返回为nil时
```
 NSArray* array = [databaseManager queryWithUri:CONTENT_URI_TEST columns:nil whereClause:nil whereArgs:nil sortOrder:nil];
    for (TestRecord* record in array) {
        NSString* name = record.name;
        NSLog(@"%@",record);
        NSLog(@"name=%@",name);
    }
```
当指定了具体的类型时
```
 NSArray* array = [databaseManager queryWithUri:CONTENT_URI_TEST columns:nil whereClause:nil whereArgs:nil sortOrder:nil];
    for (NSDictionary* record in array) {
        NSString* name = record[@"name"];
        NSLog(@"%@",record);
        NSLog(@"name=%@",name);
    }
```
