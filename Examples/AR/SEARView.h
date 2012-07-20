//
//  SEARView.h
//  SparkEngine
//
//  Created by Diego Marcos on 7/19/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEView.h"
#import "QCARutils.h"
#import <QCAR/UIGLViewProtocol.h>

@interface SEARView : SEView<UIGLViewProtocol, SERendererDelegate>

@property (nonatomic) QCARutils *qUtils; 

@end
