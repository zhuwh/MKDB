//
//  MKDynamicTable.h
//  MKDB
//
//  Created by zhuwh on 16/8/10.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "MKTableBase.h"

@interface MKDynamicTable : MKTableBase<MKTableBaseProtocol>

@property(nonatomic,copy) NSString* key;

- (NSString *)dynamicTableName;
- (BOOL)onAlterDynamicWithDatabase:(FMDatabase*) db oldVersion:(uint32_t) oldV newVersion:(uint32_t) newV;

@end
