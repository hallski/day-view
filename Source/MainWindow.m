//
//  MainWindow.m
//  DayView
//
//  Created by Mikael Hallendal on 2009-11-29.
//

#import <QuartzCore/QuartzCore.h>

#import "MainWindow.h"


@implementation MainWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:aStyle
                              backing:bufferingType
                                defer:flag];
    
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setMovableByWindowBackground:NO];
        [self setLevel:NSNormalWindowLevel - 1];
        [self setStyleMask:NSBorderlessWindowMask];
        [self setCollectionBehavior:NSWindowCollectionBehaviorStationary];
        [self setCanHide:NO];
        [self setIgnoresMouseEvents:YES];
        
        NSRect visibleFrame = [[NSScreen mainScreen] visibleFrame];
        [self setFrameTopLeftPoint:NSMakePoint(NSMinX(visibleFrame) + 20, NSMaxY(visibleFrame) - 20)];

    }
    
    return self;
}


@end
