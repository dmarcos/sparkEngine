//
//  SERectangle.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/20/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SERectangle.h"

@interface SERectangle()

-(void) calculateVertices;

@end

@implementation SERectangle

@synthesize height = _height;
@synthesize width = _width;

-(id) initWithMaterial:(SEShaderMaterial*)material
{
    self = [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:4 vertices: nil numFaces:2 facesIndices: nil numLines: 6 linesIndices: nil] material: material];
    if (self) {
        
        self->_height = 1.0;
        self->_width = 1.0;
        
        [self calculateVertices];
        
        self.geometry.facesIndices[0].a = 0;
        self.geometry.facesIndices[0].b = 1;
        self.geometry.facesIndices[0].c = 2;
        
        self.geometry.linesIndices[0].a = 0;
        self.geometry.linesIndices[0].b = 1;
        self.geometry.linesIndices[1].a = 0;
        self.geometry.linesIndices[1].b = 2;
        self.geometry.linesIndices[2].a = 1;
        self.geometry.linesIndices[2].b = 2;
        
        self.geometry.facesIndices[1].a = 2;
        self.geometry.facesIndices[1].b = 1;
        self.geometry.facesIndices[1].c = 3;
        
        self.geometry.linesIndices[3].a = 2;
        self.geometry.linesIndices[3].b = 1;
        self.geometry.linesIndices[4].a = 2;
        self.geometry.linesIndices[4].b = 3;
        self.geometry.linesIndices[5].a = 1;
        self.geometry.linesIndices[5].b = 3;
        
    }
    
    return self;
}

-(void) calculateVertices
{
    float lowerRightCornerX =  self->_width / 2.0;
    float lowerRightCornerY = -self->_height / 2.0;
    float upperRightCornerX = lowerRightCornerX;
    float upperRightCornerY = self->_height / 2.0;
    float upperLeftCornerX = -self->_width / 2.0;
    float upperLeftCornerY = upperRightCornerY;
    float lowerLeftCornerX = upperLeftCornerX;
    float lowerLeftCornerY = lowerRightCornerY;
    
    self.geometry.vertices[0].position = GLKVector3Make(lowerLeftCornerX, lowerLeftCornerY, 1.0);
    self.geometry.vertices[0].texture = GLKVector2Make(0.0, 0.0);
    self.geometry.vertices[0].normal = GLKVector3Make(0.0, 1.0, 0.0);

    self.geometry.vertices[1].position = GLKVector3Make(upperLeftCornerX, upperLeftCornerY, 1.0);
    self.geometry.vertices[1].texture = GLKVector2Make(0.0 , 1.0);
    self.geometry.vertices[1].normal = GLKVector3Make(0.0, 1.0, 0.0);

    self.geometry.vertices[2].position = GLKVector3Make(lowerRightCornerX, lowerRightCornerY, 1.0);
    self.geometry.vertices[2].texture = GLKVector2Make(1.0, 0.0);
    self.geometry.vertices[2].normal = GLKVector3Make(0.0, 1.0, 0.0);

    self.geometry.vertices[3].position = GLKVector3Make(upperRightCornerX, upperRightCornerY, 1.0);
    self.geometry.vertices[3].texture = GLKVector2Make(1.0, 1.0);
    self.geometry.vertices[3].normal = GLKVector3Make(0.0, 1.0, 0.0);
}

-(void) setHeight:(float)height
{
    self->_height = height;
    [self calculateVertices];
}

-(void) setWidth:(float)width
{
    self->_width = width;
    [self calculateVertices];
}

@end