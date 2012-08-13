//
//  SECameraVisualization.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 8/7/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SECameraVisualization.h"
#import "SECamera.h"
#import "SEShader.h"

@interface SECameraVisualization(){
    SECamera* _camera;
}
-(void) updateFrustum;
@end

@implementation SECameraVisualization

-(id) initWithCamera:(SECamera*)camera
{
    self = [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:9 vertices:nil numFaces:0 facesIndices:nil numLines:10 linesIndices:nil] material:nil];
    if (self) {
        
        self->_camera = camera;
        
        self.material = [[SEShaderMaterial alloc] init];
        self.material.shader = [[SEShader alloc] initWithVertexShaderFileName:@"default.vsh" fragmentShaderFileName:@"plainColor.fsh"];
        self.material.color = GLKVector4Make(1.0, 0.0, 0.0, 1.0);
        self.material.renderStyle = WireFrame;

        [self updateFrustum];
     
    }    
    return self;
}

-(GLKMatrix4) matrix
{
    [self updateFrustum];
    return GLKMatrix4Invert(self->_camera.matrix, nil);
}

-(void) updateFrustum
{
    SECamera* camera = self->_camera;
    // Adds a small margin so I avoid accidental clippings due to float multiplication precission.
    float near = camera.near + camera.near*0.005;
    
    // Eye
    self.geometry.vertices[0].position = self->_camera.position;
    
    // Near plane
    self.geometry.vertices[1].position = GLKVector3Make(camera.left, camera.top, -near);
    self.geometry.vertices[2].position = GLKVector3Make(camera.left, camera.bottom, -near);
    self.geometry.vertices[3].position = GLKVector3Make(camera.right, camera.top, -near);
    self.geometry.vertices[4].position = GLKVector3Make(camera.right, camera.bottom, -near);
        
    // Line of view cross on near plane
    self.geometry.vertices[5].position = GLKVector3Make(camera.left, 0, -near);
    self.geometry.vertices[5].color = GLKVector4Make(1.0, 1.0, 1.0, 0.5);
    self.geometry.vertices[6].position = GLKVector3Make(camera.right, 0, -near);
    self.geometry.vertices[6].color =  GLKVector4Make(1.0, 1.0, 1.0, 0.5);
    self.geometry.vertices[7].position = GLKVector3Make(0, camera.top, -near);
    self.geometry.vertices[7].color =  GLKVector4Make(1.0, 1.0, 1.0, 0.5);
    self.geometry.vertices[8].position = GLKVector3Make(0, camera.bottom, -near);
    self.geometry.vertices[8].color =  GLKVector4Make(1.0, 1.0, 1.0, 0.5);
    
    // Camera pose pyramid
    self.geometry.linesIndices[0].a = 0;
    self.geometry.linesIndices[0].b = 1;
    self.geometry.linesIndices[1].a = 0;
    self.geometry.linesIndices[1].b = 2;
    self.geometry.linesIndices[2].a = 0;
    self.geometry.linesIndices[2].b = 3;
    self.geometry.linesIndices[3].a = 0;
    self.geometry.linesIndices[3].b = 4;
    
    // Near plane
    self.geometry.linesIndices[4].a = 1;
    self.geometry.linesIndices[4].b = 2;
    self.geometry.linesIndices[5].a = 1;
    self.geometry.linesIndices[5].b = 3;
    self.geometry.linesIndices[6].a = 2;
    self.geometry.linesIndices[6].b = 4;
    self.geometry.linesIndices[7].a = 3;
    self.geometry.linesIndices[7].b = 4;
    
    // Line of view cross on near plane
    self.geometry.linesIndices[8].a = 5;
    self.geometry.linesIndices[8].b = 6;
    self.geometry.linesIndices[9].a = 7;
    self.geometry.linesIndices[9].b = 8;
    
    // Far Plane
    
    self.vertexBufferNeedsUpdate = YES;
}

@end
