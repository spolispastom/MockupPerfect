//
//  MPMockupWindow.m
//  MockupPerfect
//
//  Created by Михаил Куренков on 17.10.15.
//  Copyright © 2015 Михаил Куренков. All rights reserved.
//

#import "MPMockupWindow.h"
#import "MPMockupWindow.h"
#import "MPMockupViewController.h"

typedef  NS_ENUM(NSUInteger, MPOrientation) {
    MPOrientation_portal,
    MPOrientation_landscape
};

@interface MPMockupWindow () <NSDraggingDestination>

@property (nonatomic) BOOL resignMainNotificationObserve;
@property (nonatomic) MPOrientation orientation;

@end

@implementation MPMockupWindow

-(void)awakeFromNib{
    [super awakeFromNib];
    self.acceptsMouseMovedEvents = YES;
    
    [self setLevel:NSFloatingWindowLevel];
    [self makeKeyAndOrderFront:NSApp];
    
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    
    _orientation = MPOrientation_portal;
    
    [(MPMockupViewController *)self.contentViewController setDraggingDestinationDelegte:self];
    
    if (!_resignMainNotificationObserve){
        _resignMainNotificationObserve = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resignMainNotification:)
                                                     name:NSWindowDidResignMainNotification
                                                   object:nil];
    }
}

-(void)dealloc{
    if (_resignMainNotificationObserve){
        _resignMainNotificationObserve = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSWindowDidResignMainNotification
                                                      object:nil];
    }
}

- (void)resignMainNotification:(NSNotification*)aNotification
{
    self.ignoresMouseEvents = NO;
}

- (void)keyDown:(NSEvent *)theEvent {
    
    if ([theEvent modifierFlags] & NSNumericPadKeyMask) {
        NSString *theArrow = [theEvent charactersIgnoringModifiers];
        unichar keyChar = 0;
        CGFloat X = CGRectGetMinX(self.frame);
        CGFloat Y = CGRectGetMinY(self.frame);
        if ( [theArrow length] == 1 ) {
            keyChar = [theArrow characterAtIndex:0];
            if ( keyChar == NSLeftArrowFunctionKey ) {
                X--;
            }
            else if ( keyChar == NSRightArrowFunctionKey ) {
                X++;
            }
            else if ( keyChar == NSUpArrowFunctionKey ) {
                Y++;
            }
            else if ( keyChar == NSDownArrowFunctionKey ) {
                Y--;
            } else {
                [super keyDown:theEvent];
            }
            [self setFrame:CGRectMake(X, Y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) display:YES];
        }
    }
}

-(void)mouseMoved:(NSEvent *)theEvent{
    NSPoint mousePoint = [self mouseLocationOutsideOfEventStream];
    
    CGFloat X = mousePoint.x;
    CGFloat Y = mousePoint.y;
    
    BOOL result = X > 0 && X < CGRectGetWidth(self.frame) &&
    Y > 0 && Y < CGRectGetHeight(self.frame) - 20;
    
    self.ignoresMouseEvents = result;// && ![(MPMockupViewController *)self.contentViewController showedPlaseholder];
}

-(void)setImage:(NSImage *)image{
    _image = image;
    [(MPMockupViewController *)self.contentViewController setImage:image];
    [self updateSelfSize];
}

-(void)setSizeType:(MPSizeType)sizeType{
    _sizeTipe = sizeType;
    [self updateSelfSize];
}

-(void)setOpacity:(CGFloat)opasity{
    [(MPMockupViewController *)self.contentViewController setOpacity:opasity];
    [self setBackgroundColor:[NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:(1.0 - opasity)]];
}

-(void)setScale:(CGFloat)scale{
    _scale = scale;
    [self updateSelfSize];
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
    
    if (1 == filenames.count){
        NSString* file = [filenames firstObject];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:file];
        if (image != nil){
            [self setImage:image];
            return YES;
        }
    }
    return NO;
}

-(void)updateSelfSize{
    CGFloat width = 0;
    CGFloat height = 0;
    switch (_sizeTipe) {
        case MPSize_iPhone4:
            width = 640.0;
            height = 960.0;
            break;
        case MPSize_iPhone5:
            width = 640.0;
            height = 1136.0;
            break;
        case MPSize_iPhone6:
            width = 750.0;
            height = 1334.0;
            break;
        case MPSize_iPhone6plus:
            width = 1242.0 / 2;
            height = 2208.0 / 2;
            break;
        case MPSize_iPad:
            width = 768.0;
            height = 1024.0;
            break;
        case MPSize_originnSize:
        default:
            if (_image.size.width > 0 && _image.size.height > 0){
                width  = _image.size.width;
                height = _image.size.height;
            } else {
                width = 320.0;
                height = 480.0;
            }
            break;
    }
    width *= _scale;
    height *= _scale;
    
    CGSize aSize = _orientation == MPOrientation_portal ? CGSizeMake(width, height) : CGSizeMake(height, width);
    [super setContentSize:aSize];
    [(MPMockupViewController *)self.contentViewController setSize:aSize];
}


-(void)rotationLeft{
    if (_orientation == MPOrientation_portal){
        _orientation = MPOrientation_landscape;
    } else if (_orientation == MPOrientation_landscape){
        _orientation = MPOrientation_portal;
    }
    [self rotationAngle:-90.0];
}

-(void)rotationRight{
    if (_orientation == MPOrientation_portal){
        _orientation = MPOrientation_landscape;
    } else if (_orientation == MPOrientation_landscape){
        _orientation = MPOrientation_portal;
    }
    [self rotationAngle:90.0];
}

-(void)rotationAngle:(CGFloat)angle{
    NSSize originalSize = [_image size];
    NSSize rotatedSize;
    if (angle == 180.0){
        rotatedSize = NSMakeSize(originalSize.width, originalSize.height);
    } else {
        rotatedSize = NSMakeSize(originalSize.height, originalSize.width);
    }
    NSImage *rotatedImage = [[NSImage alloc] initWithSize: rotatedSize];
    
    [rotatedImage lockFocus];
    
    NSAffineTransform* transform = [NSAffineTransform transform];
    NSPoint centerPoint = NSMakePoint(rotatedSize.width / 2,
                                      rotatedSize.height / 2);
    [transform translateXBy: centerPoint.x yBy: centerPoint.y];
    [transform rotateByDegrees: angle];
    [transform translateXBy: -centerPoint.y yBy: -centerPoint.x];
    [transform concat];
    
    NSRect rect = NSMakeRect(0, 0, originalSize.width, originalSize.height);
    [_image drawInRect: rect];
    
    [rotatedImage unlockFocus];
    
    [self setImage:rotatedImage];
}

@end
