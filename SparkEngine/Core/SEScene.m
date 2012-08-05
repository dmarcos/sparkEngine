//
//  SEScene.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/15/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEScene.h"
#import <Foundation/Foundation.h>

@interface SEScene(){
    NSMutableArray* _objects;
}

@end

@implementation SEScene

@synthesize backgroundColor = _backgroundColor;
@synthesize removedObjects = _removedObjects;

-(id) init
{
    self = [super init];
    if(self){
        self->_objects = [[NSMutableArray alloc] init];
        self->_removedObjects = [[NSMutableArray alloc] init];
        self->_backgroundColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    }
    return self;
}

-(void) addObject:(SEObject3D*)object
{
    [self->_objects addObject:object];
}

-(void) removeObject:(SEObject3D*)object
{
    [self->_removedObjects addObject: object];
    [self->_objects removeObject:object];
}

-(NSEnumerator*) objectEnumerator
{
    return [self->_objects objectEnumerator];
}

@end