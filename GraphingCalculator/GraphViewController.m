//
//  GraphViewController.m
//  GraphingCalculator
//
//  Created by Arman Shan on 8/17/12.
//  Copyright (c) 2012 Arman Shan. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView * graphView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar; // to put splitViewBarButtonitem in
@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize program = _program;
@synthesize programLabel = _programLabel;
@synthesize percisionSwitch = _percisionSwitch;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem; // implementation of SplitViewBarButtonItemPresenter protocol
@synthesize toolbar = _toolbar; // to put splitViewBarButtonItem in

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

/*
- (void)setProgramLabel:(UILabel *)programLabel
{
    _programLabel = programLabel;
    if([self.program count] != 0)
        _programLabel.text = [@"Y = " stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.program]];
    else
        _programLabel.text = @"No Equation to Graph";
}
 */

- (void)setProgram:(id)program
{
    _program = program;
    
    if([self.program count] != 0)
        _programLabel.text = [@"Y = " stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.program]];
    else
        _programLabel.text = @"No Equation to Graph";
    
    [self.graphView setNeedsDisplay];
    [self.programLabel setNeedsDisplay];
}

- (void) setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    
    // enable pinch gestures in the GraphView using its pinch: handler
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)]];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setDelaysTouchesBegan:YES];
    [doubleTap setNumberOfTapsRequired:2];
    [self.graphView addGestureRecognizer:doubleTap];
    
    self.graphView.dataSource = self;
}

- (void) handleDoubleTap : (UIGestureRecognizer*) sender
{
    self.graphView.scale *= 2;
}

- (void)handlePanning:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphView];
        self.graphView.origin = CGPointMake(self.graphView.origin.x + translation.x / 2, self.graphView.origin.y + translation.y / 2);
        [gesture setTranslation:CGPointZero inView:self.graphView];
    }
}

- (float)yValueForGraphView:(GraphView *)sender at:(CGFloat)x
{
    NSNumber *num = [[NSNumber alloc] initWithFloat:x];
    NSDictionary *vars = [[NSDictionary alloc] initWithObjectsAndKeys:num, @"x", nil];
    return [CalculatorBrain runProgram:self.program usingVariableValues:vars];
}

- (BOOL)shouldUsePercision:(GraphView *)sender
{
    if(self.percisionSwitch.on)
        return YES;
    else
        return NO;
}

- (IBAction)percisionSwitchChanged
{
    [self.graphView setNeedsDisplay];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setPercisionSwitch:nil];
    [super viewDidUnload];
}
@end
