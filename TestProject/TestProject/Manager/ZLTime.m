//
//  ZLTime.m
//  TestProject
//
//  Created by DanaLu on 2018/5/3.
//  Copyright © 2018年 gh. All rights reserved.
//

#import "ZLTime.h"
#import "NSDate+MTDates.h"

static NSString *const KDefaultTimeFormatString = @"yyyy-MM-dd HH:mm:ss z";

@interface ZLTime()

@property (nonatomic, strong) NSDate *endDate; //结束日期
@property (nonatomic, strong) NSDate *beginDate; //开始日期
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) TimerTriggerBlock triggerBlock;

@property (nonatomic) NSTimeInterval timeDeviation;    //服务器时间与本地时间差值

- (void)startTimer;

@end


@implementation ZLTime

- (id)initWithBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate {
    self = [super init];
    if (self) {
        self.timeDeviation = 0;
        self.beginDate = beginDate;
        self.endDate = endDate;
        
        if (beginDate && endDate) {
            //获取偏差.
            //获取服务器时间.
            NSString *serverTimeString = @"";
            NSTimeInterval timeDeviation = [ZLTime getTimeDeviationWithServiceDate:serverTimeString];
            self.beginDate = [NSDate dateWithTimeInterval:timeDeviation sinceDate:[NSDate date]];  // 纠正服务器时间和本地时间的偏差
            
            [self calculateMistiming];
        }
    }
    return self;
}

- (id)init {
    return [self initWithBeginDate:nil endDate:nil];
}

- (void)addNotificationWhenAppEnterBackgroundOrForeground {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:NSExtensionHostDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:NSExtensionHostDidBecomeActiveNotification object:nil];
}

- (void)applicationDidEnterBackground {
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)applicationDidBecomeActive {
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)fireTimer {
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)pauseTimer {
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)calculateMistiming {
    NSInteger timeInterval = (NSInteger)[self.endDate timeIntervalSinceDate:self.beginDate];
    
    NSInteger hourInterval = 60 * 60;
    NSInteger dayInterval = 60 * 60 * 24;
    
    if(timeInterval > 0) {
        NSInteger day = timeInterval / dayInterval;
        NSInteger hour = timeInterval % dayInterval / hourInterval;
        NSInteger minute = timeInterval % dayInterval % hourInterval / 60;
        NSInteger second = timeInterval % dayInterval % hourInterval % 60 % 60;
        _day = day;
        _hour = hour;
        _minute = minute;
        _second = second;
    } else {
        _day = _hour = _minute = _second = 0;
    }
}

- (BOOL)timeIsOver {
    return self.day <= 0 && self.hour <= 0 && self.minute <= 0 && self.second <= 0;
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timerTriggerInterval target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

- (void)countdown {
    //倒计时
    BOOL shouldStop = NO;
    if (self.endDate) {
        self.beginDate = [NSDate dateWithTimeInterval:self.timeDeviation sinceDate:[NSDate date]];  // 纠正服务器时间和本地时间的偏差
        [self calculateMistiming];
        shouldStop = [self timeIsOver];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.triggerBlock) {
            self.triggerBlock(self, shouldStop);
            
            if (shouldStop) {
                [self stopTimer];
            }
        }
    });
}

+ (instancetype)timeSurplusWithBeginDateString:(NSString*)beginDateString endDateString:(NSString*)endDateString {
    NSDate *beginDate = [self dateFromDateString:beginDateString format:KDefaultTimeFormatString];
    NSDate *endDate = [self dateFromDateString:endDateString format:KDefaultTimeFormatString];
    
    ZLTime *time = [[ZLTime alloc] initWithBeginDate:beginDate endDate:endDate];
    
    return time;
}

+ (instancetype)timeSurplusWithBeginDateString:(NSString*)beginDateString beginDateFormat:(NSString*)beginFormatString endDateString:(NSString*)endDateString endDateFormat:(NSString*)endFormatString {
    NSDate *beginDate = [self dateFromDateString:beginDateString format:[self getDateFormatString:beginFormatString]];
    NSDate *endDate = [self dateFromDateString:endDateString format:[self getDateFormatString:endFormatString]];
    
    ZLTime *time = [[ZLTime alloc] initWithBeginDate:beginDate endDate:endDate];
    
    return time;
}

//时间对象
+ (instancetype)timeSurplusWithBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate {
    beginDate = beginDate ? beginDate : [NSDate date];
    endDate = endDate ? endDate : [NSDate date];
    ZLTime *time = [[ZLTime alloc] initWithBeginDate:beginDate endDate:endDate];
    
    return time;
}


+ (instancetype)startTimerWithTimerInterval:(NSTimeInterval)interval responseHandler:(TimerTriggerBlock)block {
    return [self startTimerWithTimerInterval:interval endDate:nil responseHandler:^(ZLTime *timesurplus, BOOL isStoped) {
        block(timesurplus, isStoped);
    }];
}

+ (instancetype)startTimerWithTimerInterval:(NSTimeInterval)interval endDate:(NSDate*)endDate responseHandler:(TimerTriggerBlock)block {
    ZLTime *time = [[ZLTime alloc] init];
    time->_timerTriggerInterval = interval;
    time.endDate = endDate;
    time.triggerBlock = block;
    
    //获取偏差.
    //获取服务器时间.
    NSString *serverTimeString = @"";
    time.timeDeviation = [ZLTime getTimeDeviationWithServiceDate:serverTimeString];
    
    [time addNotificationWhenAppEnterBackgroundOrForeground];
    [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:time withObject:nil];
    
    return time;
}

+ (instancetype)startTimerWithTimerInterval:(NSTimeInterval)interval endDateString:(NSString*)endDateString format:(NSString *)format responseHandler:(TimerTriggerBlock)block {
    
    NSDate *date = nil;
    if (endDateString && endDateString.length > 0) {
        NSString *formatString = [self getDateFormatString:format];
        date = [self dateFromDateString:endDateString format:formatString];
    }
    
    return [self startTimerWithTimerInterval:interval endDate:date responseHandler:^(ZLTime *timesurplus, BOOL isStoped) {
        block(timesurplus, isStoped);
    }];
}

- (void)stopTimer {
    self.triggerBlock = nil;
    [self.timer invalidate];
    self.timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)isTimerFiring {
    return [self.timer isValid];
}

+ (NSDate*)dateFromDateString:(NSString*)time format:(NSString*)format {
    if (!time || time.length == 0) {
        return [NSDate date];
    }
    
    time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    
    return [dateFormat dateFromString:time];
}


+ (NSString*)getDateFormatString:(NSString*)formatString {
    return (formatString && formatString.length) > 0 ? formatString : KDefaultTimeFormatString;
}

+ (NSTimeInterval)getTimeDeviationWithServiceDate:(NSString *)dateString {
    NSDate *serviceDate = [ZLTime dateFromDateString:dateString format:[ZLTime getDateFormatString:nil]];;
    NSDate *currnetDate = [NSDate date];
    
    return [serviceDate timeIntervalSinceDate:currnetDate];
}

@end
