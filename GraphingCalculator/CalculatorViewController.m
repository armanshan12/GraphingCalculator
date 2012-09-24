//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Arman Shan on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasAlreadyEnteredADecimal;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableDictionary *testVariableValues;
@property (nonatomic) BOOL userIsUsingVariables;

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize stackLabel = _stackLabel;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasAlreadyEnteredADecimal = _userHasAlreadyEnteredADecimal;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;
@synthesize userIsUsingVariables = _userIsUsingVariables;


- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSDictionary *) testVariableValues
{
    if(!_testVariableValues) _testVariableValues = [[NSMutableDictionary alloc] init];
    return _testVariableValues;
}


- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if([sender.currentTitle isEqualToString:@"."]){
            if(!self.userHasAlreadyEnteredADecimal){
                self.display.text = [self.display.text stringByAppendingString:digit];
                self.userHasAlreadyEnteredADecimal = YES;
            }
        }
        else{
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    }
    else {
        if([sender.currentTitle isEqualToString:@"."]){
           self.display.text = [@"0" stringByAppendingString:digit];
            self.userHasAlreadyEnteredADecimal = YES;
        }
        else{
            self.display.text = digit;
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    
    double result;
    
    if([self.testVariableValues count] == 0){
        result = [self.brain performOperation:sender.currentTitle];
    }
    else{
        result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    }
    
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.stackLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)enterPressed 
{
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self.brain pushOperand:[self.display.text doubleValue]];
        self.stackLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
        self.userHasAlreadyEnteredADecimal = NO;
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)clearPressed
{
    self.display.text = @"0";
    self.stackLabel.text = @"";
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasAlreadyEnteredADecimal = NO;
    self.userIsUsingVariables = NO;
    
    [self.brain clear]; 
}

- (IBAction)variablePressed:(UIButton *)sender
{
    [self.brain pushVariable:sender.currentTitle];
    self.display.text = sender.currentTitle;
    self.stackLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.userIsUsingVariables = YES;
}

- (IBAction)undoPressed
{
    if(self.userIsInTheMiddleOfEnteringANumber){
        if([self.display.text characterAtIndex:[self.display.text length]-1] == '.'){
            self.userHasAlreadyEnteredADecimal = NO;
        }
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        if([self.display.text isEqualToString:@""]){
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
    else{
        [self.brain undo];
        self.display.text = @"0";
    }
    
    self.stackLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)graphPressed
{
    if ([self splitViewGraphViewController]){ // if in split view
        [[self splitViewGraphViewController] setProgram:self.brain.program]; // just set program in detail
        //if([self splitViewGraphViewController]) NSLog(@"WE GOT CHECKED AS SPLIT VIEW");
    }
    else{
        [self performSegueWithIdentifier:@"ShowGraph" sender:self];
    }
}

- (GraphViewController *)splitViewGraphViewController
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphViewController class]]) {
        gvc = nil;
    }
    return gvc;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        [segue.destinationViewController setProgram:self.brain.program];
    }
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setStackLabel:nil];
    
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES; //(toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

@end







     

