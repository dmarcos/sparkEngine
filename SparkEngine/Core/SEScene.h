//
//  SEScene.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/15/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEObject3D.h"

@class NSEnumerator;

@interface SEScene : SEObject3D

@property GLKVector4 backgroundColor;

@property NSMutableArray* removedObjects;

-(void) addObject:(SEObject3D*)object;
-(void) removeObject:(SEObject3D*)object;
-(NSEnumerator*) objectEnumerator;

@end
