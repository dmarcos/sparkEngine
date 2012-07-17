//
//  SEScene.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/15/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEScene.h"
#import <Foundation/Foundation.h>

@implementation SEScene

@synthesize objects = _objects;

-(id) init
{
    self = [super init];
    if(self){
        self->_objects = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
