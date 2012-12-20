//
//  Clock.h
//  DayView
//
//  Created by Mikael Hallendal on 2009-12-02.
//

#import <Cocoa/Cocoa.h>


@interface ClockModel : NSObject {
    
    @private
    NSTimeInterval lastUpdate;
    NSDateComponents *components;
}

- (int)hourValue;
- (int)minuteValue;
- (double)secondValue;

@end
