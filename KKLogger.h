//
//  KKLogger.h
//
//  Created by Kirill on 1/27/15.
//  Copyright (c) 2015 Kirill. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DLog(...)   [[KKLogger sharedInstance] logToFile:[NSString stringWithFormat:__VA_ARGS__]]
#define DFLog(...)  NSString *string = [NSString stringWithFormat:__VA_ARGS__]; \
                    [[KKLogger sharedInstance] logToFile:[NSString stringWithFormat:@"%s %@", __FUNCTION__, string]]

@interface KKLogger : NSObject

+ (instancetype)sharedInstance;

- (void)logToFile:(NSString *)logText;

@end
