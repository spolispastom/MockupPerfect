//
//  MPMockupViewController.h
//  MockupPerfect
//
//  Created by Михаил Куренков on 17.10.15.
//  Copyright © 2015 Михаил Куренков. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MPMockupViewController : NSViewController

@property (nonatomic, setter=setOpacity:) CGFloat opacity;

@property (nonatomic, weak, setter=setDraggingDestinationDelegte:) id<NSDraggingDestination> draggingDestinationDelegte;

-(void)setImage:(NSImage *)image;

-(void)setSize:(CGSize)size;

-(BOOL)showedPlaseholder;

@end
