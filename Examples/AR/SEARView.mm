//
//  SEARView.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/19/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEARView.h"
#import "SESphere.h"
#import "SERectangle.h"
#import "SEPerspectiveCamera.h"
#import <QCAR/QCAR.h>
#import <QCAR/Renderer.h>

@implementation SEARView

@synthesize qUtils = _qUtils;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self->_qUtils = [QCARutils getInstance];
        self->_qUtils.QCARFlags = QCAR::GL_20;

        // Camera Setup
        SECamera* camera = [[SECamera alloc] initWithFov:45.0 aspect: frame.size.width / frame.size.height near: 0.1 far:100.0];
        
        // Scene Setup
        SEScene* scene = [[SEScene alloc] init]; 
        scene.rotation = GLKVector3Make(0.0, 0.0, 0.0);
        scene.position = GLKVector3Make(0.0, 0.0, -4.0);
        
        // Objects Setup
        //SESphere* sphere = [[SESphere alloc] initWithRadius:1.0 withSteps:36];
        //sphere.material.texture = [[SETexture alloc] initWithImage:[UIImage imageNamed:@"blueMarble.jpg"]];
        //sphere.position = GLKVector3Make(0.0, 0.0, -3.0);
        //[scene addObject:sphere];
        
        SERectangle* rectangle = [[SERectangle alloc] initWithMaterial: NULL];
        rectangle.height = 10.0;
        rectangle.width = 7.5;
        rectangle.material.texture = [[SETexture alloc] initWithImage:[UIImage imageNamed:@"pierresRubis.jpg"]];;
        [scene addObject:rectangle];
        
        self.scene = scene;
        self.camera = camera;
        self.renderer.delegate = self;
    }
    return self;
}

- (void) postInitQCAR
{
    // These two calls to setHint tell QCAR to split work over multiple
    // frames.  Depending on your requirements you can opt to omit these.
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
    // Here we could also make a QCAR::setHint call to set the maximum
    // number of simultaneous targets                
    // QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
}

- (void)renderFrameQCAR
{
    [self renderFrame]; 
}

-(void) preRenderScene
{
    // Render video background and retrieve tracking state
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    self.camera.projectionMatrix = GLKMatrix4MakeWithArray(self->_qUtils.projectionMatrix.data);
    if (state.getNumActiveTrackables() == 0) {
        self.scene.rotation = GLKVector3Make(0.0, 0.0, 0.0);
    } else {
        for (int i = 0; i < state.getNumActiveTrackables(); ++i) {
            // Get the trackable
            const QCAR::Trackable* trackable = state.getActiveTrackable(i);
            QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(trackable->getPose());
            GLKMatrix4 newModelViewMatrix = GLKMatrix4MakeWithArray(modelViewMatrix.data);
            newModelViewMatrix = GLKMatrix4RotateX(newModelViewMatrix, self.scene.rotation.x);
            newModelViewMatrix = GLKMatrix4RotateY(newModelViewMatrix, self.scene.rotation.y);
            newModelViewMatrix = GLKMatrix4RotateZ(newModelViewMatrix, self.scene.rotation.z);
            newModelViewMatrix = GLKMatrix4Translate(newModelViewMatrix, self.scene.position.x, self.scene.position.y, self.scene.position.z);
            newModelViewMatrix = GLKMatrix4Scale(newModelViewMatrix, 64.0, 64.0, 64.0);
            self.scene.matrix = newModelViewMatrix;
        }
    }
}

-(void) postRenderScene
{   
    QCAR::Renderer::getInstance().end();
}


@end
