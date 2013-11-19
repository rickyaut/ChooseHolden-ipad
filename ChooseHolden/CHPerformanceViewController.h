//
//  CHPerformanceViewController.h
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CHCheckBox.h"
#import "CHOptionDelegate.h"

@interface CHPerformanceViewController : UIViewController
@property (strong, nonatomic) CHCheckBox *checkManual;
@property (strong, nonatomic) CHCheckBox *checkAutomatic;
@property (strong, nonatomic) CHCheckBox *check2WD;
@property (strong, nonatomic) CHCheckBox *checkAWD;
@property (strong, nonatomic) CHCheckBox *check4WD;
@property (weak, nonatomic) IBOutlet UISlider *sliderPower;
@property (weak, nonatomic) IBOutlet UISlider *sliderTowingCapacity;
@property (weak, nonatomic) id<CHOptionDelegate> delegate;
- (IBAction)onSliderPowerChanged:(id)sender;
- (IBAction)onTowingCapacityChanged:(id)sender;

@end
