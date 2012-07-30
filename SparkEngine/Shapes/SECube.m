//
//  SECube.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 7/30/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SECube.h"

@implementation SECube


-(id) initWithMaterial: (SEShaderMaterial*) material
{
    self = [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:20 numberOfFaces:12] material: material];
    if (self) {
        
        // 20 vertices
        GLfloat cubeStructure[] =
        {
            0.50, -0.50, -0.50, -0.00, 0.00,
            0.50, -0.50, 0.50, 0.33, 0.00,
            -0.50, -0.50, 0.50, 0.33, 0.33,
            -0.50, -0.50, -0.50, -0.00, 0.33,
            0.50, 0.50, -0.50, 0.67, 0.33,
            0.50, -0.50, -0.50, 0.33, 0.33,
            -0.50, -0.50, -0.50, 0.33, 0.00,
            -0.50, 0.50, -0.50, 0.67, 0.00,
            0.50, 0.50, 0.50, 0.67, 0.67,
            0.50, -0.50, 0.50, 0.33, 0.67,
            -0.50, 0.50, 0.50, 0.67, 1.00,
            -0.50, -0.50, 0.50, 0.33, 1.00,
            -0.50, 0.50, -0.50, 0.33, 1.00,
            -0.50, -0.50, -0.50, -0.00, 1.00,
            -0.50, -0.50, 0.50, -0.00, 0.67,
            -0.50, 0.50, 0.50, 0.33, 0.67,
            -0.50, 0.50, 0.50, -0.00, 0.67,
            0.50, 0.50, 0.50, -0.00, 0.33,
            0.50, 0.50, -0.50, 0.33, 0.33,
            -0.50, 0.50, -0.50, 0.33, 0.67,
        };
        
        for(int i = 0; i < 20; ++i) {
            self.geometry.vertices[i].position = GLKVector3Make(cubeStructure[i*5], cubeStructure[i*5+1], cubeStructure[i*5+2]);
            self.geometry.vertices[i].texture = GLKVector2Make(cubeStructure[i*5+3], cubeStructure[i*5+4]);
            if(material && material.verticesColors) {
                self.geometry.vertices[i].color = material.verticesColors[i];
            } else {
                self.geometry.vertices[i].color = GLKVector4Make(1.0, 0.0, 0.0, 0.0);
            }
        }
        
        // 12 faces
        GLushort cubeIndices[] =
        {
            0, 1, 2,
            2, 3, 0,
            4, 5, 6,
            6, 7, 4,
            8, 9, 5,
            5, 4, 8,
            10, 11, 9,
            9, 8, 10,
            12, 13, 14,
            14, 15, 12,
            16, 17, 18,
            18, 19, 16,
        };
        
        for(int i = 0; i < 12; ++i) {
            self.geometry.facesIndices[i].a = cubeIndices[i*3];
            self.geometry.facesIndices[i].b = cubeIndices[i*3+1];
            self.geometry.facesIndices[i].c = cubeIndices[i*3+2];
        }
             
    }
    
    return self;
}

@end
