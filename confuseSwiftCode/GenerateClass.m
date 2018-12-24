//
//  GenerateClass.m
//  confuseSwiftCode
//
//  Created by IMAC on 2018/12/21.
//  Copyright © 2018年 leslie. All rights reserved.
//

#import "GenerateClass.h"

@implementation GenerateClass

- (void)generateClass:(NSString *)path {
    NSString *projPath = [NSString stringWithFormat:@"%@/newproject",path];
    NSInteger classNum = 150;
    NSMutableArray *tmpClassNameArray = [NSMutableArray array];
    for (int i = 0; i < classNum; i++) {
        NSString *className;
        while (1) {
            className = [self generateRandomClassName];
            if (![tmpClassNameArray containsObject:className]) {
                break;
            }
        }
        [tmpClassNameArray addObject:className];
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObject:@"import UIKit"];
        [tmpArray addObject:[NSString stringWithFormat:@"class %@: UIViewController {",className]];
        [tmpArray addObject:@"override func viewDidLoad() {"];
        [tmpArray addObject:@"    super.viewDidLoad()"];
        NSMutableArray *tmpFuncNameArray = [NSMutableArray array];
        NSString *tmpStr = @"";
        int count = (arc4random() % 20) + 10;
        for (int i=0; i<count; i++) {
            NSString *waitCheckStr;
            while (1) {
                waitCheckStr = [self generateRandomFunctionName];
                if (![tmpFuncNameArray containsObject:waitCheckStr]) {
                    break;
                }
            }
            [tmpFuncNameArray addObject:waitCheckStr];
            tmpStr = [tmpStr stringByAppendingString:[NSString stringWithFormat:@"    %@();\n",waitCheckStr]];
        }
        [tmpArray addObject:tmpStr];
        [tmpArray addObject:@"}"];
        [tmpArray addObject:[self generateRandomFunctionBody:tmpFuncNameArray]];
        [tmpArray addObject:@"}"];
        NSString *content = [[tmpArray valueForKey:@"description"] componentsJoinedByString:@"\n"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir;
        BOOL exists = [fileManager fileExistsAtPath:projPath isDirectory:&isDir];
        if (!exists || !isDir) {
            [fileManager createDirectoryAtPath:projPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        [content writeToFile:[NSString stringWithFormat:@"%@/%@.swift",projPath,className] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    NSMutableArray *newProjArray = [NSMutableArray array];
    [newProjArray addObject:@"import UIKit"];
    [newProjArray addObject:[NSString stringWithFormat:@"class NewProjectViewController: UIViewController {"]];
    [newProjArray addObject:@"override func viewDidLoad() {"];
    [newProjArray addObject:@"    super.viewDidLoad()"];
    NSString *tmpStr = @"";
    for (int i=0; i<tmpClassNameArray.count; i++) {
        tmpStr = [tmpStr stringByAppendingString:[NSString stringWithFormat:@"    %@();\n",tmpClassNameArray[i]]];
    }
    [newProjArray addObject:tmpStr];
    [newProjArray addObject:@"}"];
    [newProjArray addObject:@"}"];
    NSString *content = [[newProjArray valueForKey:@"description"] componentsJoinedByString:@"\n"];
    [content writeToFile:[NSString stringWithFormat:@"%@/NewProjectViewController.swift",projPath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *)generateRandomFunctionBody:(NSMutableArray *)array {
    NSString *tmpStr = @"";
    for (int i = 0; i < array.count; i++) {
        NSString *buttonName = [NSString stringWithFormat:@"%@View",[self generateRandomClassName]];
        NSArray *firstArray = @[@".layer.cornerRadius = 5;",
                                @".layer.masksToBounds = true;",
                                @".backgroundColor = UIColor.white;",
                                @".backgroundColor = UIColor.black;",
                                @".tag = 999;",
                                @".tag = 666;",
                                @".isUserInteractionEnabled = true;",
                                @".alpha = 0.5;",
                                @".isOpaque = true;",
                                @".isHidden = false;",
                                @".contentMode = .scaleAspectFill;",
                                @".tintColor = UIColor.green;",
                                @".frame = CGRect(x: 0, y: 0, width: 42, height: 24);",
                                @".center = CGPoint(x: 3, y: 3);",
                                @".isMultipleTouchEnabled = true;",
                                @".sizeToFit();",
                                @".removeFromSuperview();",
                                @".setNeedsDisplay();",
                                ];
        NSArray *secondArray = @[@"UIView()",
                                 @"UIButton()",
                                 @"UITableView()",
                                 @"UISwitch()",
                                 @"UITextField()",
                                 @"UILabel()",
                                 @"UIScrollView()",
                                 @"UIImageView()",
                                 ];
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObject:[NSString stringWithFormat:@"\nfunc %@() {",array[i]]];
        [tmpArray addObject:[NSString stringWithFormat:@"    let %@ = %@;",buttonName,secondArray[arc4random() % secondArray.count]]];
        for (int i = 0; i < 10; i++) {
            [tmpArray addObject:[NSString stringWithFormat:@"    %@%@",buttonName,firstArray[arc4random() % firstArray.count]]];
        }
        [tmpArray addObject:[NSString stringWithFormat:@"    self.view.addSubview(%@);\n}\n",buttonName]];
        NSString *content = [[tmpArray valueForKey:@"description"] componentsJoinedByString:@"\n"];
        tmpStr = [tmpStr stringByAppendingString:content];
    }
    return tmpStr;
}

-(NSString *)generateRandomFunctionName {
    NSArray *firstArray = @[@"sen", @"check", @"upload", @"refresh", @"has",@"rest", @"change", @"add", @"remove", @"is"];
    NSArray *secondArray = @[@"Item", @"UserInfo", @"MediaInfo", @"Route", @"Common", @"Chat", @"Commis"];
    NSArray *thirdArray = @[@"By", @"Of", @"With", @"And", @"From", @"To", @"In"];
    NSArray *forthArray = @[@"Home", @"DrawMap", @"MediaID", @"Message", @"Loaction", @"Username", @"My"];
    NSArray *fifthArray = @[@"Info", @"Count", @"Name", @"SystemId", @"Title", @"Topic", @"Action"];
    NSString *randomStr = [NSString stringWithFormat:@"%@%@%@%@%@",firstArray[arc4random() % firstArray.count],secondArray[arc4random() % secondArray.count],thirdArray[arc4random() % thirdArray.count],forthArray[arc4random() % forthArray.count],fifthArray[arc4random() % fifthArray.count]];
    return randomStr;
}

-(NSString *)generateRandomClassName {
    NSArray *firstArray = @[@"Gift", @"Process", @"Catchs", @"Question", @"Report",@"Task", @"Sign", @"FindPerson", @"Exchange", @"Card", @"Segment", @"Notis", @"Pindao", @"Root", @"Chat", @"Remark", @"Caogao", @"Weiba", @"Circle", @"MyPublish", @"Activity"];
    NSArray *secondArray = @[@"", @"", @"Item", @"UserInfo", @"MediaInfo", @"Route", @"Commis", @"Loaction", @"DrawMap"];
    NSArray *thirdArray = @[@"List", @"Detail", @"Manager", @"Comment", @"Common", @"Search", @"Collection", @"Preview", @"Picker", @"Header", @"Setting", @"Info"];
    NSArray *forthArray = @[@"View", @"VC", @"Controller"];
    NSString *randomStr = [NSString stringWithFormat:@"%@%@%@%@",firstArray[arc4random() % firstArray.count],secondArray[arc4random() % secondArray.count],thirdArray[arc4random() % thirdArray.count],forthArray[arc4random() % forthArray.count]];
    return randomStr;
}


@end
