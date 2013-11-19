//
//  CHStyleViewController.h
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHOptionDelegate.h"

@interface CHStyleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *ctrlBootCapacity;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ctrlANCAPRating;
- (IBAction)onANCAPChanged:(id)sender;
- (IBAction)onBootCapacityChanged:(id)sender;
@property (weak, nonatomic) id<CHOptionDelegate> delegate;

@end
