//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Arman Shan on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)pushVariable:(NSString *)var;
- (void)clear;
- (void) undo;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
