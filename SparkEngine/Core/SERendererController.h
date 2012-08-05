//
//  SERendererController.h
//  SparkEngine
//
//  Created by Diego Marcos Segura on 8/1/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKView.h>
#import "SERenderer.h"

#import "SECamera.h"
#import "SEScene.h"

@interface SERendererController : NSObject<GLKViewDelegate>

-(void) glkView:(GLKView*)view drawInRect:(CGRect)rect;

@property (nonatomic, strong) SECamera* camera;
@property (nonatomic, strong) SEScene* scene;

@end
