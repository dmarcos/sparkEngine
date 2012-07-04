//
//  SEMesh.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import "SEGeometryData.h"
#import "SEObject3D.h"

@interface SEMesh : SEObject3D{
    @protected
        int _numVertices;
        int _numFacesIndices;
}

-(id) initWithGeometry: (SEGeometryData) geometry;

@property (nonatomic, readonly) SEVertexData* vertices;
@property (nonatomic, readonly) int numVertices;

@property (nonatomic, readonly) SEFaceIndices* facesIndices;
@property (nonatomic, readonly) int numFacesIndices;

// Buffer Objects names/ids.
@property GLuint vertexBuffer;
@property GLuint facesIndicesBuffer;

@end
