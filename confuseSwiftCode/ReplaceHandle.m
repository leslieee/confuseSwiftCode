//
//  ReplaceHandle.m
//  confuseSwiftCode
//
//  Created by IMAC on 2018/12/6.
//  Copyright © 2018年 leslie. All rights reserved.
//

#import "ReplaceHandle.h"

@implementation ReplaceHandle

-(void)replaceWithPath:(NSString *)path {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filelist = [fileManager contentsOfDirectoryAtPath:path error:&error];
    for (NSString *lastPathComponent in filelist) {
        if ([lastPathComponent hasPrefix:@"."]) continue; // Ignore file.
        NSString *fullPath = [path stringByAppendingPathComponent:lastPathComponent];
        BOOL isDir;
        BOOL exists = [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
        if (exists) {
            if (isDir) {
                // 如果是目录 则递归操作
                [self replaceWithPath:fullPath];
            }else{
                // 如果是文件 直接进行替换保存
                if (![lastPathComponent hasSuffix:@".swift"] &&
                    ![lastPathComponent hasSuffix:@".h"] &&
                    ![lastPathComponent hasSuffix:@".m"] &&
                    ![lastPathComponent hasSuffix:@".storyboard"] &&
                    ![lastPathComponent hasSuffix:@".xib"]){
                    continue;
                }
                NSString *fileContent = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
                NSString *newFileContent = fileContent;
                for (NSString *str in self.funcNameArray) {
                    newFileContent = [newFileContent stringByReplacingOccurrencesOfString:str withString:self.funcNameDict[str]];
                }
                if (![newFileContent isEqualToString:fileContent]) {
                    if ([newFileContent writeToFile:fullPath atomically:NO encoding:NSUTF8StringEncoding error:nil]) {
                        NSLog(@"替换成功: %@",fullPath);
                    } else {
                        NSLog(@"替换失败: %@",fullPath);
                    }
                }
            }
        }
    }
}

@end
