//
//  ViewController.m
//  KissXMLDemo
//
//  Created by shawn on 2020/4/8.
//  Copyright © 2020 shawn. All rights reserved.
//

#import "ViewController.h"
#import <KissXML.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)buttonAction:(id)sender {
    
    UIButton *button = sender;
    
    if (button.tag == 1) {
        [self button1Action];
    }
    else if (button.tag == 2) {
        [self button2Action];
    }
    else {
        [self button3Action];
    }
    
}

- (void)button1Action
{
    ///获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"];
    ///把文件转化成string
    NSString *xmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    ///使用kissXML解析
    DDXMLDocument *xmlDocument = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
    ///找到xmlDocument下面所有的book元素
    NSArray *arr = [xmlDocument nodesForXPath:@"//book" error:nil];
    
    for (int i = 0; i < arr.count; i ++) {
        DDXMLElement *element = arr[i];
        //分别为当前接点的名字、上一个接点（平级）、下一个接点（平级）、上一个接点、第一个子节点
        NSLog(@" 打印信息:%@--%@--%@--%@--%@--%@",element.name,element.previousSibling.name,element.nextSibling.name,element.previousNode.name,element.nextNode.name,element.parent.name);
    }
}

- (void)button2Action
{
    ///获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"];
    ///把文件转化成string
    NSString *xmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    ///使用kissXML解析
    DDXMLDocument *xmlDocument = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
    
    
    NSLog(@"XML元素的数量%ld",xmlDocument.childCount);
    NSLog(@"XML元素的数组%@",xmlDocument.children);
    
    ///找到要修改的元素 修改内容
    for (DDXMLElement *element in xmlDocument.children) {
        ///找到shop元素
        if ([element.name isEqualToString:@"shop"]) {
            DDXMLElement *shopElement = element;
            ///shop标签下的所有元素数组
            NSArray *penChildren = shopElement.children;
            for (DDXMLElement *childelement in penChildren) {
                ///找到pen元素
                if ([childelement.name isEqualToString:@"pen"]) {
                    
                    for (DDXMLNode *childnode in childelement.children) {
                        if ([childnode.name isEqualToString:@"type"]) {
                            [childnode setStringValue:@"---000---"];
                        }
                        if ([childnode.name isEqualToString:@"manufacturers"]) {
                            [childnode setStringValue:@"---xxxxx---"];
                        }
                    }
                }
            }
        }
    }
    
    ///修改完成之后需要把XML文件重新保存到新的地址 原文件修改的值不变
    NSString *newPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"newXML.xml"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ///查看路径是否存在
    BOOL isFile = [fileManager fileExistsAtPath:newPath];
    if (isFile) {
        [fileManager removeItemAtPath:newPath error:nil];
    }
    NSMutableData *mutableData = [NSMutableData data];
    NSData *data = [xmlDocument XMLData];
    [mutableData appendData:data];
    
    [mutableData writeToFile:newPath atomically:YES];
}

- (void)button3Action
{
    ///获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"];
    ///把文件转化成string
    NSString *xmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    ///使用kissXML解析
    DDXMLDocument *xmlDocument = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
    
    for (DDXMLElement *ele in xmlDocument.children) {
        if ([ele.name isEqualToString:@"shop"]) {
            DDXMLElement *elementOne = [DDXMLElement elementWithName:@"one" stringValue:@"one"];
            DDXMLElement *elementTwo = [DDXMLElement elementWithName:@"two" stringValue:@"two"];
            [ele addChild:elementOne];
            [ele addChild:elementTwo];
        }
    }
    
    ///修改完成之后需要把XML文件重新保存到新的地址 原文件修改的值不变
    NSString *newPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"newXML.xml"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ///查看路径是否存在
    BOOL isFile = [fileManager fileExistsAtPath:newPath];
    if (isFile) {
        [fileManager removeItemAtPath:newPath error:nil];
    }
    NSMutableData *mutableData = [NSMutableData data];
    NSData *data = [xmlDocument XMLData];
    [mutableData appendData:data];
    
    [mutableData writeToFile:newPath atomically:YES];
    
}

@end
