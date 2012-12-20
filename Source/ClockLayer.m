//
//  ClockLayer.m
//  DayView
//
//  Created by Mikael Hallendal on 2009-12-05.
//

#import <QuartzCore/QuartzCore.h>

#import "ClockLayer.h"
#import "ClockModel.h"


@implementation ClockLayer

- (id)init
{
    self = [super init];
    if (self) {
        [self setLayoutManager:[CAConstraintLayoutManager layoutManager]];
        
        borderLayer = [CALayer layer];
        
        [borderLayer setDelegate:self];
        [borderLayer setName:@"borderLayer"];
        
        [borderLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                              relativeTo:@"clockface"
                                                               attribute:kCAConstraintMinX]];
        [borderLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                              relativeTo:@"clockface"
                                                               attribute:kCAConstraintMaxX]];
        [borderLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
                                                              relativeTo:@"clockface"
                                                               attribute:kCAConstraintMinY]];
        [borderLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                              relativeTo:@"clockface"
                                                               attribute:kCAConstraintMaxY]];
        [borderLayer setNeedsDisplay];
        [borderLayer setOpacity:0.4];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.duration = 2.0;
        
        [borderLayer setActions:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNull null], @"contents",
                                 [NSNull null], @"bounds",
                                 [NSNull null], @"position",
                                 animation, @"opacity",
                                 nil]];
        
        [self addSublayer:borderLayer];
        
        clockFaceLayer = [CALayer layer];
        [clockFaceLayer setActions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNull null], @"contents",
                                    [NSNull null], @"bounds",
                                    [NSNull null], @"position",
                                    nil]];
        
        [clockFaceLayer setDelegate:self];
        [clockFaceLayer setName:@"clockface"];
        
        [clockFaceLayer setBounds:CGRectMake(0.0, 0.0, 200.0, 200.0)];
        
        [clockFaceLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                                 relativeTo:@"superlayer"
                                                                  attribute:kCAConstraintMinX]];
        [clockFaceLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                                 relativeTo:@"superlayer"
                                                                  attribute:kCAConstraintMaxY]];
        
        [self addSublayer:clockFaceLayer];
        
        secondsLayer = [CALayer layer];
        
        [secondsLayer setActions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNull null], @"contents",
                                  [NSNull null], @"bounds",
                                  [NSNull null], @"position",
                                  nil]];
        
        [secondsLayer setDelegate:self];
        [secondsLayer setName:@"secondsLayer"];
        
        [secondsLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                               relativeTo:@"clockface"
                                                                attribute:kCAConstraintMinX]];
        [secondsLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                               relativeTo:@"clockface"
                                                                attribute:kCAConstraintMaxX]];
        [secondsLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
                                                               relativeTo:@"clockface"
                                                                attribute:kCAConstraintMinY]];
        [secondsLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                               relativeTo:@"clockface"
                                                                attribute:kCAConstraintMaxY]];
        
        [self addSublayer:secondsLayer];
        
        clock = [[ClockModel alloc] init];
        lastUpdateMinute = [clock minuteValue];

        [clockFaceLayer setNeedsDisplay];

        [NSTimer scheduledTimerWithTimeInterval:.05
                                         target:self
                                       selector:@selector(redrawClockFace:)
                                       userInfo:nil
                                        repeats:YES];
        
    }

    return self;
}

#define BORDER_WIDTH 7.5

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    NSRect boundsRect = NSRectFromCGRect([layer bounds]);

    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]];

    float radius = NSHeight(boundsRect) / 2 - BORDER_WIDTH;
    NSPoint center = NSMakePoint(NSMidX(boundsRect), NSMidY(boundsRect));
    
    if (layer == borderLayer) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path appendBezierPathWithArcWithCenter:center
                                         radius:radius
                                     startAngle:0.0
                                       endAngle:360];
        
        [path setLineWidth:BORDER_WIDTH];
        
        [[NSColor whiteColor] set];
        
        [path stroke];
    }
    else if (layer == clockFaceLayer) {
        int hour = [clock hourValue];
        int min = [clock minuteValue];
        
        float mins_arc = (2 * M_PI / 60) * min;
        float hours_arc = (2 * M_PI / 12) * hour;
        
        /* Color white for the rest */
        [[NSColor whiteColor] set];
        
        /* Minute hand */
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:center];
        
        NSPoint endPoint;
        
        endPoint.x = center.x + 0.9 * radius * sin(mins_arc);
        endPoint.y = center.y + 0.9 * radius * cos(mins_arc);
        [path lineToPoint:endPoint];
        
        [path setLineCapStyle:NSRoundLineCapStyle];
        
        [path setLineWidth:3.0];
        [path stroke];
        
        /* Hour hand */
        [path removeAllPoints];
        [path moveToPoint:center];
        endPoint.x = center.x + 0.7 * radius * sin(hours_arc);
        endPoint.y = center.y + 0.7 * radius * cos(hours_arc);
        [path lineToPoint:endPoint];
        [path setLineCapStyle:NSRoundLineCapStyle];
        
        [path setLineWidth:5.0];
        [path stroke];
    } 
    else if (layer == secondsLayer) {
        double secs = [clock secondValue];
        
        if (secs < 0.05) {
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
            [borderLayer setOpacity:1.0];
            [CATransaction commit];
        }
        
        float secs_arc = (2 * M_PI / 60) * secs;
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        
        [path appendBezierPathWithArcWithCenter:center
                                         radius:radius
                                     startAngle:90.0
                                       endAngle:(90 - secs_arc * 180 / M_PI)
                                      clockwise:YES];
        [path setLineCapStyle:NSButtLineCapStyle];
        
        [[NSColor whiteColor] set];
        
        [path setLineWidth:BORDER_WIDTH];
        [path stroke];
    }
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void)redrawClockFace:(NSTimer*)theTimer 
{
    
    if ([clock minuteValue] != lastUpdateMinute) {
        lastUpdateMinute = [clock minuteValue];
        
        [clockFaceLayer setNeedsDisplay];
        //[self updateDateString];
    }
    
    if ([borderLayer opacity] == 1.0) {
        [borderLayer setOpacity:0.4];
    }
    
    [secondsLayer setNeedsDisplay];
}


@end
