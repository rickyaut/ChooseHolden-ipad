//
//  CHStyleViewController.m
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHStyleViewController.h"

@interface CHStyleViewController ()

@end

@implementation CHStyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (IBAction)onANCAPChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}

- (IBAction)onBootCapacityChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onOptionChanged:)]) {
        [self.delegate onOptionChanged:self];
    }
}
@end
