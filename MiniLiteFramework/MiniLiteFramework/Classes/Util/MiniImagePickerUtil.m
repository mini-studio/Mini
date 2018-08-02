//
//  MiniImagePickerUtil.m
//  LS
//
//  Created by wu quancheng on 12-6-24.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniImagePickerUtil.h"
#import "MiniUIActionSheet.h"

@interface MiniImagePickerUtil()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    void(^callback)(UIImage *image);
}
@end

@implementation MiniImagePickerUtil
SYNTHESIZE_MINI_SINGLETON_FOR_CLASS(MiniImagePickerUtil)

- (void)pickerImage:(UIViewController *)controller  title:(NSString*)title block:(void(^)(UIImage *image))block
{
    if ( callback )
    {
        Block_release(callback);
        callback = nil;
    }
    if ( block )
    {
         callback = Block_copy(block);
    }   
    MiniUIActionSheet *act = [[MiniUIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择照片", nil];
    [act setBlock:^(MiniUIActionSheet *actionSheet ,NSInteger buttonIndex) {
        if ( buttonIndex == 0 ) //从相机
        {
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                [controller presentModalViewController:picker animated:YES];
                picker.delegate = self;
                [picker release];  
            }
        }
        else if ( buttonIndex == 1 )//从相册
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            [controller presentModalViewController:picker animated:YES];
            picker.delegate = self;
            [picker release];        
        }
    }];
    [act showInView:controller.view];
    [act release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage *)[info valueForKey:self.useEditImage?UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:YES];
    if ( callback )
    {
        callback(image);
        Block_release(callback);
        callback = nil;
    }
}


- (void)pickerImageFromCamera:(UIViewController *)controller block:(void(^)(UIImage *image))block
{
    if ( callback )
    {
        Block_release(callback);
        callback = nil;
    }
    if ( block )
    {
        callback = Block_copy(block);
    }   
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.editing = YES;
        [controller presentModalViewController:picker animated:YES];
        picker.delegate = self;
        [picker release];  
    }        
}

- (void)pickerImageFromLib:(UIViewController *)controller block:(void(^)(UIImage *image))block
{
    if ( callback )
    {
        Block_release(callback);
        callback = nil;
    }
    if ( block )
    {
        callback = Block_copy(block);
    }   
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.editing = YES;
    [controller presentModalViewController:picker animated:YES];
    picker.delegate = self;
    [picker release];        
}
@end
