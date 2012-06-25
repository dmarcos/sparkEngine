//
//  SESphereMesh.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/17/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SESphere.h"

@implementation SESphere

@synthesize radius = _radius;
@synthesize steps = _steps;

-(id) initWithRadius:(float)radius withSteps: (int)steps
{
    self->_radius = radius;
    self->_steps = steps;
    
    self->_numVertices = (steps+1)*(steps+1); 
    self->_numFacesIndices = steps*steps*2;
        
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
            
            double s = 1 - (double) longNumber / steps;
            double t = (double) latNumber / steps;
            
            self.vertices[latNumber*(steps+1) + longNumber].position = GLKVector3Make (radius * x,
                                                                                       radius * y,
                                                                                       radius * z);
            self.vertices[latNumber*(steps+1) + longNumber].texture = GLKVector2Make(s, t);
            
        }
    }
    
    for (int latNumber = 0; latNumber < steps; latNumber++) {
        for (int longNumber = 0; longNumber < steps; longNumber++) {
            int first = (latNumber * (steps + 1)) + longNumber;
            int second = first + steps + 1;
                        
            self.facesIndices[latNumber*steps*2 + longNumber*2].a = first;
            self.facesIndices[latNumber*steps*2 + longNumber*2].b = second;
            self.facesIndices[latNumber*steps*2 + longNumber*2].c = first+1;
            
            self.facesIndices[latNumber*steps*2 + longNumber*2 + 1].a = second;
            self.facesIndices[latNumber*steps*2 + longNumber*2 + 1].b = second+1;
            self.facesIndices[latNumber*steps*2 + longNumber*2 + 1].c = first+1;
        }
    }
    
    return self;
}

- (void) dealloc
{
   
}



@end
