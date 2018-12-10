//
//  ReplaceHandle.m
//  confuseSwiftCode
//
//  Created by IMAC on 2018/12/6.
//  Copyright © 2018年 leslie. All rights reserved.
//

#import "ReplaceHandle.h"

#define NOTNULL(x) ((![x isKindOfClass:[NSNull class]])&&x)
#define SWNOTEmptyArr(X) (NOTNULL(X)&&[X isKindOfClass:[NSArray class]]&&[X count])
#define SWNOTEmptyDictionary(X) (NOTNULL(X)&&[X isKindOfClass:[NSDictionary class]]&&[[X allKeys]count])
#define SWNOTEmptyStr(X) (NOTNULL(X)&&[X isKindOfClass:[NSString class]]&&((NSString *)X).length)

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
                // 辣鸡代码 暂时只混淆vc的
                if ([lastPathComponent hasSuffix:@"Controller.swift"] || [lastPathComponent hasSuffix:@"VC.swift"]) {
                    NSMutableArray *tmpArray = [[newFileContent componentsSeparatedByString:@"\n"] mutableCopy];
                    NSInteger tmpIndex = -1;
                    // 从末尾向上
                    for (NSInteger i=(tmpArray.count-1); i>=0; i--) {
                        NSString *tmpStr = tmpArray[i];
                        [tmpStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                        if (!SWNOTEmptyStr(tmpStr)) {
                            continue;
                        } else if ([tmpStr hasPrefix:@"//"]) {
                            continue;
                        } else if ([tmpStr hasPrefix:@"}"]) {
                            tmpIndex = i;
                            break;
                        }
                    }
                    if (tmpIndex != -1) {
                        [tmpArray insertObject:[self generateSpamCode] atIndex:tmpIndex];
                        newFileContent = [[tmpArray valueForKey:@"description"] componentsJoinedByString:@"\n"];
                    }
                }
                if (![newFileContent isEqualToString:fileContent]) {
                    if ([newFileContent writeToFile:fullPath atomically:NO encoding:NSUTF8StringEncoding error:nil]) {
                        printf("%s\n", [[NSString stringWithFormat:@"替换成功: %@",fullPath] UTF8String]);
                    } else {
                        printf("%s\n", [[NSString stringWithFormat:@"替换失败: %@",fullPath] UTF8String]);
                    }
                }
            }
        }
    }
}

-(NSString *)generateSpamCode {
    NSMutableArray *randomFuncnameArray = [NSMutableArray array];
    NSString *funcNameDictDesc = self.funcNameDict.description;
    for (int i = 0; i < 5; i++) {
        NSString *waitCheckStr;
        while (1) {
            waitCheckStr = [self generateRandomFuncname];
            if (![funcNameDictDesc containsString:waitCheckStr] && ![randomFuncnameArray containsObject:waitCheckStr]) {
                break;
            }
        }
        [randomFuncnameArray addObject:waitCheckStr];
    }
    NSString *spamCode1 = [NSString stringWithFormat:@"\nfunc %@() {\nlet button = UIButton();\nbutton.layer.cornerRadius = 5;\nbutton.layer.masksToBounds = true;\nbutton.backgroundColor = UIColor.white;\nbutton.setTitle(\"\", for: .normal);\nbutton.set(font: UIFont.systemFont(ofSize: 15))\n}\n",randomFuncnameArray[0]];
    NSString *spamCode2 = [NSString stringWithFormat:@"\nfunc %@() {\nlet rightIcon = UIImageView(frame: CGRect(x: ScreenWidth - 20 - 10, y: 0, width: 10, height: 20));\nrightIcon.clipsToBounds = true;\nrightIcon.contentMode = .scaleAspectFill;\nrightIcon.image = UIImage();\nrightIcon.centerY = 1\n}\n",randomFuncnameArray[1]];
    NSString *spamCode3 = [NSString stringWithFormat:@"\nfunc %@() {\nlet bgView = UIView();\nbgView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 16, height: 16));\nbgView.center = CGPoint(x: 3, y: 3);\nbgView.layer.cornerRadius = 8;\nbgView.tag = 999;\nbgView.isUserInteractionEnabled = true;\n}\n",randomFuncnameArray[2]];
    NSString *spamCode4 = [NSString stringWithFormat:@"\nfunc %@() {\nlet addImage = UIImageView();\naddImage.frame = CGRect(x: 0, y: 0, width: 42, height: 24);\naddImage.clipsToBounds = true;\naddImage.layer.cornerRadius = 3;\naddImage.contentMode = .scaleAspectFill;\naddImage.isUserInteractionEnabled = true;\n}\n",randomFuncnameArray[3]];
    NSString *spamCode5 = [NSString stringWithFormat:@"\nfunc %@() {\nlet tableView = UITableView();\ntableView.frame = CGRect(x: 0, y: 0, width: 42, height: 24);\ntableView.clipsToBounds = true;\ntableView.layer.cornerRadius = 3;\ntableView.contentMode = .scaleAspectFill;\ntableView.isUserInteractionEnabled = true;\n}\n",randomFuncnameArray[4]];
    NSArray *tmpArray = @[spamCode1,spamCode2,spamCode3,spamCode4,spamCode5];
    int count = (arc4random() % 3) + 1;
    NSString *tmpStr = @"";
    for (int i = 1; i <= count; i++) {
        NSString *waitCheckStr;
        while (1) {
            waitCheckStr = tmpArray[arc4random() % tmpArray.count];
            if (![tmpStr containsString:waitCheckStr]) {
                break;
            }
        }
        tmpStr = [tmpStr stringByAppendingString:waitCheckStr];
    }
    return tmpStr;
}

-(NSString *)generateRandomFuncname {
    NSArray *firstArray = @[@"sen", @"check", @"upload", @"refresh", @"has",@"rest", @"change", @"add", @"remove", @"is"];
    NSArray *secondArray = @[@"Item", @"UserInfo", @"MediaInfo", @"Route", @"Common", @"Chat", @"Commis"];
    NSArray *thirdArray = @[@"By", @"Of", @"With", @"And", @"From", @"To", @"In"];
    NSArray *forthArray = @[@"Home", @"DrawMap", @"MediaID", @"Message", @"Loaction", @"Username", @"My"];
    NSArray *fifthArray = @[@"Info", @"Count", @"Name", @"SystemId", @"Title", @"Topic", @"Action"];
    NSString *randomStr = [NSString stringWithFormat:@"%@%@%@%@%@",firstArray[arc4random() % firstArray.count],secondArray[arc4random() % secondArray.count],thirdArray[arc4random() % thirdArray.count],forthArray[arc4random() % forthArray.count],fifthArray[arc4random() % fifthArray.count]];
    return randomStr;
}

@end
