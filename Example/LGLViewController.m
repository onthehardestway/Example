//
//  LGLViewController.m
//  Example
//
//  Created by Liu Zhijin on 3/18/14.
//  Copyright (c) 2014 OnTheEasiestWay. All rights reserved.
//

#import "LGLViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

@interface LGLViewController ()
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@end

@implementation LGLViewController

typedef struct {
    GLKVector3 positionCoords;
} SceneVertex;

static SceneVertex vertices[] =
{
    {-0.5f, -0.5f, 0.0f},
    {0.5f, -0.5f, 0.0f},
    {-0.5f, 0.5f, 0.0f}
};

#define VertexCount (sizeof(vertices) / sizeof(SceneVertex))

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert([self.view isKindOfClass:[GLKView class]], @"view should be GLKView");
    GLKView *view = (GLKView *)self.view;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:VertexCount
                         data:vertices
                         usage:GL_STATIC_DRAW];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];

    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:0
                                  shouldEnable:YES];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:VertexCount];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    self.vertexBuffer = nil;
    
    view.context = nil;
    [AGLKContext setCurrentContext:nil];
}
@end
