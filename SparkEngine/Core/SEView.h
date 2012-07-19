//
//  SEView.h
//  SparkEngine
//
//  Created by Diego Marcos on 7/18/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SECamera.h"
#import "SERenderer.h"
#import "SEScene.h"

@interface SEView : UIView

-(void) renderFrame;

@property (nonatomic, strong) SECamera* camera;
@property (nonatomic, strong) SEScene* scene;

@end
