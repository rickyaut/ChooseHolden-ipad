//
//  CHBudgetViewController.h
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CERangeSlider.h"
#import "CHOptionDelegate.h"

@interface CHBudgetViewController : UIViewController

@property (strong, nonatomic) CERangeSlider *budgetSlider;
@property (weak, nonatomic) id<CHOptionDelegate> delegate;

@end
