//
//  ClockLayer.h
//  DayView
//
//  Created by Mikael Hallendal on 2009-12-05.
//

#import <Cocoa/Cocoa.h>


@class ClockModel;

@interface ClockLayer : CALayer {
    CALayer *borderLayer;
    CALayer *clockFaceLayer;
    CALayer *secondsLayer;
    
    ClockModel *clock;
    
    int lastUpdateMinute;
}

@end
