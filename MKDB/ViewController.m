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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)insertAction:(id)sender {
    [[[AppContext sharedInstance] databaseManager] insertWithUri:CONTENT_URI_TEST values:@{@"name":@"mark",@"age":[NSNumber numberWithLongLong:LONG_LONG_MAX],@"tomas":@"this is tomas"}];
}

- (IBAction)deleteAction:(id)sender {
    [[[AppContext sharedInstance] databaseManager] deleteWithUri:CONTENT_URI_TEST whereClause:nil whereArgs:nil];
}

- (IBAction)updateAction:(id)sender {
    NSDictionary* dic = @{@"name":@"zhuwenhui",@"age":[NSNumber numberWithInt:20]};
    [[[AppContext sharedInstance] databaseManager] updateWithUri:CONTENT_URI_TEST values:dic whereClause:nil whereArgs:nil];
}

- (IBAction)queryAction:(id)sender {
    
    NSArray* array = [[[AppContext sharedInstance] databaseManager] queryWithUri:CONTENT_URI_TEST columns:nil whereClause:nil whereArgs:nil sortOrder:nil];
    for (TestRecord* record in array) {
        NSString* name = record.name;
        NSLog(@"%@",record);
        NSLog(@"name=%@",name);
    }
    
}
@end
