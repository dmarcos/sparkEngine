/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <UIKit/UIKit.h>
@class EAGLView, QCARutils, SEARView;

@interface ARViewController : UIViewController {
@public
    IBOutlet SEARView *arView;  // the Augmented Reality view
    CGSize arViewSize;          // required view size

@private
    QCARutils *qUtils;          // QCAR utils singleton class
    UIView *parentView;         // Avoids unwanted interactions between UIViewController and EAGLView
    NSMutableArray* textures;   // Teapot textures
    BOOL arVisible;             // State of visibility of the view
}

@property (nonatomic, retain) IBOutlet SEARView* arView;
@property (nonatomic) CGSize arViewSize;
           
- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation;

@end
