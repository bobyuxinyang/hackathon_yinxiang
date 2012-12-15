//
//  DDXMLNode+DDXMLNode_CDATA.m
//  playBumpAndXmpp
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import "DDXMLNode+CDATA.h"
#import "DDXMLElement.h"
#import "DDXMLDocument.h"

@implementation DDXMLNode (CDATA)

+ (id)cdataElementWithName:(NSString *)name stringValue:(NSString *)string
{
    NSString* nodeString = [NSString stringWithFormat:@"<%@><![CDATA[%@]]></%@>", name, string, name];
    DDXMLElement* cdataNode = [[DDXMLDocument alloc] initWithXMLString:nodeString
                                                               options:DDXMLDocumentXMLKind
                                                                 error:nil].rootElement;
    return [cdataNode copy];
}

@end