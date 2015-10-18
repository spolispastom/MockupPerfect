//
//  AppDelegate.m
//  MockupPerfect
//
//  Created by Михаил Куренков on 17.10.15.
//  Copyright © 2015 Михаил Куренков. All rights reserved.
//

#import "AppDelegate.h"
#import "MPMockupWindow.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSMenuItem *iPhone4MenuItem;
@property (weak) IBOutlet NSMenuItem *iPhone5MenuItem;
@property (weak) IBOutlet NSMenuItem *iPhone6MenuItem;
@property (weak) IBOutlet NSMenuItem *iPhone6pluseMenuItem;

@property (weak) IBOutlet NSMenuItem *iPadMenuItem;

@property (weak) IBOutlet NSMenuItem *originnSizeMenuItem;

@property (weak) IBOutlet NSMenuItem *rotationRightlMenuItem;
@property (weak) IBOutlet NSMenuItem *rotationLeftMenuItem;

@property (weak) IBOutlet NSMenu *opacityMenu;
@property (weak) IBOutlet NSMenu *scaleMenu;

@property (nonatomic, weak) MPMockupWindow *mainWindow;

@property (nonatomic, strong) NSImage *muckup;

@property (nonatomic, strong) NSOpenPanel *openPanel;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSWindow *mainWindow = [[[NSApplication sharedApplication] windows] firstObject];
    if ([mainWindow isKindOfClass:[MPMockupWindow class]]){
        _mainWindow = (MPMockupWindow *)mainWindow;
    }
    [_mainWindow setOpaque:NO];
    [_mainWindow setBackgroundColor:[NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
    
    _iPhone4MenuItem.enabled = YES;
    _iPhone5MenuItem.enabled = YES;
    _iPhone6MenuItem.enabled = YES;
    _iPhone6pluseMenuItem.enabled = YES;
    _iPadMenuItem.enabled = YES;
    
    _originnSizeMenuItem.enabled = YES;
    
    _rotationLeftMenuItem.enabled = YES;
    _rotationRightlMenuItem.enabled = YES;
    
    [_mainWindow setOpacity:0.5];
    [_mainWindow setScale:1.0];
    [_mainWindow setSizeType:MPSize_iPhone5];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)openMukupMenuItemDidClick:(id)sender {
    if (_openPanel == nil){
        _openPanel = [NSOpenPanel openPanel];
        [_openPanel setCanChooseFiles:YES];
        [_openPanel setAllowsMultipleSelection:NO];
        [_openPanel setCanChooseDirectories:NO];
    }
    if ( [_openPanel runModal] == NSModalResponseOK)
    {
        NSURL* file = [_openPanel URL];
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:file];
        if (image != nil){
            _muckup = image;
            [_mainWindow setImage:_muckup];
        }
    }
}

- (IBAction)deviceSelected:(id)sender {
    if (sender == _iPhone4MenuItem){
        _iPhone4MenuItem.state = NSOnState;
        _iPhone5MenuItem.state = NSOffState;
        _iPhone6MenuItem.state = NSOffState;
        _iPhone6pluseMenuItem.state = NSOffState;
        _iPadMenuItem.state = NSOffState;
        _originnSizeMenuItem.state = NSOffState;
        [_mainWindow setSizeType: MPSize_iPhone4];
    } else if (sender == _iPhone5MenuItem){
        _iPhone4MenuItem.state = NSOffState;
        _iPhone5MenuItem.state = NSOnState;
        _iPhone6MenuItem.state = NSOffState;
        _iPhone6pluseMenuItem.state = NSOffState;
        _iPadMenuItem.state = NSOffState;
        _originnSizeMenuItem.state = NSOffState;
        [_mainWindow setSizeType: MPSize_iPhone5];
    } else if (sender == _iPhone6MenuItem){
        _iPhone4MenuItem.state = NSOffState;
        _iPhone5MenuItem.state = NSOffState;
        _iPhone6MenuItem.state = NSOnState;
        _iPhone6pluseMenuItem.state = NSOffState;
        _iPadMenuItem.state = NSOffState;
        _originnSizeMenuItem.state = NSOffState;
        [_mainWindow setSizeType:MPSize_iPhone6];
    } else if (sender == _iPhone6pluseMenuItem){
        _iPhone4MenuItem.state = NSOffState;
        _iPhone5MenuItem.state = NSOffState;
        _iPhone6MenuItem.state = NSOffState;
        _iPhone6pluseMenuItem.state = NSOnState;
        _iPadMenuItem.state = NSOffState;
        _originnSizeMenuItem.state = NSOffState;
        [_mainWindow setSizeType:MPSize_iPhone6plus];
    } else if (sender == _iPadMenuItem){
        _iPhone4MenuItem.state = NSOffState;
        _iPhone5MenuItem.state = NSOffState;
        _iPhone6MenuItem.state = NSOffState;
        _iPhone6pluseMenuItem.state = NSOffState;
        _iPadMenuItem.state = NSOnState;
        _originnSizeMenuItem.state = NSOffState;
        [_mainWindow setSizeType:MPSize_iPad];
    } else if (sender == _originnSizeMenuItem){
        _iPhone4MenuItem.state = NSOffState;
        _iPhone5MenuItem.state = NSOffState;
        _iPhone6MenuItem.state = NSOffState;
        _iPhone6pluseMenuItem.state = NSOffState;
        _iPadMenuItem.state = NSOffState;
        _originnSizeMenuItem.state = NSOnState;
        [_mainWindow setSizeType:MPSize_originnSize];
    }
}

- (IBAction)scaleSelected:(id)sender {
    if (sender != nil && [sender isKindOfClass:[NSMenuItem class]]){
        NSMenuItem *currentItem = (NSMenuItem *)sender;
        NSString *title = currentItem.title;
        NSString *scaleStrimg = [title substringWithRange:NSMakeRange(0, title.length - 1)];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *scaleInt = [formatter numberFromString:scaleStrimg];
        
        [_mainWindow setScale:[scaleInt integerValue] / 50.0];
        
        for (NSMenuItem *item in _scaleMenu.itemArray) {
            item.state = item == currentItem ? NSOnState : NSOffState;
        }
    }
}

- (IBAction)orientationDidChange:(id)sender {
    if (sender == _rotationLeftMenuItem){
        [_mainWindow rotationLeft];
    } else if (sender == _rotationRightlMenuItem){
        [_mainWindow rotationRight];
    }
}

- (IBAction)opacityDidChange:(id)sender {
    if (sender != nil && [sender isKindOfClass:[NSMenuItem class]]){
        NSMenuItem *currentItem = (NSMenuItem *)sender;
        NSString *title = currentItem.title;
        NSString *opasityStrimg = [title substringWithRange:NSMakeRange(0, title.length - 1)];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *opasityInt = [formatter numberFromString:opasityStrimg];
        
        [_mainWindow setOpacity:1 - [opasityInt integerValue] / 100.0];
        
        for (NSMenuItem *item in _opacityMenu.itemArray) {
            item.state = item == currentItem ? NSOnState : NSOffState;
        }
    }
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}

@end
