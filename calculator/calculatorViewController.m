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
        self.historyDisplay.text = [NSString stringWithFormat:@"%@%@%@",self.historyDisplay.text,@" ",self.display.text];
    }
    else
    {
        self.historyDisplay.text = self.display.text;
    }
    if ([self.display.text isEqualToString:@"π"])
    {
        [self.calBrain pushOperand:3.14];
    }
    else if ([self.display.text isEqualToString:@"e"])
    {
        [self.calBrain pushOperand:2.72];
    }
    else
    {
        [self.calBrain pushOperand:[self.display.text doubleValue]];
    }
    self.isInTheMiddleOfEnteringNumber = NO;
}

- (IBAction)clearButton
{
    [self.calBrain clearHistory];
    self.historyDisplay.text = @"";
    self.display.text = @"0";
}

-(IBAction)undoButton
{
    
}
@end
