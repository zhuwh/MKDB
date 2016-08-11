//
//  ViewController.m
//  MKDB
//
//  Created by zhuwh on 16/5/15.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "ViewController.h"
#import "AppDefine.h"
#import "AppContext.h"
#import "TestRecord.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *resource = [[NSBundle mainBundle] pathForResource:@"" ofType:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)createDynamicAction:(id)sender {
    [[[AppContext sharedInstance] databaseManager] createDynamicWithUrl:CONTENT_URI_TEST_DYNAMIC key:CONTENT_KEY_TEST_DYNAMIC];
}
- (IBAction)dropDynamicAction:(id)sender {
    [[[AppContext sharedInstance] databaseManager] dropDynamicWithUrl:CONTENT_URI_TEST_DYNAMIC key:CONTENT_KEY_TEST_DYNAMIC];
}
- (IBAction)insertDynamicAction:(id)sender {
        [[[AppContext sharedInstance] databaseManager] insertWithUri:CONTENT_URI_TEST_DYNAMIC values:@{@"name":[NSNull null],@"age":[NSNumber numberWithLongLong:LONG_LONG_MAX],@"tomas":@"this is tomas"} dynamicKey:CONTENT_KEY_TEST_DYNAMIC];
}
- (IBAction)deleteDynamicAction:(id)sender {
        [[[AppContext sharedInstance] databaseManager] deleteWithUri:CONTENT_URI_TEST_DYNAMIC whereClause:nil whereArgs:nil dynamicKey:CONTENT_KEY_TEST_DYNAMIC];
}
- (IBAction)updateDynamicAction:(id)sender {
        NSDictionary* dic = @{@"name":@"zhuwenhui",@"age":[NSNumber numberWithInt:20]};
        [[[AppContext sharedInstance] databaseManager] updateWithUri:CONTENT_URI_TEST_DYNAMIC values:dic whereClause:@"age=?" whereArgs:@[[NSNumber numberWithLongLong:LONG_LONG_MAX]] dynamicKey:CONTENT_KEY_TEST_DYNAMIC];
}
- (IBAction)querydynamicAction:(id)sender {
    NSArray* array = [[[AppContext sharedInstance] databaseManager] queryWithUri:CONTENT_URI_TEST_DYNAMIC columns:nil whereClause:nil whereArgs:nil sortOrder:nil dynamicKey:CONTENT_KEY_TEST_DYNAMIC];
    for (NSDictionary* record in array) {
        NSString* name = record[@"name"];
        NSLog(@"%@",record);
        NSLog(@"name=%@",name);
    }
}

- (IBAction)insertAction:(id)sender {
//    [[[AppContext sharedInstance] databaseManager] insertWithUri:CONTENT_URI_TEST values:@{@"name":[NSNull null],@"age":[NSNumber numberWithLongLong:LONG_LONG_MAX],@"tomas":@"this is tomas"}];
    TestRecord *record = [TestRecord new];
    record.age = [NSNumber numberWithInt:18];
    record.tomas = @"hahah";
    [[[AppContext sharedInstance] databaseManager] insertWithUri:CONTENT_URI_TEST recordObject:record dynamicKey:nil];

}

- (IBAction)deleteAction:(id)sender {
//    [[[AppContext sharedInstance] databaseManager] deleteWithUri:CONTENT_URI_TEST whereClause:nil whereArgs:nil];
    TestRecord *record = [TestRecord new];
    record.primaryKey = [NSNumber numberWithInt:1];
    [[[AppContext sharedInstance] databaseManager] deleteWithUri:CONTENT_URI_TEST recordObject:record dynamicKey:nil];
}

- (IBAction)updateAction:(id)sender {
//    NSDictionary* dic = @{@"name":@"zhuwenhui",@"age":[NSNumber numberWithInt:20]};
//    [[[AppContext sharedInstance] databaseManager] updateWithUri:CONTENT_URI_TEST values:dic whereClause:@"age=?" whereArgs:@[[NSNumber numberWithLongLong:LONG_LONG_MAX]]];
    
    TestRecord *record = [TestRecord new];
    record.primaryKey = [NSNumber numberWithInt:2];
    record.age = [NSNumber numberWithInt:32];
    record.tomas = @"wowowow";
    [[[AppContext sharedInstance] databaseManager] updateWithUri:CONTENT_URI_TEST recordObject:record dynamicKey:nil];
}

- (IBAction)queryAction:(id)sender {
    
    NSArray* array = [[[AppContext sharedInstance] databaseManager] queryWithUri:CONTENT_URI_TEST columns:nil whereClause:nil whereArgs:nil sortOrder:nil dynamicKey:nil];
    for (TestRecord* record in array) {
        NSString* name = record.name;
        NSLog(@"%@",record);
        NSLog(@"name=%@",name);
    }
    
}
@end
