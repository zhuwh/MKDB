//
//  AppContext.h
//  TgxIM
//
//  Created by zhuwh on 16/5/12.
//  Copyright © 2016年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKSingleton.h"
#import "MKDatabaseManagerBase.h"
#import "AppDefine.h"

@interface AppContext : NSObject

SingletonH(Instance)

@property (copy,nonatomic,readonly) NSString *ip;
@property (copy,nonatomic,readonly) NSString *currentFomatTime;
@property (strong,nonatomic,readonly) MKDatabaseManagerBase* databaseManager;

@end
