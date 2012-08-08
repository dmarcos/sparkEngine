//
//  SETetrahedron.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 8/5/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SETetrahedron.h"

@implementation SETetrahedron

-(id) initWithMaterial:(SEShaderMaterial*)material
{
    GLfloat vertices[] = {
        0.00, 1.00, 0.00, 0.50, 0.50,
        0.00, -0.50, -1.00, 0.00, 0.00,
        0.00, -0.50, 1.00, 1.00, 0.00,
        1.00, -0.50, 0.00, 0.00, 1.00,
        -1.00,-0.50, 0.00, 1.00, 1.00
    };

    GLushort facesIndices[] = {
        0,1,3,
        0,1,4,
        0,2,3,
        0,2,4,
        1,3,4,
        2,3,4
    };
    
    GLushort linesIndices[] = {
        0,1,
        0,2,
        0,3,
        0,4,
        1,3,
        1,4,
        2,3,
        2,4,
        1,2
    };

    return [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:5 vertices:vertices numFaces:6 facesIndices:facesIndices numLines:9 linesIndices:linesIndices] material:material];
}

@end
