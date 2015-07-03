//
//  KKLogger.m
//
//  Created by Kirill on 1/27/15.
//  Copyright (c) 2015 Kirill. All rights reserved.
//

#import "LogManager.h"

@interface KKLogger ()

@property (strong, nonatomic) NSString *logsFilePath;
@property (strong, nonatomic) NSDateFormatter *df;

@end

@implementation KKLogger
{
    FILE *_file;
}

+ (instancetype)sharedInstance
{
    static KKLogger * sSharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [self new];
    });
    
    return sSharedInstance;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    _df = [[NSDateFormatter alloc] init];
    [_df setTimeZone:[NSTimeZone systemTimeZone]];
    [_df setDateStyle:NSDateFormatterShortStyle];
    [_df setTimeStyle:NSDateFormatterShortStyle];
    
    [self initLogFile];
}

- (void)dealloc
{
    [self closeLogFile];
}

- (void)initLogFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    _logsFilePath = [documentsDirPath stringByAppendingPathComponent:@"log.txt"];
    
    _file = fopen([_logsFilePath cStringUsingEncoding:NSASCIIStringEncoding], "aw");
    fprintf(_file, "*** NEW SESSION ***\n");
    fflush(_file);
}

- (void)closeLogFile
{
    fclose(_file);
}

- (void)logToFile:(NSString *)logText
{
    NSDate *date = [NSDate date];
    NSString *humanDate = [_df stringFromDate:date];
//    double milliseconds = [date timeIntervalSinceReferenceDate];
    fprintf(_file, "%s: ", [humanDate cStringUsingEncoding:NSUTF8StringEncoding]);
    fprintf(_file, "%s\n", [logText cStringUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"%@", logText);
    fflush(_file);
}

@end
