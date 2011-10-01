#import <Cocoa/Cocoa.h>

static void EWActivateFont(NSString *fontName)
{
    // can't make ATSApplicationFontsPath in Info.plist work for some reason...
    NSURL *fontURL = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf"];
    assert(fontURL);
    CFErrorRef error = NULL;
    if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontURL, kCTFontManagerScopeProcess, &error))
    {
        CFShow(error);
        abort();
    }
}

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        EWActivateFont(@"Ubuntu-Medium");
        EWActivateFont(@"Bangers");
    }
    return NSApplicationMain(argc, (const char **)argv);
}
