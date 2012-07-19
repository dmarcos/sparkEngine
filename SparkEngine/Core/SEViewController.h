//
//  SEViewController.h
//  SparkEngine
//
//  Created by Diego Marcos on 7/18/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEView.h"

@interface SEViewController : UIViewController

- (id) initWithScene: (SEScene*) scene camera: (SECamera*) camera;
- (void) renderFrame;

@end
