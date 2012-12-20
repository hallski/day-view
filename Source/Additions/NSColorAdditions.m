// From http://tonyarnold.com/code-snippets/nscolor-cgcolorref/

#import "NSColorAdditions.h"


@implementation NSColor (CGColorRef)

- (CGColorRef)CGColor 
{
    CGColorRef color;
    
    @try {
        NSInteger componentCount = [self numberOfComponents];    
        CGColorSpaceRef cgColorSpace = [[self colorSpace] CGColorSpace];
        CGFloat *components = (CGFloat *)calloc(componentCount, sizeof(CGFloat));
        if (!components) {
            NSException *exception = [NSException exceptionWithName:NSMallocException 
                                                             reason:@"Unable to malloc color components" 
                                                           userInfo:nil];
            @throw exception;
        }
        
        [self getComponents:components];
        color = CGColorCreate(cgColorSpace, components);
        free(components);
    } @catch (NSException *e) {
        // We were probably passed a pattern, which isn't going to work. Return clear color constant.
        return CGColorGetConstantColor(kCGColorClear);
    }
    
    return (CGColorRef)[NSMakeCollectable(color) autorelease];
}

@end
