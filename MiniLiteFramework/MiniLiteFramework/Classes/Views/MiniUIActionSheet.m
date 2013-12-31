//
//  MiniUIActionSheet.m
//  LS
//
//  Created by wu quancheng on 12-6-24.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUIActionSheet.h"
@interface MiniUIActionSheet()<UIActionSheetDelegate>
{
    void (^callback)(MiniUIActionSheet *ach,NSInteger buttonIndex);
}
@end

@implementation MiniUIActionSheet

- (id)init
{
    self = [super init];
    if ( self )
    {
    }
    return self;
}

- (void)setBlock:(void (^)(MiniUIActionSheet *ach, NSInteger buttonIndex))block
{
    self.delegate = self;
    if ( callback )
    {
        Block_release(callback);
        callback = nil;
    }
    if ( block )
    {
        callback = Block_copy( block );
    }
}


- (void)actionSheet:(MiniUIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( callback )
    {
        callback(actionSheet,buttonIndex);
    }
}

@end
