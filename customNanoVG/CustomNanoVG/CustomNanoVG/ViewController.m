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
    [view bindDrawable];
    
    [EAGLContext setCurrentContext:self.context];
    
    renderer = [NanoVGRenderer alloc];
    memset(&renderer->context, 0, sizeof(renderer->context) );
    [renderer setup];
    
    // create the framebuffer and bind it
    /*glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    // create a color renderbuffer, allocate storage for it, and attach
    // it to the framebuffer's color attachment point
    glGenRenderbuffers(1, &colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8, view.drawableWidth, view.drawableHeight);
    glFramebufferRenderbuffer(GL_RENDERBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
    
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, view.drawableWidth, view.drawableHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);
       
    // create a depth or depth/stencil renderbuffer, allocate storage for it, and
    // attach it to the framebuffer's depth attatchment point
    glGenRenderbuffers(1, &depthRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, view.drawableWidth, view.drawableHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
    // create the destination texture, and attach it to the framebuffer's color attachment point
   
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    if(status != GL_FRAMEBUFFER_COMPLETE) {
         NSLog(@"failed to make complete framebuffer object %x", status);
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);*/
    
    renderer->context.userData = malloc(sizeof(UserData));
    esCreateWindow(&renderer->context, "My Application", 640, 480, ES_WINDOW_RGB | ES_WINDOW_DEPTH );
    esRegisterShutdownFunc(&renderer->context, Shutdown);
    esRegisterDrawFunc(&renderer->context, Draw);
    esRegisterUpdateFunc(&renderer->context, Update);
    
    prevt = getUptimeInSeconds();
}

-(void)dealloc
{
    [self tearDownGL];
    
    if ( [EAGLContext currentContext] == self.context )
    {
        [EAGLContext setCurrentContext:nil];
    }
}

-(void)update
{
    if (renderer && renderer->context.updateFunc)
    {
        renderer->context.updateFunc(&renderer->context, self.timeSinceLastUpdate);
    }
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    renderer->context.width = view.drawableWidth;
    renderer->context.height = view.drawableHeight;
    
    glViewport(0, 0, renderer->context.width, renderer->context.height);
    glClearColor(0.3f, 0.3f, 0.32f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    float pxRatio = 1.0f;
    nvgBeginFrame(renderer->vg, renderer->context.width, renderer->context.height, pxRatio);
    
    t = getUptimeInSeconds();
    dt = (t - prevt) * 0.001;
    prevt = t;
    
    [renderer render:renderer->vg MX:0 MY:0 Width:renderer->context.width Height:renderer->context.height T:dt Blowup:0 demoData:&renderer->data];
    
    nvgEndFrame(renderer->vg);
}

-(void)tearDownGL
{
}

void Draw(ESContext* esContext)
{
    // UserData *userData = esContext->userData;
    // set the viewport
    glViewport( 0, 0, esContext->width, esContext->height);
    // clear the color buffer
    glClearColor(0.3f, 0.3f, 0.32f, 1.0f);
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );
    // use the program object
    // glUseProgram( userData->programObject );
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_CULL_FACE);
    glDisable(GL_DEPTH_TEST);
}

void Shutdown(ESContext* esContext)
{
    // UserData *userData = esContext->userData;
    // glDeleteProgram( userData->programObject );
}

void Update(ESContext* esContext, float deltaTime)
{
    
}

uint64_t get_currentTime() {
  mach_timebase_info_data_t info;
  if(mach_timebase_info(&info) != KERN_SUCCESS) {
    abort();
  }
  return mach_absolute_time() * info.numer / info.denom;
}

double getUptimeInSeconds()
{
    const int64_t kOneMillion = 1000 * 1000;
    static mach_timebase_info_data_t s_timebase_info;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        (void) mach_timebase_info(&s_timebase_info);
    });

    // mach_absolute_time() returns billionth of seconds,
    // so divide by one million to get milliseconds
    return (double)((mach_absolute_time() * s_timebase_info.numer) / (kOneMillion * s_timebase_info.denom));
}

@end
