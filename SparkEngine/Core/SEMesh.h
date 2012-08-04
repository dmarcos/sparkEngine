//
//  SEMesh.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import "SEObject3D.h"
#import "SEShaderMaterial.h"
#import "SEGeometry.h"

@interface SEMesh : SEObject3D{
    @protected
        int _numVertices;
        int _numFacesIndices;
}

-(id) initWithGeometry: (SEGeometry*) geometry material: (SEShaderMaterial*) material;

@property (nonatomic, retain) SEGeometry* geometry;
@property (nonatomic, retain) SEShaderMaterial* material;

// Buffer Objects names/ids.
@property (nonatomic) GLuint vertexBuffer;
@property bool vertexBufferNeedsUpdate;

@property GLuint facesIndicesBuffer;
@property GLuint linesIndicesBuffer;

@end
