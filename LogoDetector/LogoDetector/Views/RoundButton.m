////////
// This sample is published as part of the blog article at www.toptal.com/blog 
// Visit www.toptal.com/blog and subscribe to our newsletter to read great posts
////////

//
//  RoundButton.m
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 13/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

/*
 Inspired https://github.com/ckteebe/CustomBadge/blob/master/Classes/CustomBadge.m
 */

#import "RoundButton.h"

@implementation RoundButton

#define CONTENT_COLOR [[UIColor whiteColor] CGColor]
#define BORDER_COLOR [[UIColor redColor] CGColor]

- (void) drawContent: (CGContextRef) context inRect: (CGRect) rect
{
    CGFloat radius = rect.size.height / 2.0;
    CGFloat puffer = 0;//CGRectGetMaxY(rect)*0.10;
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, CONTENT_COLOR);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
    CGContextFillPath(context);
}

- (void) drawCorner: (CGContextRef) context inRect: (CGRect) rect
{
    CGFloat radius = rect.size.height / 2.0;
    CGFloat puffer = 0;//CGRectGetMaxY(rect)*0.10;
    
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    CGContextBeginPath(context);
    CGFloat lineSize = 4;
    CGContextSetLineWidth(context, lineSize);
    CGContextSetStrokeColorWithColor(context, BORDER_COLOR);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect smallerRect = CGRectMake(5, 5, rect.size.width - 10, rect.size.height - 10);
    
    [self drawContent: context inRect: smallerRect];
    [self drawCorner: context inRect: smallerRect];
}

@end
