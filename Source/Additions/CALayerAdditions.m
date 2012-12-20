//
//  CALayerAdditions.m
//  Charts
//
//  Created by Richard Hult on 2009-11-24.
//

#import "CALayerAdditions.h"


@implementation CALayer (TBILayerAdditions)

- (void)addConstraintsToFillSuperlayer
{
    [self addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                   relativeTo:@"superlayer"
                                                    attribute:kCAConstraintMinX]];
    [self addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
                                                   relativeTo:@"superlayer"
                                                    attribute:kCAConstraintMinY]];
    [self addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth
                                                   relativeTo:@"superlayer"
                                                    attribute:kCAConstraintWidth]];
    [self addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight
                                                   relativeTo:@"superlayer"
                                                    attribute:kCAConstraintHeight]];
}

- (double)alphaAtPoint:(NSPoint)point
{
    int width = [self bounds].size.width;
    int height = [self bounds].size.height;

    // Flip the y coordinate since the bitmap context will be drawn to non-flipped.
    int y = height - point.y;
    int x = point.x;
    
    if (x < 0 || x >= width || y < 0 || y >= height) {
        return 0;
    }
    
    // Set up a CGImage context with a full RGBA colorspace.
    int bitsPerComponent = 8;
    int bytesPerPixel = 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // The CoreGraphics docs recommend aligning bytesPerRow to 16 bytes for performance like so:
    int bytesPerRow = (bytesPerPixel * width + 15) & ~15;
    
    UInt8 *rawData = calloc(1, height * bytesPerRow);
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width, height,
                                                 bitsPerComponent, bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    
    // Draw the layer into it.
    [self renderInContext:context];

    int byteIndex = bytesPerRow * y + bytesPerPixel * x;
    double alpha = rawData[byteIndex + bytesPerPixel - 1] / 255.0;
    
    CGContextRelease(context);
    free(rawData);
    
    return alpha;
}

@end
