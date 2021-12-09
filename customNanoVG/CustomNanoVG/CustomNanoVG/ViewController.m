//
//  ViewController.m
//  CustomNanoVG
//
//  Created by 姚隽楠 on 2021/12/9.
//  Copyright © 2021 tencent. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!self.context)
    {
        printf(" create eaglContext failed ! ");
        return;
    }
    
    GLKView *view = (GLKView*)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    renderer = [NanoVGRenderer alloc];
    
    [EAGLContext setCurrentContext:self.context];
    memset(&renderer->context, 0, sizeof(renderer->context) );
    
    renderer->context.userData = malloc(sizeof(UserData));
    esCreateWindow(&renderer->context, "My Application", 640, 480, ES_WINDOW_RGB | ES_WINDOW_DEPTH );
    esRegisterShutdownFunc(&renderer->context, Shutdown);
    esRegisterDrawFunc(&renderer->context, Draw);
    esRegisterUpdateFunc(&renderer->context, Update);
    
    [renderer setup];
}

void Draw(ESContext* esContext)
{
    // UserData *userData = esContext->userData;
    // set the viewport
    glViewport( 0, 0, esContext->width, esContext->height);
    // clear the color buffer
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    // use the program object
    // glUseProgram( userData->programObject );
}

void Shutdown(ESContext* esContext)
{
    // UserData *userData = esContext->userData;
    // glDeleteProgram( userData->programObject );
}

void Update(ESContext* esContext, float deltaTime)
{
    int a = 0;
}

@end
