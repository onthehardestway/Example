//
//  LGLViewController.m
//  Example
//
//  Created by Liu Zhijin on 3/18/14.
//  Copyright (c) 2014 OnTheEasiestWay. All rights reserved.
//

#import "LGLViewController.h"

@interface LGLViewController ()
@property (nonatomic, assign) GLuint vertexDataBuffer;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert([self.view isKindOfClass:[GLKView class]], @"view should be GLKView");
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &_vertexDataBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexDataBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (self.vertexDataBuffer != 0) {
        glDeleteBuffers(1, &_vertexDataBuffer);
        self.vertexDataBuffer = 0;
    }
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}
@end
