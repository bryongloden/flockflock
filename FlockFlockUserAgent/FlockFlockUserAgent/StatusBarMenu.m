//
//  StatusBarMenu.m
//  FlockFlockUserAgent
//
//  Created by Jonathan Zdziarski on 8/4/16.
//  Copyright © 2016 Jonathan Zdziarski. All rights reserved.
//

#import "StatusBarMenu.h"

@implementation StatusBarMenu
@synthesize statusBarStatus;

+ (StatusBarMenu *)sharedInstance
{
    static StatusBarMenu *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ [ StatusBarMenu alloc ] init ];
    });
    return sharedInstance;
}

- (void)setupMenuBar
{
    statusItem = [ [ NSStatusBar systemStatusBar ] statusItemWithLength: NSVariableStatusItemLength ];
    statusImage = [ [ NSImage alloc ] initWithContentsOfFile: @"/Library/Application Support/FlockFlock/lock_icon_alert.png" ];
    
    statusMenu = [ [ NSMenu alloc ] init ];
    statusMenuItem = [ statusMenu addItemWithTitle: @"FlockFlock: Initializing" action: NULL keyEquivalent: @"" ];
    statusMenuItem.target = nil;
    
    actionMenuItem = [ statusMenu addItemWithTitle: @"Disable" action: NULL keyEquivalent: @"" ];
    actionMenuItem.target = nil;
    
    [ statusItem setImage: statusImage ];
    [ statusItem setAlternateImage: statusImage];
    [ statusItem setHighlightMode: YES];
    [ statusItem setMenu: statusMenu ];
    
    statusItem.enabled = YES;
}

- (void)updateStatus: (enum FlockFlockStatusBarStatus)status
{
    actionMenuItem.target = self;
    actionMenuItem.enabled = YES;
    statusBarStatus = status;
    
    switch(status) {
        case(kFlockFlockStatusBarStatusInitializing):
            actionMenuItem.target = nil;

        case(kFlockFlockStatusBarStatusDisabled):
            actionMenuItem.target = nil;
        case(kFlockFlockStatusBarStatusInactive):
            statusImage = [ [ NSImage alloc ] initWithContentsOfFile: @"/Library/Application Support/FlockFlock/lock_icon_alert.png" ];
            [ statusImage setTemplate: NO ];
            statusMenuItem.title = @"FlockFlock: Disabled";
            actionMenuItem.action = @selector(enableAction:);
            actionMenuItem.title = @"Enable";
            break;
        case(kFlockFlockStatusBarStatusActive):
            statusImage = [ [ NSImage alloc ] initWithContentsOfFile: @"/Library/Application Support/FlockFlock/lock_icon_small.png" ];
            [ statusImage setTemplate: YES ];
            statusMenuItem.title = @"FlockFlock: Enabled";
            actionMenuItem.title = @"Disable";
            actionMenuItem.action = @selector(disableAction:);
            break;
    }
    
    [ statusItem setImage: statusImage ];
    [ statusItem setAlternateImage: statusImage];
    [ statusItem setHighlightMode:YES ];
}

- (void)disableAction:(id)sender
{
    stopFilter();
}

- (void)enableAction:(id)sender
{
    startFilter();
}

@end
