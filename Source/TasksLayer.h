//
//  TasksLayer.h
//  DayView
//
//  Created by Mikael Hallendal on 2009-11-30.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface TasksLayer : CALayer {
    NSArray *tasks;
}
@property(retain) NSArray *tasks;

@end
