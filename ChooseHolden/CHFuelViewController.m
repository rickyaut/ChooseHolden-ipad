//
//  CHFuelViewController.m
//  ChooseHolden
//
//  Created by Ricky Liu on 16/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHFuelViewController.h"
#import "CHCheckBox.h"
#include "CERangeSlider.h"

@interface CHFuelViewController ()

@end

@implementation CHFuelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _checkPetrol = [[CHCheckBox alloc] initWithFrame:CGRectMake(10, 10, 90, 40) label: @"Petrol" initialStatus:YES];
        [_checkPetrol addTarget:self action:@selector(onFuelTypeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_checkPetrol];
        _checkDiesel = [[CHCheckBox alloc] initWithFrame:CGRectMake(100, 10, 80, 40) label: @"Diesel" initialStatus:YES];
        [_checkDiesel addTarget:self action:@selector(onFuelTypeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_checkDiesel];
        _checkLPG = [[CHCheckBox alloc] initWithFrame:CGRectMake(180, 10, 50, 40) label: @"LPG" initialStatus:YES];
        [_checkLPG addTarget:self action:@selector(onFuelTypeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_checkLPG];
        
        _fuelConsumptionSlider = [[CERangeSlider alloc] initWithFrame:CGRectMake(10, 60, 500, 50) minimumValue: 5 maximumValue: 20 lowerValue: 5 upperValue: 20];
        [_fuelConsumptionSlider addTarget:self action:@selector(onFuelConsumptionRangeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_fuelConsumptionSlider];
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

- (void)onFuelTypeChanged:(id)control
{
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}

- (void)onFuelConsumptionRangeChanged:(id)control
{
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}

@end
