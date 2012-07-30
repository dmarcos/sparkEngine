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
    // 20 vertices x, y, z, u, v
    GLfloat cubeVertices[] =
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

    return [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:20 numberOfFaces:12 vertices:cubeVertices facesIndices:cubeIndices] material: material];
       
}

@end
