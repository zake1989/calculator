//
//  calculatorViewController.h
//  calculator
//
//  Created by pony ma on 4/23/14.
//  Copyright (c) 2014 pony ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;
@property (weak, nonatomic) IBOutlet UILabel *xValue;
@property (weak, nonatomic) IBOutlet UILabel *aValue;
@property (weak, nonatomic) IBOutlet UILabel *bValue;
- (IBAction)digitPressed:(id)sender;
- (IBAction)operationPressed:(id)sender;
- (IBAction)setValue:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)clearButton;
- (IBAction)undoButton;

@end
