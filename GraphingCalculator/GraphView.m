//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Arman Shan on 8/17/12.
//  Copyright (c) 2012 Arman Shan. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

#define DEFAULT_SCALE 50.0
#define DEFAULT_ORIGIN_X 0.0
#define DEFAULT_ORIGIN_Y 0.0

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize dataSource;

- (CGFloat)scale
{
    if (!_scale){
        return DEFAULT_SCALE; // don't allow zero scale
    }
    else{
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale){
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)setOrigin:(CGPoint)origin
{
    if(!CGPointEqualToPoint(origin, _origin)){
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (CGPoint)viewCenter
{
    return CGPointMake(self.bounds.size.width/2+self.bounds.origin.x, self.bounds.size.height/2+self.bounds.origin.y);

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
    self.origin = [self viewCenter];
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
        
    [self drawLineFrom:CGPointMake(self.bounds.origin.x, self.bounds.origin.y) to:CGPointMake(self.bounds.size.width, self.bounds.origin.y) inContext:context];
    [self drawLineFrom:CGPointMake(self.bounds.origin.x, self.bounds.origin.y) to:CGPointMake(self.bounds.origin.x, self.bounds.size.height) inContext:context];
    [self drawLineFrom:CGPointMake(self.bounds.origin.x, self.bounds.size.height) to:CGPointMake(self.bounds.size.width, self.bounds.size.height) inContext:context];
    [self drawLineFrom:CGPointMake(self.bounds.size.width, self.bounds.size.height) to:CGPointMake(self.bounds.size.width, self.bounds.origin.y) inContext:context];

    
    
    if([self.dataSource shouldUsePercision:self]){
        for (float position = self.bounds.origin.x; position < self.bounds.origin.x + self.bounds.size.width; position+=0.1){
            float xValue =(position - self.origin.x) / self.scale;
            float yValue = self.origin.y - [self.dataSource yValueForGraphView:self at:xValue]*self.scale;
            CGContextFillRect(context, CGRectMake(position, yValue, 1, 1));
        }
    }
    else{
		float startingXValue = (0.0 - self.origin.x) / self.scale;
		float startingYValue = self.origin.y - [self.dataSource yValueForGraphView:self at:startingXValue] * self.scale;
		CGContextMoveToPoint(context, 0.0, startingYValue);
		
		for (float position = self.bounds.origin.x; position < self.bounds.origin.x + self.bounds.size.width; position+=10) {
			float xValue =(position - self.origin.x) / self.scale;
			float yValue = self.origin.y - [self.dataSource yValueForGraphView:self at:xValue]*self.scale;
			CGContextAddLineToPoint(context, position, yValue);
		}
        
        CGContextStrokePath(context);
    }
}

- (void)drawLineFrom:(CGPoint)point1 to:(CGPoint)point2 inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point1.x, point1.y);
    CGContextAddLineToPoint(context, point2.x, point2.y);
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(context,kCGPathStroke);
    UIGraphicsPopContext();
}

- (void)drawPointAt:(CGPoint)point inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextFillRect(context, CGRectMake(point.x,point.y,1,1));
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}


@end
