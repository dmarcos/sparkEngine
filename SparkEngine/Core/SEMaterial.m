//
//  SEMaterial.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/17/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEMaterial.h"

@implementation SEMaterial

@synthesize texture = _texture;
@synthesize verticesColors = _verticesColors;
@synthesize wireframe = _wireframe;
@synthesize pointCloud = _pointCloud;

- (id) init {
    self = [super init];
    if (self) {
        self.wireframe = NO;
        self.pointCloud = NO;
    }
    return self;
}

- (void) dealloc {
    free(self->_verticesColors);
}

@end
