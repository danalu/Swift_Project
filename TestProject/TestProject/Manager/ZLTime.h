//
//  ZLTime.h
//  TestProject
//
//  Created by DanaLu on 2018/5/3.
//  Copyright © 2018年 gh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZLTime;
typedef void(^TimerTriggerBlock)(ZLTime *timesurplus, BOOL isStoped);

@interface ZLTime : NSObject

@property (nonatomic, readonly) NSInteger day; //剩余天数,小于一天 = 0
@property (nonatomic, readonly) NSInteger hour; // 剩余小时
@property (nonatomic, readonly) NSInteger minute; //剩余分钟
@property (nonatomic, readonly) NSInteger second; //剩余秒数
//触发器触发时间，默认1秒
@property (nonatomic, readonly) NSTimeInterval timerTriggerInterval;
/** 服务器返回的开始时间 */
@property (nonatomic, copy) NSString *serviceDateString;

/*
*
* 计算时间差
* 方法调用后会自动给属性:day, hour, minute, second 赋值
* 时间参数为nil, 默认为当前系统时间
*/
//时间字符串，传的时候默认格式：（yyyy-MM-dd HH:mm:ss）
+ (instancetype)timeSurplusWithBeginDateString:(NSString*)beginDateString endDateString:(NSString*)endDateString;
//时间字符串，传的时候默认格式：自定义，传nil默认：（yyyy-MM-dd HH:mm:ss）
+ (instancetype)timeSurplusWithBeginDateString:(NSString*)beginDateString beginDateFormat:(NSString*)beginFormatString endDateString:(NSString*)endDateString endDateFormat:(NSString*)endFormatString;
//时间对象
+ (instancetype)timeSurplusWithBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;


/*
 * 定时器相关
 */
//开启定时器. (触发间隔，触发block，不生成day, hour, minute, second)
+ (instancetype)startTimerWithTimerInterval:(NSTimeInterval)interval responseHandler:(TimerTriggerBlock)block;
//开启定时器(触发间隔，触发block，通过计算endate与当前时间生成day, hour, minute, second)
+ (instancetype)startTimerWithTimerInterval:(NSTimeInterval)interval endDate:(NSDate*)endDate responseHandler:(TimerTriggerBlock)block;
//开启定时器(触发间隔，触发block，通过计算endate与当前时间生成day, hour, minute, second, format=nil默认yyyy-MM-dd HH:mm:ss)
+ (instancetype)startTimerWithTimerInterval:(NSTimeInterval)interval endDateString:(NSString*)endDateString format:(NSString *)format responseHandler:(TimerTriggerBlock)block;


//+ (void)dateStringWithDateString:(NSString *)dateString refreshBlock:(void (^)())refreshBlock;

//关掉定时器
- (void)stopTimer;

//过期
- (BOOL)timeIsOver;

//判断定时器是否开启
- (BOOL)isTimerFiring;

//viewdidappear时调用用于唤醒定时器
- (void)fireTimer;

//viewDiddisappear时暂停定时器
- (void)pauseTimer;


@end
