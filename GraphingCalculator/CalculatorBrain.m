//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Arman Shan on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#include <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;

+ (BOOL)isOperation:(id)item;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (void)pushVariable:(NSString *)var
{
    [self.programStack addObject:var];
}

- (void)clear
{
    self.programStack = nil;
}

- (void) undo
{
    id lastObj = [self.programStack lastObject];
    if(lastObj) [self.programStack removeLastObject];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    NSMutableString *result = [[NSMutableString alloc] init];
    
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    
    do {
        [result appendString:[self descriptionOfStack:stack]];
        
        if ([stack count])
            [result appendString:@", "];
    } while ([stack count]);
    
    return result;
}

+ (NSString *)descriptionOfStack:(NSMutableArray *)stack
{
    
    NSMutableString *description;
    
    NSSet *oneOperandOperations =
    [NSSet setWithObjects:@"sqrt",@"sin",@"cos",@"+/-",nil];
    
    NSSet *twoOperandOperations =
    [NSSet setWithObjects:@"+",@"*",@"-",@"/",nil];
    
    NSSet *variableNames = [NSSet setWithObjects:@"x",@"y",@"z", nil];
    
    id topOfStack = [stack lastObject];
    
    if (topOfStack)
        [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        description = [NSMutableString stringWithFormat:@"%g",
                       [topOfStack doubleValue]];
    }
    else if ([self isOperation:topOfStack])
    {
        if ([twoOperandOperations member:topOfStack])
        {
            if ([topOfStack isEqualToString:@"+"] ||
                [topOfStack isEqualToString:@"*"])
            {
                if ([twoOperandOperations member:[stack lastObject]]) {
                    description = [NSMutableString stringWithFormat:@"(%@) %@ ",
                                   [self descriptionOfStack:stack],topOfStack];
                }
                else {
                    description = [NSMutableString stringWithFormat:@"%@ %@ ",
                                   [self descriptionOfStack:stack],topOfStack];
                }
                
                if ([twoOperandOperations member:[stack lastObject]]) {
                    [description appendFormat:@"(%@)",
                     [self descriptionOfStack:stack]];
                }
                else
                    [description appendString:[self descriptionOfStack:stack]];
            } else if ([topOfStack isEqualToString:@"-"] ||
                       [topOfStack isEqualToString:@"/"])
            {
                NSString *firstArgumentDescription;
                NSString *secondArgumentDescription;
                
                if ([twoOperandOperations member: [stack lastObject]])
                    secondArgumentDescription = [NSString stringWithFormat:@"(%@)",
                                                 [self descriptionOfStack:stack]];
                else
                    secondArgumentDescription = [NSString stringWithFormat:@"%@",
                                                 [self descriptionOfStack:stack]];
                
                if ([twoOperandOperations member: [stack lastObject]])
                    firstArgumentDescription = [NSString stringWithFormat:@"(%@)",
                                                [self descriptionOfStack:stack]];
                else
                    firstArgumentDescription = [NSString stringWithFormat:@"%@",
                                                [self descriptionOfStack:stack]];
                
                description = [NSString stringWithFormat:@"%@ %@ %@",
                               firstArgumentDescription,topOfStack,
                               secondArgumentDescription];
                
            }
        }
        else if ([oneOperandOperations member:topOfStack])
        {
            if ([topOfStack isEqualToString:@"+/-"])
                description = [NSMutableString stringWithFormat:@"-(%@)",
                               [self descriptionOfStack:stack]];
            else
                description = [NSMutableString stringWithFormat:@"%@(%@)",
                               topOfStack,[self descriptionOfStack:stack]];
        }
        else if ([topOfStack isEqualToString:@"pi"])
            description = [NSMutableString stringWithString:@"pi"];
        
    }
    else if ([variableNames member:topOfStack])
        description = [topOfStack copy];
    else
        description = [[NSMutableString alloc] initWithString:@""];
    
    return description;
}

+ (BOOL)isOperation:(id)item
{
    if (![item isKindOfClass:[NSString class]])
        return NO;
    
    NSSet *operations = [NSSet setWithObjects:@"+",@"-",@"/",@"*",@"sqrt",@"+/-",@"cos",@"sin", @"pi",nil];
    
    if ([operations member:item])
        return YES;
    else
        return NO;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
        for(int i = 0; i < [stack count]; i++){
            id item = [stack objectAtIndex:i];
            if([item isKindOfClass:[NSString class]]){
                NSString *key = item;
                if(![key isEqualToString:@"+"] &&
                   ![key isEqualToString:@"-"] &&
                   ![key isEqualToString:@"*"] &&
                   ![key isEqualToString:@"/"] &&
                   ![key isEqualToString:@"sin"] &&
                   ![key isEqualToString:@"cos"] &&
                   ![key isEqualToString:@"sqrt"] &&
                   ![key isEqualToString:@"pi"]){
                    NSNumber *value = [variableValues valueForKey:key];
                    if(!value) value = [NSNumber numberWithDouble:0];
                    [stack replaceObjectAtIndex:i withObject:value];
                }
            }
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]){
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        }
        else if ([operation isEqualToString:@"*"]){
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }
        else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffProgramStack:stack]);
        }
        else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffProgramStack:stack]);
        }
        else if([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"pi"]){
            result = M_PI;
        }
    }
    
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSSet *variableNames = [NSMutableSet setWithObjects:@"x",@"y",@"z",nil];
    NSMutableSet *result = [[NSMutableSet alloc] init];
    
    for (short int i = 0; i < [program count]; i++){
        if ([variableNames member:[program objectAtIndex:i]]){
            [result addObject:[program objectAtIndex:i]];
        }
    }
    
    return [result copy];
}



@end








