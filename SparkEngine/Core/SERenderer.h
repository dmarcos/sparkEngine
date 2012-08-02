//
//  SERenderer.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/17/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SETexture.h"
#import "SERendererDelegate.h"

@class CAEAGLLayer;
@class SEScene;
@class SECamera;

@interface SERenderer : NSObject

- (id) initWithGLContext: (EAGLContext*) glContext withEAGLLayer: (CAEAGLLayer*) eaglLayer;
-(void) renderScene:(SEScene*)scene camera:(SECamera*)camera viewport:(CGRect) viewport;

@property (weak, nonatomic, readonly) EAGLContext* glContext;
@property (nonatomic, assign) id<SERendererDelegate> delegate;
@property (nonatomic) CGRect viewport;

@end
