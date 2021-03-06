//
//  SE3DObject.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/14/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKMath.h>

@interface SEObject3D : NSObject

@property (nonatomic) GLKVector3 position;
@property (nonatomic) GLKVector3 rotation;
@property GLKVector3 up;

@property (nonatomic) GLKMatrix4 matrix;

@property (nonatomic) bool visible;

@end
