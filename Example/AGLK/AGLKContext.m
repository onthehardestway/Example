//
//  AGLKContext.m
//  Example
//
//  Created by Liu Zhijin on 3/19/14.
//  Copyright (c) 2014 OnTheEasiestWay. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext

- (void)currentContextCheck
{
    NSAssert((self == [EAGLContext currentContext]),
             @"Receiving context required to be current context");
}

- (void)setClearColor:(GLKVector4)clearColor
{
    [self currentContextCheck];
    
    _clearColor = clearColor;
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}

- (void)clear:(GLbitfield)mask
{
    [self currentContextCheck];
    
    glClear(mask);
}

- (void)enable:(GLenum)capability
{
    [self currentContextCheck];
    glEnable(capability);
}

- (void)disable:(GLenum)capability
{
    [self currentContextCheck];
    glDisable(capability);
}

- (void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor
{
    glBlendFunc(sfactor, dfactor);
}
@end
