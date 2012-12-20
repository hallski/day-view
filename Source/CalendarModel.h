//
//  CalendarModel.h
//  DayView
//
//  Created by Mikael Hallendal on 2009-12-02.
//

#import <Cocoa/Cocoa.h>


@interface CalendarModel : NSObject {
    NSArray *tasks;
}
@property(retain) NSArray *tasks;

- (void)update;

@end
