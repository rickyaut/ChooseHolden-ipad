//
//  CHFuelViewController.h
//  ChooseHolden
//
//  Created by Ricky Liu on 16/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CHOptionDelegate.h"
#import "CHCheckBox.h"
#import "CERangeSlider.h"

@interface CHFuelViewController : UIViewController
@property (strong, nonatomic) CHCheckBox *checkPetrol;
@property (strong, nonatomic) CHCheckBox *checkDiesel;
@property (strong, nonatomic) CHCheckBox *checkLPG;
@property (strong, nonatomic) CERangeSlider *fuelConsumptionSlider;
@property (weak, nonatomic) id<CHOptionDelegate> delegate;

@end
