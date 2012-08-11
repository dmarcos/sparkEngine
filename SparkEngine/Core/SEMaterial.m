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
@synthesize color = _color;

@synthesize renderStyle = _renderStyle;

- (id) init {
    self = [super init];
    if (self) {
        self.renderStyle = Triangles;
        self.color = GLKVector4Make(1.0, 0.0, 0.0, 1.0); // Default color. Totally arbitrary :)
    }
    return self;
}

- (void) dealloc {
    if (self->_verticesColors) {
        free(self->_verticesColors);
    }
}

@end
