//
//  SEMesh.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import "SEShader.h"
#import "SEGeometry.h"
#import "SEObject3D.h"

@interface SEMesh : SEObject3D{
    @protected
        int _numVertices;
        int _numFacesIndices;
}

-(id) initWithGeometry: (SEGeometry*) geometry shader: (SEShader*) shader;

@property (nonatomic) SEGeometry* geometry;
@property (nonatomic) SEShader* shader;

// Buffer Objects names/ids.
@property GLuint vertexBuffer;
@property GLuint facesIndicesBuffer;

@end
