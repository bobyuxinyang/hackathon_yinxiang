//
//  AudioMessage.m
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/16/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import "AudioMessage.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioMessage
@synthesize dict = _dict;
@synthesize path = _path;
@synthesize duration = _duration;
@synthesize type = _type;
@synthesize size = _size;


- (id)initWithPath: (NSString *)filePath: (NSString *)type
{
    if (self = [super init]) {
        self.path = [NSURL URLWithString:filePath];
        self.type = type;
//        self.dict = [self generateFielDic];
//        self.duration = [self generateDuration];
//        self.size = []
        
    }
    
    return self;
}


- (float)generateDuration
{
	if ([self.dict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_ApproximateDurationInSeconds]])
		return [[self.dict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_ApproximateDurationInSeconds]] floatValue];
	else
		return 0;
}

- (NSDictionary *)generateFielDic
{
	AudioFileID fileID = nil;
	OSStatus error = noErr;
	
	error = AudioFileOpenURL((__bridge CFURLRef)self.path, kAudioFileReadPermission, 0, &fileID);
	if (error != noErr) {
        NSLog(@"AudioFileOpenURL failed");
    }
	
	UInt32 id3DataSize  = 0;
    char *rawID3Tag    = NULL;
	
    error = AudioFileGetPropertyInfo(fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
    if (error != noErr)
        NSLog(@"AudioFileGetPropertyInfo failed for ID3 tag");
	
    rawID3Tag = (char *)malloc(id3DataSize);
    if (rawID3Tag == NULL)
        NSLog(@"could not allocate %ld bytes of memory for ID3 tag", id3DataSize);
    
    error = AudioFileGetProperty(fileID, kAudioFilePropertyID3Tag, &id3DataSize, rawID3Tag);
    if( error != noErr )
        NSLog(@"AudioFileGetPropertyID3Tag failed");
	
	UInt32 id3TagSize = 0;
    UInt32 id3TagSizeLength = 0;
	
	error = AudioFormatGetProperty(kAudioFormatProperty_ID3TagSize, id3DataSize, rawID3Tag, &id3TagSizeLength, &id3TagSize);
	
    if (error != noErr) {
        NSLog( @"AudioFormatGetProperty_ID3TagSize failed" );
        switch(error) {
            case kAudioFormatUnspecifiedError:
                NSLog( @"Error: audio format unspecified error" );
                break;
            case kAudioFormatUnsupportedPropertyError:
                NSLog( @"Error: audio format unsupported property error" );
                break;
            case kAudioFormatBadPropertySizeError:
                NSLog( @"Error: audio format bad property size error" );
                break;
            case kAudioFormatBadSpecifierSizeError:
                NSLog( @"Error: audio format bad specifier size error" );
                break;
            case kAudioFormatUnsupportedDataFormatError:
                NSLog( @"Error: audio format unsupported data format error" );
                break;
            case kAudioFormatUnknownFormatError:
                NSLog( @"Error: audio format unknown format error" );
                break;
            default:
                NSLog( @"Error: unknown audio format error" );
                break;
        }
    }
	
	CFDictionaryRef piDict = nil;
    UInt32 piDataSize = sizeof(piDict);
	
    error = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
    if (error != noErr)
        NSLog(@"AudioFileGetProperty failed for property info dictionary");
	
	free(rawID3Tag);
	
	return (__bridge NSDictionary*)piDict;
}



- (NSInteger) fileSizeAtPath:(NSString*) filePath
{
    NSNumber *fileSize;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = @"/1ct.rtf";
    NSDictionary *fileAttributes = [fileManager fileAttributesAtPath:path traverseLink:YES];
    if (fileAttributes != nil) {
        NSNumber *fileSize;
        //文件大小
        if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
            NSLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
        
        }
    }
    
    return [fileSize integerValue];
}
@end
