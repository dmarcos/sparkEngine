//
//  SERendererDelegate.h
//  SparkEngine
//
//  Created by Diego Marcos on 7/19/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SERendererDelegate <NSObject>

-(void) preRenderScene;
-(void) postRenderScene;

@end