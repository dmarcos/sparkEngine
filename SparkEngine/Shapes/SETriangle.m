//
//  SETriangle.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/11/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SETriangle.h"

@implementation SETriangle

-(id) initWithVerticesColor: (GLKVector4*) colors material: (SEShaderMaterial*) material
{
    self = [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:3 numberOfFaces:1] material: material];
    if (self) {
                
        self.geometry.vertices[0].position = GLKVector3Make(-0.5, -0.5, 1.0);
        self.geometry.vertices[1].position = GLKVector3Make(0.5, -0.5, 1.0);
        self.geometry.vertices[2].position = GLKVector3Make(0.0, 0.5, 1.0);

        if (!colors) {
        
            self.geometry.vertices[0].color = GLKVector4Make(1.0, 0.0, 0.0, 0.0);
            self.geometry.vertices[1].color = GLKVector4Make(0.0, 1.0, 0.0, 0.0);
            self.geometry.vertices[2].color = GLKVector4Make(0.0, 0.0, 1.0, 0.0);
            
        } else {
            
            self.geometry.vertices[0].color = colors[0];
            self.geometry.vertices[1].color = colors[1];
            self.geometry.vertices[2].color = colors[2];
        }
        
        self.geometry.facesIndices[0].a = 0;
        self.geometry.facesIndices[0].b = 1;
        self.geometry.facesIndices[0].c = 2;
 
    }
    
    return self;
}

@end
