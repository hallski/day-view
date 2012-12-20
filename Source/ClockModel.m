//
//  Clock.m
//  DayView
//
//  Created by Mikael Hallendal on 2009-12-02.
//

#import "ClockModel.h"


@implementation ClockModel

- (void)updateComponents
{
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    if ((interval - lastUpdate) < 1) {
        // Only update every second
        return;
    }

    lastUpdate = interval;
    
    NSDate *now = [NSDate date];
    
    NSInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    components = [[NSCalendar currentCalendar] components:unitFlags fromDate:now];
}

- (int)hourValue
{
    [self updateComponents];
    
    return [components hour] % 12;
}

- (int)minuteValue
{
    [self updateComponents];

    return [components minute];
}

- (double)secondValue
{
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    
    return (int)interval % 60 + (interval - floor(interval));    
}

@end
