//
//  FRChartScrollView.m
//  FRChartScroller
//
//  Created by Peetry Zhang on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FRChartScrollView.h"

@implementation BuddleView

@synthesize offsetPoint;
@synthesize buddleString;

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.0f,0.0f,0.0f,0.2f);
    CGContextMoveToPoint(context, self.offsetPoint.x, self.offsetPoint.y);
    CGContextFillRect(context, rect);
}

@end

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
@synthesize topSpace;
@synthesize buttomSpace;
@synthesize isToFill;

-(CGPoint)getPoint:(NSInteger )index
{
    return CGPointMake(index*cellWidth,
                       (self.frame.size.height - topSpace - buttomSpace) * (1.0f - [(NSString *)[self.objectsArray objectAtIndex:index] floatValue]/(self.maxData - self.minData)));
}

-(void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:self];
    
    for (BuddleView *bv in chartView.subviews) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             bv.alpha = 0;
                         } 
                         completion:^(BOOL finished) {
                             [bv removeFromSuperview];
                         }];
    }
    
    NSInteger buddleIndex = (int)(tapPoint.x/cellWidth);
    BuddleView *buddleView = [[BuddleView alloc]initWithFrame:CGRectMake(buddleIndex*cellWidth+10, 
                                                                         [self getPoint:buddleIndex].y-60,
                                                                         cellWidth-20,
                                                                         50)];
    buddleView.offsetPoint = CGPointMake([self getPoint:buddleIndex].x,
                                         [self getPoint:buddleIndex].y - 10);
    buddleView.buddleString = [self.objectsArray objectAtIndex:buddleIndex];
    buddleView.alpha = 0;
    [chartView addSubview:buddleView];
    [UIView animateWithDuration:0.4
                     animations:^{
                         buddleView.alpha = 1;
                     } 
                     completion:nil];
}

-(void)setup
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.minData = 0;
    self.maxData = 10;
    self.cellWidth = 320.0f/6.5f;
    self.topSpace = 1;
    self.buttomSpace = 1;
    isToFill = YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
//    [self addGestureRecognizer:tap];
//    [tap release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
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
        [dataDotImg drawAtPoint:CGPointMake([self getPoint:i].x+(cellWidth-dataDotImg.size.width)/2,
                                            [self getPoint:i].y)];
        
        thePoints[i] = CGPointMake([self getPoint:i].x+(cellWidth-dataDotImg.size.width)/2+dataDotImg.size.width/2,
                                   [self getPoint:i].y+dataDotImg.size.height/2);
    }
    
    CGContextSetRGBStrokeColor(c, 0.02f, 0.57f, 0.81f, 1.0f);
    CGContextSetRGBFillColor(c, 0.02f, 0.57f, 0.81f, 0.1f);
    CGContextSetLineWidth(c, 2.0f);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, 0, thePoints[0].y);
    CGPathAddLineToPoint(pathRef, NULL, thePoints[0].x,thePoints[0].y);
    CGPathAddLines(pathRef, NULL, thePoints, theCount);
    CGPathAddLineToPoint(pathRef, NULL, self.contentSize.width+1,thePoints[self.objectsArray.count-1].y);
    CGPathAddLineToPoint(pathRef, NULL, self.contentSize.width+1,self.contentSize.height+1);
    CGPathAddLineToPoint(pathRef, NULL, -1,self.contentSize.height+1);
    CGPathAddLineToPoint(pathRef, NULL, -1,thePoints[0].y);

    CGContextAddPath(c, pathRef);
    CGContextStrokePath(c);
    
    if (isToFill) {
        CGContextAddPath(c, pathRef);
        CGContextFillPath(c);
    }
    
    CGPathRelease(pathRef);
}

@end
