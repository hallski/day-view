//
//  DayViewAppDelegate.h
//  DayView
//
//  Created by Mikael Hallendal on 2009-11-29.
//

#import <Cocoa/Cocoa.h>

@class CalendarModel;

@interface DayViewAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet NSView *view;
    
    CalendarModel *calendar;
}

@property (assign) IBOutlet NSWindow *window;

@end
