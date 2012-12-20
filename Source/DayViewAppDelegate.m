//
//  DayViewAppDelegate.m
//  DayView
//
//  Created by Mikael Hallendal on 2009-11-29.
//

#import <QuartzCore/QuartzCore.h>

#import "DayViewAppDelegate.h"
#import "CalendarModel.h"


@implementation DayViewAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
    calendar = [[CalendarModel alloc] init];
    
    [view bind:@"tasks" toObject:calendar withKeyPath:@"tasks" options:nil];

	// Insert code here to initialize your application 
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateModel:)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)updateModel:(NSTimer *)timer
{
    [calendar update];
}

@end
