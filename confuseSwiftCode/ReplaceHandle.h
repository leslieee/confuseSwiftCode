//
//  ReplaceHandle.h
//  confuseSwiftCode
//
//  Created by IMAC on 2018/12/6.
//  Copyright © 2018年 leslie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplaceHandle : NSObject
@property (strong, nonatomic)NSArray *funcNameArray;
@property (strong, nonatomic)NSDictionary *funcNameDict;

- (void)replaceWithPath:(NSString *)path;

@end
