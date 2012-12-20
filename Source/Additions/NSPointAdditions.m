//
//  NSPointAdditions.m
//  Charts
//
//  Created by Richard Hult on 2009-07-02.
//

#import "NSPointAdditions.h"


NSPoint
TBIPointAlign(NSPoint point)
{
    point.x = floor(point.x) + 0.5;
    point.y = floor(point.y) + 0.5;
    
    return point;
}

NSPoint
TBIPointAlignForEvenLineWidth(NSPoint point)
{
    point.x = floor(point.x);
    point.y = floor(point.y);
    
    return point;
}

NSPoint
TBIPointAlignForLineWidth(NSPoint point, int width)
{
    if (width % 2 == 0) {
        return TBIPointAlignForEvenLineWidth(point);
    } else {
        return TBIPointAlign(point);
    }
}
