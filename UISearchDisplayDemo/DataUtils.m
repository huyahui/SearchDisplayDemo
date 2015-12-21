//
//  DataUtils.m
//  UISearchDisplayDemo
//
//  Created by DukeDouglas on 14-2-28.
//  Copyright (c) 2014年 DukeDouglas. All rights reserved.
//

#import "DataUtils.h"

@implementation DataUtils



+ (NSDictionary *)parseData
{
    //1.获取文本的路径信息
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"crayons" ofType:@"txt"];
    //2.将文本数据转换成字符串
    NSString *textString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //3.分割字符串
    NSArray *stringArray = [textString componentsSeparatedByString:@"\n"];
    //4.实例化一个字典对象
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //5.接着拆分数组中存储的每一个子字符串
    
    for (NSString *subString in stringArray) {
        NSArray *subArray = [subString componentsSeparatedByString:@" #"];
        NSString *keyString = [subArray objectAtIndex:0];
        NSString *valueString = [subArray objectAtIndex:1];
        //将对应的keyString和valueString存储到字典中
        [dictionary setObject:valueString forKey:keyString];
    }
    return dictionary;
}








@end
