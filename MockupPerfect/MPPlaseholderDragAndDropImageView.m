//
//  MPPlaseholderDragAndDropImageView.m
//  MockupPerfect
//
//  Created by Михаил Куренков on 17.10.15.
//  Copyright © 2015 Михаил Куренков. All rights reserved.
//

#import "MPPlaseholderDragAndDropImageView.h"

@interface MPPlaseholderDragAndDropImageView () <NSDraggingDestination>

@end

@implementation MPPlaseholderDragAndDropImageView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
    if(_delegte != nil){
        return [_delegte draggingEntered:sender];
    }
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    if(_delegte != nil){
        return [_delegte draggingUpdated:sender];
    }
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    if(_delegte != nil){
        return [_delegte performDragOperation:sender];
    }
    return NO;
}

@end
