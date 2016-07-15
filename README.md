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
