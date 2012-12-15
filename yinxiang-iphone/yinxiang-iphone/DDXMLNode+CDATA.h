//
//  DDXMLNode+DDXMLNode_CDATA.h
//  playBumpAndXmpp
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLNode.h"

@interface DDXMLNode (CDATA)

/**
 Creates a new XML element with an inner CDATA block
 <name><![CDATA[string]]></name>
 */
+ (id)cdataElementWithName:(NSString *)name stringValue:(NSString *)string;

@end