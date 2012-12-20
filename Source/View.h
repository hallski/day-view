//
//  View.h
//  DayView
//
//  Created by Mikael Hallendal on 2009-11-29.
//

#import <Cocoa/Cocoa.h>

@interface View : NSView {
    CALayer *clockLayer;
    CALayer *dateStringLayer;
    CALayer *lineLayer;
    CALayer *tasksLayer;
    
    NSArray *tasks;
}
@property(retain) NSArray *tasks;

@end
