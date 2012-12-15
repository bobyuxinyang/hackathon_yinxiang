//
//  YXSharePackage.m
//  playBumpAndXmpp
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import "YXSharePackage.h"
#import "base64.h"

@implementation YXSharePackage
@synthesize type = _type;
@synthesize dictionaryData = _dictionaryData;
@synthesize base64Data = _base64Data;

- (NSMutableDictionary *)dictionaryData
{
    if (_dictionaryData == nil) {
        _dictionaryData = [NSMutableDictionary dictionary];
    }
    return _dictionaryData;
}

- (NSString *)base64Data
{
    if (_base64Data == nil) {
        _base64Data = @"";
    }
    return _base64Data;
}

- (NSString *)toPackageString
{
    NSMutableDictionary *packageDic = [NSMutableDictionary dictionary];
    [packageDic setObject: [NSNumber numberWithInt:self.type] forKey:@"type"];
    [packageDic setObject:self.dictionaryData forKey:@"dictionaryData"];
    [packageDic setObject:self.base64Data forKey:@"base64Data"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:packageDic options:NSJSONWritingPrettyPrinted error:&error];
    // base64
    const void *inInputData = [jsonData bytes];
    size_t inputDataSize = (size_t)[jsonData length];
    size_t outputDataSize = EstimateBas64EncodedDataSize(inputDataSize);//calculate the decoded data size
    char outputData[outputDataSize];//prepare a Byte[] for the decoded data
    Base64EncodeData(inInputData, inputDataSize, outputData, &outputDataSize, true);//decode the data
    NSData *base64Data = [[NSData alloc] initWithBytes:outputData length:outputDataSize];//create a NSData object from the decoded data
    
    NSString *dataString = [NSString stringWithCString:[base64Data bytes] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", dataString);
    return dataString;
}
+ (YXSharePackage *)packageFromString:(NSString *)dataString
{    
    Byte inputData[[dataString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    [[dataString dataUsingEncoding:NSUTF8StringEncoding] getBytes:inputData];
    size_t inputSize = (size_t)[dataString length];
    size_t outputDataSize = EstimateBas64DecodedDataSize(inputSize);
    Byte outputData[outputDataSize];
    Base64DecodeData(inputData, inputSize, outputData, &outputDataSize);
    NSData *theData = [[NSData alloc] initWithBytes:outputData length:outputDataSize];
    
    NSError *error = nil;
    NSMutableDictionary *packageDic = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:&error];
    
    YXSharePackage *package = [[YXSharePackage alloc] init];
    package.type = [[packageDic objectForKey:@"type"] intValue];
    package.dictionaryData = [packageDic objectForKey:@"dictionaryData"];
    package.base64Data = [packageDic objectForKey:@"base64Data"];
    return package;
}
@end
