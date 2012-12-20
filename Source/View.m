//
//  View.m
//  DayView
//
//  Created by Mikael Hallendal on 2009-11-29.
//

#import "View.h"
#import "NSColorAdditions.h"
#import "CALayerAdditions.h"
#import "NSPointAdditions.h"
#import "TasksLayer.h"
#import "ClockLayer.h"


@interface View ()

- (void)updateDateString;

@end


@implementation View
@synthesize tasks;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *rootLayer = [CALayer layer];
        [rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
        
        [rootLayer setActions:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNull null], @"contents",
                               [NSNull null], @"bounds",
                               [NSNull null], @"position",
                               nil]];

        [rootLayer setShadowOpacity:0.9];
 
        clockLayer = [[ClockLayer alloc] init];
        [clockLayer setName:@"clocklayer"];
        
        [clockLayer setBounds:CGRectMake(0.0, 0.0, 200.0, 200.0)];
        
        [clockLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                             relativeTo:@"superlayer"
                                                              attribute:kCAConstraintMinX]];
        [clockLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                             relativeTo:@"superlayer"
                                                              attribute:kCAConstraintMaxY]];
        [rootLayer addSublayer:clockLayer];
        
        dateStringLayer = [CATextLayer layer];
        
        [dateStringLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                                  relativeTo:@"clocklayer"
                                                                   attribute:kCAConstraintMaxX
                                                                      offset:50]];
        
        [dateStringLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                                  relativeTo:@"clocklayer"
                                                                   attribute:kCAConstraintMaxY]];
        
        [dateStringLayer setActions:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNull null], @"contents",
                               [NSNull null], @"bounds",
                               [NSNull null], @"position",
                               nil]];
        
        [(CATextLayer *)dateStringLayer setFont:@"Santana"];
        [(CATextLayer *)dateStringLayer setFontSize:60.0];
        [dateStringLayer setName:@"stringlayer"];
        
        [rootLayer addSublayer:dateStringLayer];

        lineLayer = [CALayer layer];
        [lineLayer setName:@"linelayer"];
        [lineLayer setDelegate:self];
        [lineLayer setNeedsDisplayOnBoundsChange:YES];

        [lineLayer setActions:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNull null], @"contents",
                               [NSNull null], @"bounds",
                               [NSNull null], @"position",
                               nil]];
        

        [lineLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                            relativeTo:@"stringlayer"
                                                             attribute:kCAConstraintMinX]];
        [lineLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                            relativeTo:@"stringlayer"
                                                             attribute:kCAConstraintMaxX]];
        [lineLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
                                                            relativeTo:@"stringlayer"
                                                             attribute:kCAConstraintMinY]];
        [lineLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                            relativeTo:@"stringlayer"
                                                             attribute:kCAConstraintMaxY]];
        
        [rootLayer addSublayer:lineLayer];
        
        tasksLayer = [TasksLayer layer];
        
        [tasksLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                             relativeTo:@"linelayer"
                                                              attribute:kCAConstraintMinY
                                                                 offset:-10]];
        [tasksLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                             relativeTo:@"linelayer"
                                                              attribute:kCAConstraintMinX]];
        [tasksLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                             relativeTo:@"linelayer"
                                                              attribute:kCAConstraintMaxX]];
        [tasksLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
                                                             relativeTo:@"superlayer"
                                                              attribute:kCAConstraintMinY]];
        
        [tasksLayer bind:@"tasks" toObject:self withKeyPath:@"tasks" options:nil];
        
        [rootLayer addSublayer:tasksLayer];

        [self setLayer:rootLayer];
        
        [self updateDateString];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    NSRect boundsRect = NSRectFromCGRect([layer bounds]);

    if (layer == lineLayer) {
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]];
        NSBezierPath *path = [NSBezierPath bezierPath];
        
        [path moveToPoint:TBIPointAlignForLineWidth(NSMakePoint(NSMinX(boundsRect), NSMinY(boundsRect)), 3)];
        [path lineToPoint:TBIPointAlignForLineWidth(NSMakePoint(NSMaxX(boundsRect), NSMinY(boundsRect)), 3)];
        [path setLineWidth:3.0];
        [[NSColor whiteColor] set];
        
        [path stroke];
        [NSGraphicsContext restoreGraphicsState];
        return;
    }
}

- (void)updateDateString
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy"];
    
    NSString *string = [dateFormatter stringFromDate:now];
    
    [(CATextLayer *)dateStringLayer setString:string];       
}


@end
