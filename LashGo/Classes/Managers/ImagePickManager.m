//
//  ImagePickManager.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ImagePickManager.h"

#import "Kernel.h"
#import "ViewControllersManager.h"

#import "LGCheck.h"

@interface ImagePickManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
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

- (BOOL) takePictureFor: (LGCheck *) check {
	if ([self startImagPickerControllerWith: UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
		_currentCheck = check;
		return YES;
	} else {
		return NO;
	}
}

- (BOOL) startImagPickerControllerWith: (UIImagePickerControllerSourceType) sourceType {
	
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

#pragma mark - UIImagePickerControllerDelegate implementation

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
	
    [_viewControllersManager.rootNavigationController dismissViewControllerAnimated: YES completion: nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
	
	_currentCheck.currentPickedUserPhoto = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
	
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
