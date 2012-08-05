//
//  SERectangle.h
//  SparkEngine
//
//  Created by Diego Marcos on 7/20/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEMesh.h"

@interface SERectangle : SEMesh

-(id) initWithMaterial:(SEShaderMaterial*)material;

@property (nonatomic) float height;
@property (nonatomic) float width;

@end
