//
//  CHBudgetViewController.m
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHBudgetViewController.h"

@interface CHBudgetViewController ()

@end

@implementation CHBudgetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _budgetSlider = [[CERangeSlider alloc] initWithFrame:CGRectMake(10, 50, 500, 50) minimumValue:10000 maximumValue:100000 lowerValue:10000 upperValue:100000];
        [_budgetSlider addTarget:self action:@selector(onBudgetRangeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_budgetSlider];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBudgetRangeChanged:(id)control
{
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}

@end
