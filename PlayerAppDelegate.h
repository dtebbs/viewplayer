//
//  PlayerAppDelegate.h
//  Player
//
//  Created by Duncan Tebbs on 5/14/11.
//  Copyright 2011 Duncan Tebbs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
