//
//  SESphereMesh.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/17/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SESphere.h"
#import "SEShader.h"

@implementation SESphere

@synthesize radius = _radius;
@synthesize steps = _steps;

-(id) initWithRadius:(float)radius withSteps: (int)steps
{
    int numVertices = (steps+1)*(steps+1);
    int numFaces = steps*steps*2;
    
    self = [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:numVertices numberOfFaces: numFaces] material:NULL];
    if (self) {
    
        self->_radius = radius;
        self->_steps = steps;
            
        for (int latNumber = 0; latNumber <= steps; latNumber++) {
            double theta = (double) latNumber * M_PI / steps;
            double sinTheta = sin(theta);
            double cosTheta = cos(theta);
            for (int longNumber = 0; longNumber <= steps; longNumber++) {
                double phi = (double) longNumber * 2.0 * M_PI / steps;
                double sinPhi = sin(phi);
                double cosPhi = cos(phi);
                
                double x = cosPhi * sinTheta;
                double y = cosTheta;
                double z = sinPhi * sinTheta;
                
                double u = 1 - (double) longNumber / steps;
                double v = (double) latNumber / steps;
                
                self.geometry.vertices[latNumber*(steps+1) + longNumber].position = GLKVector3Make(radius*x, radius*y, radius*z);
                self.geometry.vertices[latNumber*(steps+1) + longNumber].normal = GLKVector3Make(x,y,z);
                self.geometry.vertices[latNumber*(steps+1) + longNumber].texture = GLKVector2Make(u,v);
                self.geometry.vertices[latNumber*(steps+1) + longNumber].color = GLKVector4Make(0.5, 1.0, 0.0, 0.0);
            }
        }
        
        for (int latNumber = 0; latNumber < steps; latNumber++) {
            for (int longNumber = 0; longNumber < steps; longNumber++) {
                int first = (latNumber * (steps + 1)) + longNumber;
                int second = first + steps + 1;

                self.geometry.facesIndices[latNumber*steps*2 + longNumber*2].a = first;
                self.geometry.facesIndices[latNumber*steps*2 + longNumber*2].b = second;
                self.geometry.facesIndices[latNumber*steps*2 + longNumber*2].c = first+1;
                
                self.geometry.facesIndices[latNumber*steps*2 + longNumber*2 + 1].a = second;
                self.geometry.facesIndices[latNumber*steps*2 + longNumber*2 + 1].b = second+1;
                self.geometry.facesIndices[latNumber*steps*2 + longNumber*2 + 1].c = first+1;
            }
        }
        
    }
    return self;
}

@end