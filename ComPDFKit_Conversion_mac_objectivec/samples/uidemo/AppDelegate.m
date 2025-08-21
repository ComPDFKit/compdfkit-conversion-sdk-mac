#import "AppDelegate.h"
#import "ViewController.h"
#import <Cocoa/Cocoa.h>
#import "include/common.h"
#import "include/conversion.h"

@interface AppDelegate ()
@property (strong) NSWindow *window;
@property (strong) ViewController *viewController;
@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect frame = NSMakeRect(200, 200, 600, 680);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                               styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable)
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO];
    [self.window setTitle:@"ComPDFKit PDF Conversion Demo"];
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
