//
//  MPMockupViewController.m
//  MockupPerfect
//
//  Created by Михаил Куренков on 17.10.15.
//  Copyright © 2015 Михаил Куренков. All rights reserved.
//

#import "MPMockupViewController.h"
#import "MPPlaseholderDragAndDropImageView.h"

@interface MPMockupViewController ()

@property (weak) IBOutlet MPPlaseholderDragAndDropImageView *muckupImageWell;

@property (weak) IBOutlet MPPlaseholderDragAndDropImageView *plaseholderImageView;

@property (weak) IBOutlet NSLayoutConstraint *plaseholderWidthConstraint;
@property (weak) IBOutlet NSLayoutConstraint *plaseholderHeightConstraint;

@end

@implementation MPMockupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_muckupImageWell setImageScaling:NSImageScaleAxesIndependently];
    [_muckupImageWell setImageFrameStyle:NSImageFrameGroove];
    [_muckupImageWell setAlphaValue:0.0];
}

-(id<NSDraggingDestination>)draggingDestinationDelegte{
    if (_plaseholderImageView.hidden){
        return _muckupImageWell.delegte;
    } else {
        return _plaseholderImageView.delegte;
    }
}

-(void)setDraggingDestinationDelegte:(id<NSDraggingDestination>)draggingDestinationDelegte{
    _plaseholderImageView.delegte = draggingDestinationDelegte;
    _muckupImageWell.delegte = draggingDestinationDelegte;
}

-(void)setImage:(NSImage *)image{
    if (image != nil){
        _muckupImageWell.alphaValue = 1 - _opacity;
        _muckupImageWell.image = image;
        _plaseholderImageView.hidden = YES;
    }
}

-(void)setOpacity:(CGFloat)opasity{
    _opacity = opasity;
    if (_plaseholderImageView.hidden){
        _muckupImageWell.alphaValue = 1 - opasity;
    }
}

-(void)setSize:(CGSize)size{
    self.view.frame = CGRectMake(CGRectGetMinX(self.view.frame),
                                 CGRectGetMinY(self.view.frame),
                                 size.width,
                                 size.height);
    if (!_plaseholderImageView.hidden){
        _plaseholderWidthConstraint.constant = size.width;
        _plaseholderHeightConstraint.constant = size.height;
        [self.view needsLayout];
    }
}

-(BOOL)showedPlaseholder{
    return  !_plaseholderImageView.hidden;
}

@end
