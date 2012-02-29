//
//  FRChartScrollView.m
//  FRChartScroller
//
//  Created by Peetry Zhang on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FRChartScrollView.h"

@interface CHartView :UIView
@end

@implementation CHartView

-(void)drawRect:(CGRect)rect
{
    [((FRChartScrollView *)[self superview]) drawChartView:rect];
}

@end

@implementation FRChartScrollView

@synthesize objectsArray;
@synthesize minData;
@synthesize maxData;
@synthesize cellWidth;

-(void)setup
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setNeedsDisplay];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.contentSize = CGSizeMake(cellWidth*self.objectsArray.count, self.frame.size.height);
    
    chartView = [[CHartView alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    [self addSubview:chartView];
}

-(void)drawChartView:(CGRect)r
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGPoint thePoints[self.objectsArray.count];
    size_t theCount = self.objectsArray.count;
    
    for (int i=0; i<self.objectsArray.count; i++) {
        BOOL single = (i%2 != 0);
        CGContextSetFillColorWithColor(c, single?[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f].CGColor:[UIColor whiteColor].CGColor);
        CGContextAddRect(c, CGRectMake(i*cellWidth, 0, cellWidth, self.frame.size.height));
        CGContextFillPath(c);
        
        UIImage *dataDotImg = [UIImage imageNamed:@"data_point.png"];
        CGFloat dataHeight = self.frame.size.height * (1.0f - [(NSString *)[self.objectsArray objectAtIndex:i] floatValue]/(self.maxData - self.minData));
        [dataDotImg drawAtPoint:CGPointMake(i*cellWidth+(cellWidth-dataDotImg.size.width)/2,
                                            dataHeight)];
        
        thePoints[i] = CGPointMake(i*cellWidth+(cellWidth-dataDotImg.size.width)/2+dataDotImg.size.width/2,
                                   dataHeight+dataDotImg.size.height/2);
    }
    
    CGContextSetRGBStrokeColor(c, 0.02f, 0.57f, 0.81f, 1.0f);
    CGContextSetRGBFillColor(c,0.02f, 0.57f, 0.81f, 0.4f);
    CGContextSetLineWidth(c, 2.0f);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, 0, thePoints[0].y);
    CGPathAddLines(pathRef, NULL, thePoints, theCount);
    //    CGPathCloseSubpath(pathRef);
    
    CGContextAddPath(c, pathRef);
    CGContextStrokePath(c);
    
    //    CGContextAddPath(c, pathRef);
    //    CGContextFillPath(c);
    
    CGPathRelease(pathRef);
}

@end
