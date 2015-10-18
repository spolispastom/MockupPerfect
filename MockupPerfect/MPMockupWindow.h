//
//  MPMockupWindow.h
//  MockupPerfect
//
//  Created by Михаил Куренков on 17.10.15.
//  Copyright © 2015 Михаил Куренков. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, MPSizeType) {
    MPSize_iPhone4,
    MPSize_iPhone5,
    MPSize_iPhone6,
    MPSize_iPhone6plus,
    MPSize_iPad,
    MPSize_originnSize,
    MPSize_custonSize
};

@interface MPMockupWindow : NSWindow

@property (nonatomic, strong, setter=setImage:) NSImage *image;
@property (nonatomic, setter=setOpacity:) CGFloat opacity;
@property (nonatomic, setter=setScale:) CGFloat scale;

@property (nonatomic, setter=setSizeType:) MPSizeType sizeTipe;

-(void)setSizeType:(MPSizeType)sizeType;

-(void)rotationLeft;
-(void)rotationRight;

@end
