//
//  CHViewController.m
//  ChooseHolden
//
//  Created by Ricky Liu on 16/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHViewController.h"
#import "CHFuelViewController.h"
#import "CHBudgetViewController.h"
#import "CHPerformanceViewController.h"
#import "CHStyleViewController.h"
#import "CHSeatViewController.h"
#import "CHVehicleFilterViewController.h"
#import "CHOptionDelegate.h"
#import "CHUserOption.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

@interface CHViewController () <CHOptionDelegate>

@end

@implementation CHViewController{
    CHFuelViewController * fuelViewController;
    CHBudgetViewController * budgetViewController;
    CHPerformanceViewController * performanceViewController;
    CHStyleViewController * styleViewController;
    CHSeatViewController * seatViewController;
    CHVehicleFilterViewController *vehicleFilterViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect tabViewFrame = CGRectMake(0, 150, 768, 250);
    fuelViewController = [[CHFuelViewController alloc] initWithNibName:@"CHFuelViewController" bundle:nil];
    fuelViewController.view.frame = tabViewFrame;
    fuelViewController.delegate = self;
    
    budgetViewController = [[CHBudgetViewController alloc] initWithNibName:@"CHBudgetViewController" bundle:nil];
    budgetViewController.view.frame = tabViewFrame;
    budgetViewController.delegate = self;
    
    performanceViewController = [[CHPerformanceViewController alloc] initWithNibName:@"CHPerformanceViewController" bundle:nil];
    performanceViewController.view.frame = tabViewFrame;
    performanceViewController.delegate = self;
    
    styleViewController = [[CHStyleViewController alloc] initWithNibName:@"CHStyleViewController" bundle:nil];
    styleViewController.view.frame = tabViewFrame;
    styleViewController.delegate = self;
    
    seatViewController = [[CHSeatViewController alloc] initWithNibName:@"CHSeatViewController" bundle:nil];
    seatViewController.view.frame = tabViewFrame;
    seatViewController.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(150, 200);
    [layout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    vehicleFilterViewController = [[CHVehicleFilterViewController alloc] initWithCollectionViewLayout:layout];
    vehicleFilterViewController.view.backgroundColor = [UIColor clearColor];
    vehicleFilterViewController.view.frame = CGRectMake(0, 290, 768, 700);
    
    [self.view addSubview:seatViewController.view];
    [self.view addSubview:styleViewController.view];
    [self.view addSubview:performanceViewController.view];
    [self.view addSubview:budgetViewController.view];
    [self.view addSubview:fuelViewController.view];
    [self.view addSubview:vehicleFilterViewController.view];
    [self onOptionChanged:self];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[self tryJSValue];
}

/*-(void) tryJSValue
{
    NSError *error;
    NSString *htmlContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://developers.google.com/speed/libraries/devguide"] encoding:NSUTF8StringEncoding error:&error];
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlContent];
    NSLog(@"%@", document.Query(@"body").find(@""));
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnFuelButtonTapped:(id)sender {
    [self showViewByViewController:fuelViewController];
}

- (IBAction)OnBudgetButtonTapped:(id)sender {
    [self showViewByViewController:budgetViewController];
}

- (IBAction)OnPerformanceButtonTapped:(id)sender {
    [self showViewByViewController:performanceViewController];
}

- (IBAction)OnSafetyButtonTapped:(id)sender {
    [self showViewByViewController:styleViewController];
}

- (IBAction)OnSeatButtonTapped:(id)sender {
    [self showViewByViewController:seatViewController];
}

- (void) showViewByViewController: (UIViewController*) viewController{
    [fuelViewController.view setHidden:viewController!=fuelViewController];
    [budgetViewController.view setHidden:viewController!=budgetViewController];
    [performanceViewController.view setHidden:viewController!=performanceViewController];
    [styleViewController.view setHidden:viewController!=styleViewController];
    [seatViewController.view setHidden:viewController!=seatViewController];
}

-(void) onOptionChanged:(id)UIViewController{
    CHUserOption *userOption = [CHUserOption alloc];
    userOption.isPetrol = fuelViewController.checkPetrol.checked;
    userOption.isDiesel = fuelViewController.checkDiesel.checked;
    userOption.isLPG = fuelViewController.checkLPG.checked;
    
    userOption.minFuelConsumption = [NSNumber numberWithFloat: fuelViewController.fuelConsumptionSlider.lowerValue];
    userOption.maxFuelConsumption = [NSNumber numberWithFloat: fuelViewController.fuelConsumptionSlider.upperValue];
    userOption.minCost = [NSNumber numberWithInt: budgetViewController.budgetSlider.lowerValue];
    userOption.maxCost = [NSNumber numberWithInt: budgetViewController.budgetSlider.upperValue];
    
    userOption.is2WD = performanceViewController.check2WD.checked;
    userOption.isAWD = performanceViewController.checkAWD.checked;
    userOption.is4WD = performanceViewController.check4WD.checked;
    userOption.isManual = performanceViewController.checkManual.checked;
    userOption.isAutomatic = performanceViewController.checkAutomatic.checked;
    userOption.maxPower = [NSNumber numberWithFloat:performanceViewController.sliderPower.value];
    userOption.maxTowingCapacity = [NSNumber numberWithFloat:performanceViewController.sliderPower.value];
    
    userOption.maxANCAPRating = [NSNumber numberWithFloat:[styleViewController.ctrlANCAPRating titleForSegmentAtIndex:styleViewController.ctrlANCAPRating.selectedSegmentIndex].floatValue];
    userOption.maxBootCapacity = [NSNumber numberWithFloat:styleViewController.ctrlBootCapacity.value];
    
    userOption.maxAdultSeats = [NSNumber numberWithFloat:[seatViewController.ctrlAdultSeats titleForSegmentAtIndex:seatViewController.ctrlAdultSeats.selectedSegmentIndex].floatValue];
    [vehicleFilterViewController refreshWithUserOption:userOption];
}

@end
