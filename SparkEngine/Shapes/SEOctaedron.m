//
//  SEOctaedron.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 7/30/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEOctaedron.h"

@implementation SEOctaedron

-(id) initWithMaterial: (SEShaderMaterial*) material
{
    self = [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:6 numberOfFaces:8] material: material];
    if (self) {
        
        // 6 vertices
        GLfloat octaedronVertices[] =
        {
            0.00,0.00,-1.00, -0.00, 0.00,
            1.00,0.00,0.00, 0.00, 0.50,
            0.00,-1.00,0.00, 0.25, 0.50,
            -1.00,0.00,0.00, 0.50, 0.50,
            0.00,1.00,0.00, 0.75, 0.50,
            0.00,0.00,1.00, 0.00, 1.00
        };
        
        for(int i = 0; i < 6; ++i) {
            self.geometry.vertices[i].position = GLKVector3Make(octaedronVertices[i*5], octaedronVertices[i*5+1], octaedronVertices[i*5+2]);
            self.geometry.vertices[i].texture = GLKVector2Make(octaedronVertices[i*5+3], octaedronVertices[i*5+4]);
            if(material && material.verticesColors) {
                self.geometry.vertices[i].color = material.verticesColors[i];
            } else {
                self.geometry.vertices[i].color = GLKVector4Make(1.0, 0.0, 0.0, 0.0);
            }
        }
        
        // 8 faces
        GLushort octaedronIndices[] =
        {
            0,1,2,
            0,2,3,
            0,3,4,
            0,4,1,
            5,2,1,
            5,3,2,
            5,4,3,
            5,1,4
        };
        
        for(int i = 0; i < 8; ++i) {
            self.geometry.facesIndices[i].a = octaedronIndices[i*3];
            self.geometry.facesIndices[i].b = octaedronIndices[i*3+1];
            self.geometry.facesIndices[i].c = octaedronIndices[i*3+2];
        }
        
    }
    
    return self;
}

@end
