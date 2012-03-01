//
//  FRChartScrollView.h
//  FRChartScroller
//
//  Created by Peetry Zhang on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuddleView : UIView
{
    CGPoint offsetPoint;
    NSString *buddleString;
}

@property (nonatomic, assign) CGPoint offsetPoint;
@property (nonatomic, retain) NSString *buddleString;

@end

@interface FRChartScrollView : UIScrollView
{
    CGFloat minData;
    CGFloat maxData;
    CGFloat cellWidth;
    CGFloat topSpace;
    CGFloat buttomSpace;
    NSMutableArray *objectsArray;
    
    BOOL isToFill;
    
    UIView *chartView;
}

@property (nonatomic, retain) NSMutableArray *objectsArray;
@property (nonatomic, assign) CGFloat minData;
@property (nonatomic, assign) CGFloat maxData;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat topSpace;
@property (nonatomic, assign) CGFloat buttomSpace;
@property (nonatomic, assign) BOOL isToFill;

-(void)drawChartView:(CGRect)r;

@end
