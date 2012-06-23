//
//  SEShape.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEVertexData.h"

@interface SEShape : NSObject{
    @protected
    int _numVertices;
    int _numFacesIndices;
}

@property(readonly) PSVertexData* vertices;
@property(readonly) int numVertices;

@property(readonly) PSFaceIndices* facesIndices;
@property(readonly) int numFacesIndices;

@end
