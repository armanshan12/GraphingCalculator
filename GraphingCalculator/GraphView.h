//
//  GraphView.h
//  GraphingCalculator
//
//  Created by Arman Shan on 8/17/12.
//  Copyright (c) 2012 Arman Shan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
- (float)yValueForGraphView:(GraphView *)sender at:(CGFloat)x;
- (BOOL) shouldUsePercision:(GraphView *)sender;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;  // resizes the graph

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

@end
