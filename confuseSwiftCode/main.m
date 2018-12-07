//
//  main.m
//  confuseSwiftCode
//
//  Created by leslie on 2018/12/6.
//  Copyright © 2018年 leslie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReplaceHandle.h"

#define NOTNULL(x) ((![x isKindOfClass:[NSNull class]])&&x)
#define SWNOTEmptyArr(X) (NOTNULL(X)&&[X isKindOfClass:[NSArray class]]&&[X count])
#define SWNOTEmptyDictionary(X) (NOTNULL(X)&&[X isKindOfClass:[NSDictionary class]]&&[[X allKeys]count])
#define SWNOTEmptyStr(X) (NOTNULL(X)&&[X isKindOfClass:[NSString class]]&&((NSString *)X).length)

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        printf("%s\n", [[NSString stringWithFormat:@"程序默认扫描当前目录下Thinksns Plus目录."] UTF8String]);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *homeDirPath;
        if (argc == 1) {
            homeDirPath = [NSString stringWithFormat:@"%@/Thinksns Plus",[fileManager currentDirectoryPath]];
            BOOL isDir;
            BOOL exists = [fileManager fileExistsAtPath:homeDirPath isDirectory:&isDir];
            if (!exists || !isDir) {
                printf("%s\n", [[NSString stringWithFormat:@"请在ts+根目录运行"] UTF8String]);
                exit(0);
            }
        }
        // 获取当前目录的待替换方法名列表
        NSString *funcNamePath = [NSString stringWithFormat:@"%@/funcname.txt",[fileManager currentDirectoryPath]];
        NSString *funcNameKeyValuePath = [NSString stringWithFormat:@"%@/funcnamekeyvalue",[fileManager currentDirectoryPath]];
        if (![fileManager fileExistsAtPath:funcNamePath]) {
            printf("%s\n", [[NSString stringWithFormat:@"funcname.txt文件不存在, 请先创建文件并导入方法名"] UTF8String]);
            exit(0);
        }
        NSString *funcNameContent = [NSString stringWithContentsOfFile:funcNamePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *funcNameArray = [funcNameContent componentsSeparatedByString:@"\n"];
        NSDictionary *funcNameDict;
        if ([fileManager fileExistsAtPath:funcNameKeyValuePath]) {
            funcNameDict = [[NSDictionary alloc] initWithContentsOfFile:funcNameKeyValuePath];
        }
        if (!SWNOTEmptyDictionary(funcNameDict)) {
            NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
            for (NSString *str in funcNameArray) {
                // 生成随机方法名 与待替换方法名组成key-value
                NSArray *firstArray = @[@"sen", @"check", @"upload", @"refresh", @"has",@"rest", @"change", @"add", @"remove", @"is"];
                NSArray *secondArray = @[@"Item", @"UserInfo", @"MediaInfo", @"Route", @"Common", @"Chat", @"Commis"];
                NSArray *thirdArray = @[@"By", @"Of", @"With", @"And", @"From", @"To", @"In"];
                NSArray *forthArray = @[@"Home", @"DrawMap", @"MediaID", @"Message", @"Loaction", @"Username", @"My"];
                NSArray *fifthArray = @[@"Info", @"Count", @"Name", @"SystemId", @"Title", @"Topic", @"Action"];
                NSString *firstStr = firstArray[arc4random() % firstArray.count];
                NSString *secondStr = secondArray[arc4random() % secondArray.count];
                NSString *thirdStr = thirdArray[arc4random() % thirdArray.count];
                NSString *forthStr = forthArray[arc4random() % forthArray.count];
                NSString *fifthStr = fifthArray[arc4random() % fifthArray.count];
                NSString *randomStr = [NSString stringWithFormat:@"%@%@%@%@%@",firstStr,secondStr,thirdStr,forthStr,fifthStr];
                [tmpDict setValue:randomStr forKey:str];
            }
            funcNameDict = [tmpDict copy];
        }
        printf("%s\n", [[NSString stringWithFormat:@"待替换和随机方法名对照表"] UTF8String]);
        printf("%s\n", [[NSString stringWithFormat:@"%@", funcNameDict] UTF8String]);
        // 保存对照表
        [funcNameDict writeToFile:funcNameKeyValuePath atomically:NO];
        // 遍历目录 挨行替换
        ReplaceHandle *handle = [ReplaceHandle new];
        handle.funcNameArray = funcNameArray;
        handle.funcNameDict = funcNameDict;
        [handle replaceWithPath:homeDirPath];
        printf("%s\n", [[NSString stringWithFormat:@"对照表已保存至funcnamekeyvalue文件, 为避免重复生成随机方法名, 请妥善保管文件"] UTF8String]);
    }
    return 0;
}







