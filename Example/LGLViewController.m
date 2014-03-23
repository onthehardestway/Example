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
#import "AGLKTextureLoader.h"

@interface LGLViewController ()
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *extraBuffer;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) GLKBaseEffect *extraEffect;

@property (nonatomic, assign) GLfloat centerVertexHeight;
@property (nonatomic, assign) BOOL faceNormal;
@property (nonatomic, assign) BOOL showNoramlLine;
@end

@implementation LGLViewController

typedef struct {
    GLKVector3 position;
    GLKVector3 normal;
} SceneVertex;

typedef struct {
    SceneVertex vertices[3];
} SceneTriangle;

static SceneTriangle makeTriangle(SceneVertex v1, SceneVertex v2, SceneVertex v3)
{
    SceneTriangle triangle = {v1, v2, v3};
    return triangle;
}

static void populateInitTriangles()
{
    triangles[0] = makeTriangle(vertexA, vertexB, vertexD);
    triangles[1] = makeTriangle(vertexB, vertexE, vertexD);
    triangles[2] = makeTriangle(vertexB, vertexF, vertexE);
    triangles[3] = makeTriangle(vertexB, vertexC, vertexF);
    triangles[4] = makeTriangle(vertexD, vertexH, vertexG);
    triangles[5] = makeTriangle(vertexD, vertexE, vertexH);
    triangles[6] = makeTriangle(vertexE, vertexF, vertexH);
    triangles[7] = makeTriangle(vertexF, vertexI, vertexH);
}

