#import "AppDelegate.h"
#import "ViewController.h"
#import <Cocoa/Cocoa.h>
#import "../../include/common.h"
#import "../../include/conversion.h"

@interface AppDelegate ()
@property (strong) NSWindow *window;
@property (strong) ViewController *viewController;
@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
        NSRect frame = NSMakeRect(200, 200, 760, 940);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                               styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable)
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO];
    [self.window setTitle:@"ComPDF Conversion SDK V4.1.0"];
        [self.window setMinSize:NSMakeSize(760, 940)];
    self.viewController = [[ViewController alloc] init];
    self.window.contentViewController = self.viewController;
    
    [self.window center];
    [self.window makeKeyAndOrderFront:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [LibraryManager release];
}
@end
