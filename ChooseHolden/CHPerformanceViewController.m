//
//  CHPerformanceViewController.m
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHPerformanceViewController.h"

@interface CHPerformanceViewController ()

@end

@implementation CHPerformanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _checkManual = [[CHCheckBox alloc] initWithFrame:CGRectMake(10, 45, 120, 30) label: @"Manual" initialStatus:YES];
        [_checkManual addTarget:self action:@selector(onTransmissionChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_checkManual];
        _checkAutomatic = [[CHCheckBox alloc] initWithFrame:CGRectMake(10, 90, 120, 30) label: @"Automatic" initialStatus:YES];
        [_checkAutomatic addTarget:self action:@selector(onTransmissionChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_checkAutomatic];
        _check2WD = [[CHCheckBox alloc] initWithFrame:CGRectMake(140, 45, 70, 30) label: @"2WD" initialStatus:YES];
        [_check2WD addTarget:self action:@selector(onDriveTrainChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_check2WD];
        _checkAWD = [[CHCheckBox alloc] initWithFrame:CGRectMake(230, 45, 70, 30) label: @"AWD" initialStatus:YES];
        [_checkAWD addTarget:self action:@selector(onDriveTrainChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_checkAWD];
        _check4WD = [[CHCheckBox alloc] initWithFrame:CGRectMake(140, 90, 70, 30) label: @"4WD" initialStatus:YES];
        [_check4WD addTarget:self action:@selector(onDriveTrainChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_check4WD];
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

- (IBAction)onSliderPowerChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}

- (IBAction)onTowingCapacityChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}

- (void)onTransmissionChanged:(id)control
{
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}

- (void)onDriveTrainChanged:(id)control
{
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}

@end
