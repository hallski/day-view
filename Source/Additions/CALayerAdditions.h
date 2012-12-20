//
//  CALayerAdditions.h
//  Charts
//
//  Created by Richard Hult on 2009-11-24.
//

#import <QuartzCore/QuartzCore.h>


@interface CALayer (TBILayerAdditions)

- (void)addConstraintsToFillSuperlayer;
- (double)alphaAtPoint:(NSPoint)point;

@end
