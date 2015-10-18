//
//  MPPlaseholderDragAndDropImageView.h
//  MockupPerfect
//
//  Created by Михаил Куренков on 17.10.15.
//  Copyright © 2015 Михаил Куренков. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MPPlaseholderDragAndDropImageView : NSImageView

@property (nonatomic, weak) id<NSDraggingDestination> delegte;

@end
