//
//  SERenderer.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/17/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SETexture.h"

@class CAEAGLLayer;
@class SEScene;
@class SEPerspectiveCamera;

@interface SERenderer : NSObject

- (id) initWithViewport: (CGRect) viewport withGLContext: (EAGLContext*) glContext withEAGLLayer: (CAEAGLLayer*) eaglLayer;
- (void) renderScene: (SEScene*) scene camera: (SEPerspectiveCamera*) camera;
- (void) setTexture: (SETexture*) texture;

@property (nonatomic, readonly) CGRect viewport;
@property (weak, nonatomic, readonly) EAGLContext* glContext;

@end
