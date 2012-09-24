//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Arman Shan on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *stackLabel;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(id)sender;
- (IBAction)enterPressed;
- (IBAction)clearPressed;
- (IBAction)variablePressed:(UIButton *)sender;
- (IBAction)undoPressed;
- (IBAction)graphPressed;

@end
