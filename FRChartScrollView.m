//
//  FRChartScrollView.m
//  FRChartScroller
//
//  Created by Peetry Zhang on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FRChartScrollView.h"

@implementation BuddleView

@synthesize buddleString;

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextFillRect(context, rect);
    
    [[UIColor whiteColor] set];
    [self.buddleString drawAtPoint:CGPointMake(rect.origin.x+8, rect.origin.y+8) 
                  forWidth:rect.size.width-16
                  withFont:[UIFont boldSystemFontOfSize:16]
             lineBreakMode:UILineBreakModeWordWrap];
}

@end

@implementation ChartView

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
                       (self.frame.size.height - topSpace - buttomSpace) * (1.0f - ([(NSString *)[self.objectsArray objectAtIndex:index] floatValue] - minData)/(maxData - minData)));
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
    if (buddleIndex <= self.objectsArray.count -1) {
        NSString *theBuddleString = [self.objectsArray objectAtIndex:buddleIndex];
        CGSize stringSize = [theBuddleString sizeWithFont:[UIFont boldSystemFontOfSize:16]
                                        constrainedToSize:CGSizeMake(self.frame.size.width/2, 999.0) 
                                            lineBreakMode:UILineBreakModeWordWrap];
        CGSize buddleSize = CGSizeMake(stringSize.width+8*2, stringSize.height+8*2);
        BuddleView *buddleView = [[BuddleView alloc]initWithFrame:CGRectMake([self getPoint:buddleIndex].x+cellWidth/2-buddleSize.width/2, 
                                                                             [self getPoint:buddleIndex].y-buddleSize.height-5,
                                                                             buddleSize.width,
                                                                             buddleSize.height)];
        buddleView.buddleString = theBuddleString;
        buddleView.alpha = 0;
        [chartView addSubview:buddleView];
        [UIView animateWithDuration:0.4
                         animations:^{
                             buddleView.alpha = 1;
                         } 
                         completion:nil];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        
        minData = 0;
        maxData = 10;
        cellWidth = 320.0f/6.5f;
        topSpace = 1;
        buttomSpace = 1;
        isToFill = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.contentSize = CGSizeMake(cellWidth*self.objectsArray.count, self.frame.size.height);
    
    chartView = [[ChartView alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    [self addSubview:chartView];
    
    if (self.objectsArray.count > 7) {
        [self setContentOffset:CGPointMake(self.contentSize.width-320, self.contentOffset.y) animated:NO];
    }
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
        
        CGContextSetRGBStrokeColor(c, 0.02f, 0.57f, 0.81f, 1.0f);
        CGContextSetLineWidth(c, 2);
        CGContextAddEllipseInRect(c, CGRectMake([self getPoint:i].x+(cellWidth-12)/2,
                                                [self getPoint:i].y,
                                                12,
                                                12));
        CGContextStrokePath(c);
        
        CGContextSetRGBFillColor(c, 0.02f, 0.57f, 0.81f, 1.0f);
        CGContextAddEllipseInRect(c, CGRectMake([self getPoint:i].x+(cellWidth-8)/2,
                                                [self getPoint:i].y+2,
                                                8,
                                                8));
        CGContextFillPath(c);
        
        thePoints[i] = CGPointMake([self getPoint:i].x+(cellWidth-12)/2+12/2,
                                   [self getPoint:i].y+12/2);
    }
    
    CGContextSetRGBStrokeColor(c, 0.02f, 0.57f, 0.81f, 1.0f);
    CGContextSetRGBFillColor(c, 0.02f, 0.57f, 0.81f, 0.1f);
    CGContextSetLineWidth(c, 2.0f);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddLines(pathRef, NULL, thePoints, theCount);
    if (theCount > 1) {
        CGPathAddLineToPoint(pathRef, NULL, self.contentSize.width+1,thePoints[self.objectsArray.count-1].y);
        CGPathAddLineToPoint(pathRef, NULL, self.contentSize.width+1,self.contentSize.height+1);
        CGPathAddLineToPoint(pathRef, NULL, -1,self.contentSize.height+1);
        CGPathAddLineToPoint(pathRef, NULL, -1,thePoints[0].y);
        CGPathAddLineToPoint(pathRef, NULL, thePoints[0].x,thePoints[0].y);
    }

    CGContextAddPath(c, pathRef);
    CGContextStrokePath(c);
    
    if (isToFill) {
        CGContextAddPath(c, pathRef);
        CGContextFillPath(c);
    }
    
    CGPathRelease(pathRef);
}

@end
