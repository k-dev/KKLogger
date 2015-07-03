//
//  LogManager.m
//  testSuspending
//
//  Created by Kirill on 1/27/15.
//  Copyright (c) 2015 Kirill. All rights reserved.
//

#import "LogManager.h"

@interface LogManager ()

@property (strong, nonatomic) NSString* logFilePath;
@property (strong, nonatomic) NSDateFormatter *df;

@end

@implementation LogManager
{
    FILE *_file;
}

+ (instancetype)sharedInstance
{
    static LogManager * sSharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [self new];
    });
    
    return sSharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
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
    NSString *documentDirPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *path = documentDirPath;
    NSFileManager* manager = [NSFileManager new];
    if (![manager fileExistsAtPath:path])
    {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:@"log.txt"];
    _logFilePath = path;
    
    _file = fopen([_logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "aw");
    fprintf(_file, "%s\n", "------------------- Started App ---------------------");
    fflush(_file);
}

- (void)closeLogFile
{
    fclose(_file);
}

- (void)logToFile:(NSString *)logText
{
    time_t tm = time(NULL);
    NSString *humanDate = [_df stringFromDate:[NSDate date]];
    fprintf(_file, "|%s| |%02ld:%02ld:%02ld| |%lld|", [humanDate cStringUsingEncoding:NSUTF8StringEncoding], (tm / 3600) % 24, tm % 3600 / 60, tm % 60, (int64_t)tm);
    fprintf(_file, " %s\n", [logText cStringUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"%@", logText);
    fflush(_file);
}

@end