//
//  SETriangle.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/11/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SETriangle.h"

@implementation SETriangle

-(id) initWithMaterial: (SEShaderMaterial*) material
{
    self = [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:3 vertices: nil numFaces:1 facesIndices: nil numLines: 3 linesIndices: nil] material: material];
    if (self) {
                
        self.geometry.vertices[0].position = GLKVector3Make(-0.5, -0.5, 1.0);
        self.geometry.vertices[1].position = GLKVector3Make(0.5, -0.5, 1.0);
        self.geometry.vertices[2].position = GLKVector3Make(0.0, 0.5, 1.0);

        self.geometry.facesIndices[0].a = 0;
        self.geometry.facesIndices[0].b = 1;
        self.geometry.facesIndices[0].c = 2;
        
        self.geometry.linesIndices[0].a = 0;
        self.geometry.linesIndices[0].b = 1;
        self.geometry.linesIndices[1].a = 0;
        self.geometry.linesIndices[1].b = 2;
        self.geometry.linesIndices[2].a = 1;
        self.geometry.linesIndices[2].b = 2;
        
    }
    
    return self;
}

@end
