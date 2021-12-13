//
//  NanoVGRenderer.m
//  CustomNanoVG
//
//  Created by 姚隽楠 on 2021/12/9.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "NanoVGRenderer.h"

#include "../../nanovg/src/nanovg_gl.h"

@implementation NanoVGRenderer

-(void)setup
{
    vg = nvgCreateGLES3(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
    if (vg == NULL)
    {
        printf(" could not init nanovg.\n");
        return;
    }
    [self loadData:vg demoData:&data];
}

-(int)loadData:(NVGcontext *)vg demoData:(DemoData *)demoData
{
    if (vg == NULL)
        return -1;
    
    // 测试图片
    for (int i = 0; i < 12; ++i)
    {
        char file[128];
        NSString* imgName = [NSString stringWithFormat:@"./images/image%d", i + 1];
        NSString* imgBundlePath = [[NSBundle mainBundle] pathForResource:imgName ofType:@"jpg"];
        demoData->images[i] = nvgCreateImage(vg, [imgBundlePath UTF8String], 0);
        if (demoData->images[i] == 0)
        {
            printf(" Could not load %s.\n ", file);
            return -1;
        }
    }
    
    NSString* fontIconBundlePath = [[NSBundle mainBundle] pathForResource:@"entypo" ofType:@"ttf"];
    demoData->fontIcons = nvgCreateFont(vg, "icons", [fontIconBundlePath UTF8String]);
    
    NSString* fontNormalBundlePath = [[NSBundle mainBundle] pathForResource:@"Roboto-Regular" ofType:@"ttf"];
    demoData->fontNormal = nvgCreateFont(vg, "sans", [fontNormalBundlePath UTF8String]);
    
    NSString* fontBoldBundlePath = [[NSBundle mainBundle] pathForResource:@"Roboto-Bold" ofType:@"ttf"];
    demoData->fontBold = nvgCreateFont(vg, "sans-bold", [fontNormalBundlePath UTF8String]);
    
    NSString* fontEmojiBundlePath = [[NSBundle mainBundle] pathForResource:@"NotoEmoji-Regular" ofType:@"ttf"];
    demoData->fontEmoji = nvgCreateFont(vg, "emoji", [fontNormalBundlePath UTF8String]);
    
    nvgAddFallbackFontId(vg, demoData->fontNormal, demoData->fontEmoji);
    nvgAddFallbackFontId(vg, demoData->fontBold, demoData->fontEmoji);
    
    return 0;
}

void drawEyes(NVGcontext* vg, float x, float y, float w, float h, float mx, float my, float t)
{
    NVGpaint gloss, bg;
    float ex = w *0.23f;
    float ey = h * 0.5f;
    float lx = x + ex;
    float ly = y + ey;
    float rx = x + w - ex;
    float ry = y + ey;
    float dx,dy,d;
    float br = (ex < ey ? ex : ey) * 0.5f;
    float blink = 1 - pow(sinf(t*0.5f),200)*0.8f;

    bg = nvgLinearGradient(vg, x,y+h*0.5f,x+w*0.1f,y+h, nvgRGBA(0,0,0,32), nvgRGBA(0,0,0,16));
    nvgBeginPath(vg);
    nvgEllipse(vg, lx+3.0f,ly+16.0f, ex,ey);
    nvgEllipse(vg, rx+3.0f,ry+16.0f, ex,ey);
    nvgFillPaint(vg, bg);
    nvgFill(vg);

    bg = nvgLinearGradient(vg, x,y+h*0.25f,x+w*0.1f,y+h, nvgRGBA(220,220,220,255), nvgRGBA(128,128,128,255));
    nvgBeginPath(vg);
    nvgEllipse(vg, lx,ly, ex,ey);
    nvgEllipse(vg, rx,ry, ex,ey);
    nvgFillPaint(vg, bg);
    nvgFill(vg);

    dx = (mx - rx) / (ex * 10);
    dy = (my - ry) / (ey * 10);
    d = sqrtf(dx*dx+dy*dy);
    if (d > 1.0f) {
        dx /= d; dy /= d;
    }
    dx *= ex*0.4f;
    dy *= ey*0.5f;
    nvgBeginPath(vg);
    nvgEllipse(vg, lx+dx,ly+dy+ey*0.25f*(1-blink), br,br*blink);
    nvgFillColor(vg, nvgRGBA(32,32,32,255));
    nvgFill(vg);

    dx = (mx - rx) / (ex * 10);
    dy = (my - ry) / (ey * 10);
    d = sqrtf(dx*dx+dy*dy);
    if (d > 1.0f) {
        dx /= d; dy /= d;
    }
    dx *= ex*0.4f;
    dy *= ey*0.5f;
    nvgBeginPath(vg);
    nvgEllipse(vg, rx+dx,ry+dy+ey*0.25f*(1-blink), br,br*blink);
    nvgFillColor(vg, nvgRGBA(32,32,32,255));
    nvgFill(vg);

    gloss = nvgRadialGradient(vg, lx-ex*0.25f,ly-ey*0.5f, ex*0.1f,ex*0.75f, nvgRGBA(255,255,255,128), nvgRGBA(255,255,255,0));
    nvgBeginPath(vg);
    nvgEllipse(vg, lx,ly, ex,ey);
    nvgFillPaint(vg, gloss);
    nvgFill(vg);

    gloss = nvgRadialGradient(vg, rx-ex*0.25f,ry-ey*0.5f, ex*0.1f,ex*0.75f, nvgRGBA(255,255,255,128), nvgRGBA(255,255,255,0));
    nvgBeginPath(vg);
    nvgEllipse(vg, rx,ry, ex,ey);
    nvgFillPaint(vg, gloss);
    nvgFill(vg);
}

-(void)drawLines:(NVGcontext*)vg X:(float)x Y:(float)y W:(float)w H:(float)h T:(float)t
{
    drawEyes(vg, w - 250, 50, 150, 100, x, y, t);
    
    return;
    
    int i, j;
    float pad = 5.0f, s = w/9.0f - pad*2;
    float pts[4*2], fx, fy;
    int joins[3] = {NVG_MITER, NVG_ROUND, NVG_BEVEL};
    int caps[3] = {NVG_BUTT, NVG_ROUND, NVG_SQUARE};
    NVG_NOTUSED(h);

    nvgSave(vg);
    pts[0] = -s*0.25f + cosf(t*0.3f) * s*0.5f;
    pts[1] = sinf(t*0.3f) * s*0.5f;
    pts[2] = -s*0.25;
    pts[3] = 0;
    pts[4] = s*0.25f;
    pts[5] = 0;
    pts[6] = s*0.25f + cosf(-t*0.3f) * s*0.5f;
    pts[7] = sinf(-t*0.3f) * s*0.5f;

    /*for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            fx = x + s*0.5f + (i*3+j)/9.0f*w + pad;
            fy = y - s*0.5f + pad;

            nvgLineCap(vg, caps[i]);
            nvgLineJoin(vg, joins[j]);

            nvgStrokeWidth(vg, s*0.3f);
            nvgStrokeColor(vg, nvgRGBA(0,0,0,160));
            nvgBeginPath(vg);
            nvgMoveTo(vg, fx+pts[0], fy+pts[1]);
            nvgLineTo(vg, fx+pts[2], fy+pts[3]);
            nvgLineTo(vg, fx+pts[4], fy+pts[5]);
            nvgLineTo(vg, fx+pts[6], fy+pts[7]);
            nvgStroke(vg);

            nvgLineCap(vg, NVG_BUTT);
            nvgLineJoin(vg, NVG_BEVEL);

            nvgStrokeWidth(vg, 1.0f);
            nvgStrokeColor(vg, nvgRGBA(0,192,255,255));
            nvgBeginPath(vg);
            nvgMoveTo(vg, fx+pts[0], fy+pts[1]);
            nvgLineTo(vg, fx+pts[2], fy+pts[3]);
            nvgLineTo(vg, fx+pts[4], fy+pts[5]);
            nvgLineTo(vg, fx+pts[6], fy+pts[7]);
            nvgStroke(vg);
        }
    }*/
    nvgRestore(vg);
}

-(void)render:(NVGcontext *)vg MX:(float)mx MY:(float)my Width:(float)width Height:(float)height T:(float)t Blowup:(int)blowup demoData:(DemoData *)demoData
{
    [self drawLines:vg X:120 Y:-50 W:600 H:50 T:t];
}

@end
