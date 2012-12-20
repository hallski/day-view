//
//  TasksLayer.m
//  DayView
//
//  Created by Mikael Hallendal on 2009-11-30.
//

#import <CalendarStore/CalendarStore.h>

#import "TasksLayer.h"
#import "NSColorAdditions.h"
#import "CalendarModel.h"

@implementation TasksLayer
@synthesize tasks;

- (NSArray *)addLayersForRow:(int)row
{
    CALayer *layer = [CALayer layer];
    
    [layer setName:[NSString stringWithFormat:@"taskdonelayer %d", row]];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:CGColorGetConstantColor(kCGColorWhite)];
    
    [self addSublayer:layer];
    
    CATextLayer *textlayer = (CATextLayer *)[CATextLayer layer];
    
    [textlayer setName:[NSString stringWithFormat:@"tasklayer %d", row]];
    [textlayer setFontSize:25.0];
    
    [self addSublayer:textlayer];
    
    [layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                    relativeTo:@"superlayer"
                                                     attribute:kCAConstraintMinX]];
    
    [layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
                                                    relativeTo:[NSString stringWithFormat:@"tasklayer %d", row]
                                                     attribute:kCAConstraintMinY
                                                        offset:7.5]];
    
    [layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                    relativeTo:[NSString stringWithFormat:@"tasklayer %d", row]
                                                     attribute:kCAConstraintMaxY
                                                        offset:-7.5]];
        
    [layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth
                                                    relativeTo:[NSString stringWithFormat:@"taskdonelayer %d", row]
                                                     attribute:kCAConstraintHeight]];
    
    [textlayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                        relativeTo:[NSString stringWithFormat:@"taskdonelayer %d", row]
                                                         attribute:kCAConstraintMaxX
                                                            offset:7.5]];
    
    if (row == 0) {
        [textlayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                            relativeTo:@"superlayer"
                                                             attribute:kCAConstraintMaxY
                                                                offset:-15]];
    } else {
        [textlayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                            relativeTo:[NSString stringWithFormat:@"tasklayer %d", row - 1]
                                                             attribute:kCAConstraintMinY
                                                                offset:-15]];
    }

    return [NSArray arrayWithObjects:layer, textlayer, nil];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    }
    
    return self;
}

- (void)setTasks:(NSArray *)newTasks
{
    int i = 0;
    for (CalTask *task in newTasks) {
        CATextLayer *textlayer = nil;
        CALayer *donelayer = nil;

        if ([[self sublayers] count] <= i * 2) {
            NSArray *layers = [self addLayersForRow:i];
            donelayer = [layers objectAtIndex:0];
            textlayer = [layers objectAtIndex:1];
        } else {
            for (CALayer *layer in [self sublayers]) {
                if ([[layer name] isEqualToString:[NSString stringWithFormat:@"tasklayer %d", i]]) {
                    textlayer = (CATextLayer *)layer;
                    if (donelayer != nil) {
                        break;
                    }
                } 
                else if ([[layer name] isEqualToString:[NSString stringWithFormat:@"taskdonelayer %d", i]]) {
                    donelayer = layer;
                    if (textlayer != nil) {
                        break;
                    }
                }
            }            
        }
        
        if (textlayer) {
            [textlayer setString:[task title]];
        }
        
        if (donelayer) {
            if ([task isCompleted]) {
                [donelayer setBackgroundColor:CGColorGetConstantColor(kCGColorWhite)];
            } else {
                [donelayer setBackgroundColor:[[NSColor clearColor] CGColor]];
            }
        }
        ++i;
    }
    
}


@end