static const SceneVertex vertexA = {{-0.5, 0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexB = {{-0.5, 0.0, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexC = {{-0.5, -0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexD = {{0.0, 0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexE = {{0.0, 0.0, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexF = {{0.0, -0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexG = {{0.5, 0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexH = {{0.5, 0.0, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexI = {{0.5, -0.5, -0.5}, {0.0, 0.0, 1.0}};

#define NUM_FACES 8
#define NUM_NORMAL_LINE_VECTORS (8 * 3 * 2)
#define NUM_LINE_VECTORS (NUM_NORMAL_LINE_VECTORS + 2)

static SceneTriangle triangles[NUM_FACES] = {};
static GLKVector3 lines[NUM_LINE_VECTORS] = {};

#pragma mark - Helper Method
GLKVector3 faceNormalOfTriangle(SceneTriangle triangle)
{
    GLKVector3 v1 = GLKVector3Subtract(triangle.vertices[1].position,
                                       triangle.vertices[0].position);
    GLKVector3 v2 = GLKVector3Subtract(triangle.vertices[2].position,
                                       triangle.vertices[0].position);
    
    GLKVector3 normal = GLKVector3Normalize(GLKVector3CrossProduct(v1, v2));
    return normal;
}

void updateFaceNormals(SceneTriangle triangles[NUM_FACES])
{
    for (int i = 0; i < NUM_FACES; i++) {
        GLKVector3 faceNormal = faceNormalOfTriangle(triangles[i]);
        triangles[i].vertices[0].normal = faceNormal;
        triangles[i].vertices[1].normal = faceNormal;
        triangles[i].vertices[2].normal = faceNormal;
    }
}

void updateVertexNormal(SceneTriangle triangles[NUM_FACES])
{
    SceneVertex newVertexA = vertexA;
    SceneVertex newVertexB = vertexB;
    SceneVertex newVertexC = vertexC;
    SceneVertex newVertexD = vertexD;
    SceneVertex newVertexE = triangles[1].vertices[1];
    SceneVertex newVertexF = vertexF;
    SceneVertex newVertexG = vertexG;
    SceneVertex newVertexH = vertexH;
    SceneVertex newVertexI = vertexI;
    
    GLKVector3 faceNormal[NUM_FACES];
    for (int i = 0; i < NUM_FACES; i++) {
        faceNormal[i] = faceNormalOfTriangle(triangles[i]);
    }
    
    newVertexA.normal = faceNormal[0];
    newVertexB.normal = GLKVector3DivideScalar(
       GLKVector3Add(faceNormal[0],
                     GLKVector3Add(faceNormal[1],
                                   GLKVector3Add(faceNormal[2],
                                                 faceNormal[3]))),
                                               4);
    
    newVertexC.normal = faceNormal[3];
    newVertexD.normal = GLKVector3DivideScalar(
        GLKVector3Add(faceNormal[0],
                      GLKVector3Add(faceNormal[1],
                                    GLKVector3Add(faceNormal[4],
                                                  faceNormal[5]))),
                                               4);
    
    newVertexE.normal = GLKVector3DivideScalar(
       GLKVector3Add(faceNormal[1],
                     GLKVector3Add(faceNormal[2],
                                   GLKVector3Add(faceNormal[5],
                                                 faceNormal[6]))),
                                               4);
    
    newVertexF.normal = GLKVector3DivideScalar(
       GLKVector3Add(faceNormal[2],
                     GLKVector3Add(faceNormal[3],
                                   GLKVector3Add(faceNormal[6],
                                                 faceNormal[7]))),
                                               4);
    
    newVertexG.normal = faceNormal[4];
    
    newVertexH.normal = GLKVector3DivideScalar(
       GLKVector3Add(faceNormal[4],
                     GLKVector3Add(faceNormal[5],
                                   GLKVector3Add(faceNormal[6],
                                                 faceNormal[7]))),
                                               4);
    
    newVertexI.normal = faceNormal[7];
    
    
    triangles[0] = makeTriangle(newVertexA, newVertexB, newVertexD);
    triangles[1] = makeTriangle(newVertexB, newVertexE, newVertexD);
    triangles[2] = makeTriangle(newVertexB, newVertexF, newVertexE);
    triangles[3] = makeTriangle(newVertexB, newVertexC, newVertexF);
    triangles[4] = makeTriangle(newVertexD, newVertexH, newVertexG);
    triangles[5] = makeTriangle(newVertexD, newVertexE, newVertexH);
    triangles[6] = makeTriangle(newVertexE, newVertexF, newVertexH);
    triangles[7] = makeTriangle(newVertexF, newVertexI, newVertexH);
}

void updateNormalLines(SceneTriangle triangles[NUM_FACES], GLKVector3 lightVector,  GLKVector3 lines[NUM_LINE_VECTORS])
{
    GLuint index = 0;
    for (int i = 0; i < NUM_FACES; i++) {
        for (int j = 0; j < 3; j++) {
            SceneVertex vertex = triangles[i].vertices[j];
            lines[index++] = vertex.position;
            lines[index++] = GLKVector3Add(vertex.position, GLKVector3DivideScalar(vertex.normal, 2));
        }
    }
    
    lines[index++] = lightVector;
    lines[index] = GLKVector3Make(0.0, 0.0, -0.5);
}

#pragma mark - Accessor Method
- (void)setCenterVertexHeight:(GLfloat)centerVertexHeight
{
    _centerVertexHeight = centerVertexHeight;
    
    SceneVertex newVertexE = vertexE;
    newVertexE.position.z = centerVertexHeight;
    
    triangles[1] = makeTriangle(vertexB, newVertexE, vertexD);
    triangles[2] = makeTriangle(vertexB, vertexF, newVertexE);
    triangles[5] = makeTriangle(vertexD, newVertexE, vertexH);
    triangles[6] = makeTriangle(newVertexE, vertexF, vertexH);
    
    [self updateNormals];
}

- (void)setFaceNormal:(BOOL)faceNormal
{
    _faceNormal = faceNormal;
    
    [self updateNormals];
}

- (void)setShowNoramlLine:(BOOL)showNoramlLine
{
    _showNoramlLine = showNoramlLine;
    [self updateNormals];
}

- (void)updateNormals
{
    if (self.faceNormal) {
        updateFaceNormals(triangles);
    } else {
        updateVertexNormal(triangles);
    }
    
    if (self.showNoramlLine) {
        updateNormalLines(triangles, GLKVector3MakeWithArray(self.baseEffect.light0.position.v), lines);
    }
    
    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex)
                             numberOfVertices:sizeof(triangles) / sizeof(SceneVertex)
                                         data:triangles];
}

- (void)drawNormalLine
{
    [self.extraBuffer reinitWithAttribStride:sizeof(GLKVector3)
                            numberOfVertices:NUM_LINE_VECTORS
                                        data:lines];
    
    [self.extraBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                          numberOfCoordinates:3
                                 attribOffset:0
                                 shouldEnable:YES];

    self.extraEffect.useConstantColor = GL_TRUE;
    self.extraEffect.constantColor = GLKVector4Make(0.0, 1.0, 0.0, 1.0);
    [self.extraEffect prepareToDraw];
    [self.extraBuffer drawArrayWithMode:GL_LINES
                       startVertexIndex:0
                       numberOfVertices:NUM_NORMAL_LINE_VECTORS];

    self.extraEffect.useConstantColor = GL_TRUE;
    self.extraEffect.constantColor = GLKVector4Make(1.0, 1.0, 0.0, 1.0);
    [self.extraEffect prepareToDraw];
    [self.extraBuffer drawArrayWithMode:GL_LINES
                       startVertexIndex:NUM_NORMAL_LINE_VECTORS
                       numberOfVertices:NUM_LINE_VECTORS - NUM_NORMAL_LINE_VECTORS];
}

#pragma mark - Target-Action
- (IBAction)shouldUseFaceNormal:(UISwitch *)sender
{
    self.faceNormal = sender.on;
}

- (IBAction)shouldShowNormalLine:(UISwitch *)sender
{
    self.showNoramlLine = sender.on;
}

- (IBAction)centerVertexHeightChange:(UISlider *)sender
{
    self.centerVertexHeight = sender.value;
}

#pragma mark - GLKViewController method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert([self.view isKindOfClass:[GLKView class]], @"view should be GLKView");
    GLKView *view = (GLKView *)self.view;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7, 0.7, 0.7, 1.0);
    self.baseEffect.light0.position = GLKVector4Make(1.0, 1.0, 0.5, 0);
    
    self.extraEffect = [[GLKBaseEffect alloc] init];
    self.extraEffect.useConstantColor = GL_TRUE;

    {
        GLKMatrix4 transform = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60), 1.0, 0.0, 0.0);
        transform = GLKMatrix4Rotate(transform, GLKMathDegreesToRadians(-30), 0.0, 0.0, 1.0);
        transform = GLKMatrix4Translate(transform, 0.0, 0.0, 0.25);
        self.baseEffect.transform.modelviewMatrix = transform;
        self.extraEffect.transform.modelviewMatrix = transform;
    }
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    populateInitTriangles();
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                             numberOfVertices:sizeof(triangles) / sizeof(SceneVertex)
                                         data:triangles
                                        usage:GL_DYNAMIC_DRAW];
    
    self.extraBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                        initWithAttribStride:sizeof(GLKVector3)
                        numberOfVertices:0
                        data:NULL
                        usage:GL_DYNAMIC_DRAW];
    

    self.faceNormal = YES;
    self.centerVertexHeight = 0.0;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];

    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, position)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, normal) shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(triangles) / sizeof(SceneVertex)];
    
    if (self.showNoramlLine) {
        [self drawNormalLine];
    }
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
