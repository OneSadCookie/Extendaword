#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (LayerImage)

- (CGImageRef)layerImage;

@end

@implementation CALayer (LayerImage)

- (CGImageRef)layerImage;
{
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGContextRef context = NULL;
	CGImageRef cgimage = NULL;

	context = CGBitmapContextCreate(NULL, 1024, 1024, 8, 0, colorspace, kCGImageAlphaPremultipliedLast);
	if (context) {
		[self renderInContext:context];

		cgimage = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
	}

	CGColorSpaceRelease(colorspace);
	return cgimage;
}

@end

#define TILE_WIDTH 866.0
#define TILE_HEIGHT 984.0
#define CORNER_RADIUS 158.0

CATextLayer *EWMakeLetterLayer(NSString *letter)
{
    CATextLayer *layer = [CATextLayer layer];
    [layer setAlignmentMode:kCAAlignmentCenter];
    [layer setString:[[NSAttributedString alloc] initWithString:letter attributes:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSFont fontWithName:@"Ubuntu-Medium" size:826.0], NSFontAttributeName,
            [NSColor blackColor], NSForegroundColorAttributeName,
            nil]]];
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setBackgroundColor:CGColorCreateGenericRGB(0.87, 0.86, 0.76, 1.0)];
    [layer setBounds:CGRectMake(79.0, 40.0, TILE_WIDTH, TILE_HEIGHT)];
    [layer setShadowOffset:CGSizeMake(40, -40)];
    [layer setShadowColor:CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0)];
    [layer setShadowOpacity:0.5f];
    
    return layer;
}

int main()
{
	@autoreleasepool {
		NSURL *fontURL = [NSURL fileURLWithPath:@"Extendaword/Ubuntu-Medium.ttf"];
		assert(fontURL);
	    CFErrorRef error = NULL;
	    if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontURL, kCTFontManagerScopeProcess, &error))
	    {
	        CFShow(error);
	        abort();
	    }

		CALayer *layer = EWMakeLetterLayer(@"E");

		NSImage * img = [[NSImage alloc] initWithCGImage:[layer layerImage] size:layer.bounds.size];
		[[img TIFFRepresentation] writeToFile:@"Extendaword.tiff" atomically:YES];
	}
}
