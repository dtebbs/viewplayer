//
//  PlayerAppDelegate.m
//  Player
//
//  Created by Duncan Tebbs on 5/14/11.
//  Copyright 2011 oyatsukai.com. All rights reserved.
//

#import "PlayerAppDelegate.h"

#include <dlfcn.h>

@implementation PlayerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
/*
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resources = [bundle resourcePath];
    const char *resourcesDir = [resources UTF8String];
    chdir(resourcesDir);
    
    NSView *tfView = [[TheRun2View alloc] initWithFrame: [window frame]];
    [window setContentView: tfView];
    [window makeFirstResponder: tfView];

 */

    NSArray *args = [[NSProcessInfo processInfo] arguments];
    if (1 >= [args count])
    {
        printf("Usage: Player <dylib> arguments\n");
        exit(1);
    }
    
    // Load dylib
    
    const char *dylibFile =[[args objectAtIndex: 1] UTF8String];
    printf("Loading file: %s\n", dylibFile);
    void *dl = dlopen(dylibFile, RTLD_LAZY);
    
    if (0 == dl)
    {
        printf("Failed to load file: %s\n", dylibFile);
        exit(2);
    }
    
    // Get 'OYK_MACOSX_GetNSView' function
    
    void *getNSViewFn = dlsym(dl, "OYK_MACOSX_GetNSView");
    if (0 == getNSViewFn)
    {
        printf("Failed to find function 'OYK_MACOSX_GetNSView' in app %s", dylibFile);
        exit(3);
    }

    // Call the function to get our NSView
    
    printf("calling entry point\n");
    NSRect frame = [window frame];
    id nsViewPtr = ((void *(*)(void *))getNSViewFn)(&frame);
    printf("got %p\n", nsViewPtr);
    
    if (![nsViewPtr isKindOfClass:[NSView class]])
    {
        printf("app returned ID of wrong type: %s", [[nsViewPtr className] UTF8String]);
    }

    // Setup using that view

    NSView *view = (NSView *)nsViewPtr;
    [window setContentView: view];
    [window makeFirstResponder: view];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    NSView *view = [window contentView];
    if ([view respondsToSelector: @selector(shutdown)])
    {
        printf("app has a 'shutdown' method.  calling ...\n");
        [view performSelector: @selector(shutdown)];
        printf("back from 'shutdown'.\n");
    }
    [window setContentView: NULL];
    return NSTerminateNow;
}

@end
