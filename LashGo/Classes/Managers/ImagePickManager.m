//
//  ImagePickManager.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ImagePickManager.h"

#import "Common.h"
#import "Kernel.h"
#import "ViewControllersManager.h"

#import "LGCheck.h"

@interface ImagePickManager () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	Kernel __weak *_kernel;
	ViewControllersManager __weak *_viewControllersManager;
	
	LGCheck __weak *_currentCheck;
}

@end

@implementation ImagePickManager

- (instancetype) initWithKernel: (Kernel *) kernel
					  vcManager: (ViewControllersManager *) vcManager {
	if (self = [super init]) {
		_kernel = kernel;
		_viewControllersManager = vcManager;
	}
	return self;
}

#pragma mark - Methods 

- (void) takePictureFor: (LGCheck *) check {
	_currentCheck = check;
	
	if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
		UIActionSheet *activeSheet = [[UIActionSheet alloc] initWithTitle: nil
																 delegate: self
														cancelButtonTitle: @"ImagePickerActionSheetCancelTitle".commonLocalizedString
												   destructiveButtonTitle: nil
														otherButtonTitles:
									  @"ImagePickerActionSheetCameraTitle".commonLocalizedString,
									  @"ImagePickerActionSheetLibraryTitle".commonLocalizedString, nil];
		[activeSheet showInView: _viewControllersManager.rootNavigationController.topViewController.view];
	} else {
		[self startImagePickerControllerWith: UIImagePickerControllerSourceTypePhotoLibrary];
	}
}

- (BOOL) startImagePickerControllerWith: (UIImagePickerControllerSourceType) sourceType {
	
    if ([UIImagePickerController isSourceTypeAvailable: sourceType] == NO) {
        return NO;
	}
	
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = sourceType;
	
	//We need only images
//    // Displays a control that allows the user to choose picture or
//    // movie capture, if both are available:
//    cameraUI.mediaTypes =
//	[UIImagePickerController availableMediaTypesForSourceType:
//	 UIImagePickerControllerSourceTypeCamera];
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
	
    cameraUI.delegate = self;
	
    [_viewControllersManager.rootNavigationController presentViewController: cameraUI animated: YES completion: nil];
    return YES;
}

#pragma mark - UIActionSheetDelegate implementation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self startImagePickerControllerWith: UIImagePickerControllerSourceTypeCamera];
			break;
		default:
			[self startImagePickerControllerWith: UIImagePickerControllerSourceTypePhotoLibrary];
			break;
	}
}

#pragma mark - UIImagePickerControllerDelegate implementation

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
	
    [_viewControllersManager.rootNavigationController dismissViewControllerAnimated: YES completion: nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage *imageToSave = [info objectForKey: UIImagePickerControllerOriginalImage];

    // Handle a still image capture
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
		// Save the new image to the Camera Roll
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil , nil);
    }
	
	// Fixing to stick with only one orientation (UIImageOrientationUp in this case)
	switch (imageToSave.imageOrientation) {
		case UIImageOrientationDown:
		case UIImageOrientationDownMirrored:
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			imageToSave = [UIImage imageWithCGImage:imageToSave.CGImage
										scale:imageToSave.scale
								  orientation:UIImageOrientationUp]; // change this if you need another orientation
			break;
		case UIImageOrientationUp:
		case UIImageOrientationUpMirrored:
			// The image is already in correct orientation
			break;
	}
	
	_currentCheck.currentPickedUserPhoto = imageToSave;
	
	//Sample
//    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//    UIImage *originalImage, *editedImage, *imageToSave;
//
//    // Handle a still image capture
//    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
//		== kCFCompareEqualTo) {
//		
//        editedImage = (UIImage *) [info objectForKey:
//								   UIImagePickerControllerEditedImage];
//        originalImage = (UIImage *) [info objectForKey:
//									 UIImagePickerControllerOriginalImage];
//		
//        if (editedImage) {
//            imageToSave = editedImage;
//        } else {
//            imageToSave = originalImage;
//        }
//		
//		// Save the new image (original or edited) to the Camera Roll
//        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
//    }
//	
//    // Handle a movie capture
//    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
//		== kCFCompareEqualTo) {
//		
//        NSString *moviePath = [[info objectForKey:
//								UIImagePickerControllerMediaURL] path];
//		
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
//            UISaveVideoAtPathToSavedPhotosAlbum (
//												 moviePath, nil, nil, nil);
//        }
//    }
	
    [_viewControllersManager.rootNavigationController dismissViewControllerAnimated: YES completion: nil];
}

@end
