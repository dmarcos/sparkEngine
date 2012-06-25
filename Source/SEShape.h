//
//  SEShape.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import "SEVertexData.h"
#import "SEObject3D.h"

@interface SEShape : SEObject3D{
    @protected
    int _numVertices;
    int _numFacesIndices;
}

@property(readonly) PSVertexData* vertices;
@property(readonly) int numVertices;

@property(readonly) PSFaceIndices* facesIndices;
@property(readonly) int numFacesIndices;

// Buffer Objects names/ids.
@property GLuint vertexBuffer;
@property GLuint facesIndicesBuffer;

@end
