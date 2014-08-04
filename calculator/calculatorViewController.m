//
//  calculatorViewController.m
//  calculator
//
//  Created by pony ma on 4/23/14.
//  Copyright (c) 2014 pony ma. All rights reserved.
//

#import "calculatorViewController.h"
#import "calculatorBrain.h"

@interface calculatorViewController ()
@property (nonatomic) BOOL isInTheMiddleOfEnteringNumber;
@property (nonatomic, strong)calculatorBrain *calBrain;
@end

@implementation calculatorViewController
double_t x;
double_t a;
double_t b;
-(calculatorBrain *)calBrain
{
    if (!_calBrain)
    {
        _calBrain = [[calculatorBrain alloc]init];
    }
    return _calBrain; 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    // change sign function if it's an negative number reverse it，otherwise do the same thing.
    if ([digit isEqualToString:@"+/-"]) {
        if ([[self.display.text substringToIndex:1] isEqualToString:@"-"]) {
            self.display.text = [self.display.text substringFromIndex:1];
        }
        else
        {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    }
    else
    {
        if (self.isInTheMiddleOfEnteringNumber)
        {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
        else
        {
            self.display.text = digit;
            self.isInTheMiddleOfEnteringNumber = YES;
        }
    }
}


- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.isInTheMiddleOfEnteringNumber)
    {
        [self enterPressed];
    }
    NSString *operater = sender.currentTitle;
    if ([operater isEqualToString:@"+"] || [operater isEqualToString:@"-"] ||
        [operater isEqualToString:@"/"] || [operater isEqualToString:@"*"]) {
        
        self.historyDisplay.text = [self.historyDisplay.text stringByReplacingOccurrencesOfString:@" " withString:operater];
    }
    else if ([operater isEqualToString:@"sqrt"] || [operater isEqualToString:@"sin"] ||
             [operater isEqualToString:@"cos"] || [operater isEqualToString:@"log"])
    {
        self.historyDisplay.text = [NSString stringWithFormat:@"%@%@%@%@",operater,@"(",self.historyDisplay.text,@")"];
    }
    
//    self.historyDisplay.text = [NSString stringWithFormat:@"%@%@%@",self.historyDisplay.text,@" ",operater];
    double result = [self.calBrain performOperation:sender.currentTitle];
    
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed
{
    if (![self.historyDisplay.text isEqualToString:@""])
    {
        //record all operate histroy, for better use this part should be outside and be another method, however I put here for convenience.
        self.historyDisplay.text = [NSString stringWithFormat:@"%@%@%@",self.historyDisplay.text,@" ",self.display.text];
    }
    else
    {
        self.historyDisplay.text = self.display.text;
    }
    //switch the symbol to double numbers and if its not an symbol just use the value.
    if ([self.display.text isEqualToString:@"π"])
    {
        [self.calBrain pushOperand:3.14];
    }
    else if ([self.display.text isEqualToString:@"e"])
    {
        [self.calBrain pushOperand:2.72];
    }
    else if ([self.display.text isEqualToString:@"x"])
    {
        [self.calBrain pushOperand:x];
    }
    else if ([self.display.text isEqualToString:@"a"])
    {
        [self.calBrain pushOperand:a];
    }
    else if ([self.display.text isEqualToString:@"b"])
    {
        [self.calBrain pushOperand:b];
    }
    else
    {
        [self.calBrain pushOperand:[self.display.text doubleValue]];
    }
    self.isInTheMiddleOfEnteringNumber = NO;
}

//set an value to x a or b
- (IBAction)setValue:(UIButton *)sender {
    NSString *var = sender.currentTitle;
    if ([var isEqualToString:@"t1"]) {
        x = [self.display.text doubleValue];
        NSLog(@"%f",x);
        self.xValue.text = [NSString stringWithFormat:@"%@%f",@"x=",x];
    }
    else if ([var isEqualToString:@"t2"]) {
        a = [self.display.text doubleValue];
        self.aValue.text = [NSString stringWithFormat:@"%@%f",@"a=",a];
    }
    else if ([var isEqualToString:@"t3"]) {
        b = [self.display.text doubleValue];
        self.bValue.text = [NSString stringWithFormat:@"%@%f",@"b=",b];
    }
}

//clear the the display and all calculate history.
- (IBAction)clearButton
{
    [self.calBrain clearHistory];
    self.historyDisplay.text = @"";
    self.display.text = @"";
}

//if user is still entering one number undo button will remove the last single character they enter.
-(IBAction)undoButton
{
    if(self.isInTheMiddleOfEnteringNumber)
    {
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
    }
}
@end
