//
//  SESphereMesh.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/17/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEShape.h"

@interface SESphere : SEShape

-(id) initWithRadius: (float) radius withSteps: (int) steps;

@property (readonly) float radius;
@property (readonly) int steps;

@end
