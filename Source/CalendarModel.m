//
//  CalendarModel.m
//  DayView
//
//  Created by Mikael Hallendal on 2009-12-02.
//

#import <CalendarStore/CalendarStore.h>

#import "CalendarModel.h"


@implementation CalendarModel
@synthesize tasks;

- (id)init
{
    self = [super init];
    if (self) {
        [self update];
    }

    return self;
}

- (void)update
{
    NSPredicate *predicate = [CalCalendarStore taskPredicateWithCalendars:[[CalCalendarStore defaultCalendarStore] calendars]];
    NSArray *newTasks = [[CalCalendarStore defaultCalendarStore] tasksWithPredicate:predicate];

    [self setTasks:newTasks];
}

@end
