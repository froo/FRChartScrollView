//
//  FRChartScrollView.h
//  FRChartScroller
//
//  Created by Peetry Zhang on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRChartScrollView : UIScrollView
{
    CGFloat minData;
    CGFloat maxData;
    CGFloat cellWidth;
    NSMutableArray *objectsArray;
    
    UIView *chartView;
}

@property (nonatomic, retain) NSMutableArray *objectsArray;
@property (nonatomic, assign) CGFloat minData;
@property (nonatomic, assign) CGFloat maxData;
@property (nonatomic, assign) CGFloat cellWidth;

-(void)drawChartView:(CGRect)r;

@end
