//
//  SEScene.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEScene.h"

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
