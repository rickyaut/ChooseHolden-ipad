//
//  CHSeatViewController.h
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHOptionDelegate.h"

@interface CHSeatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *ctrlAdultSeats;
- (IBAction)onAdultSeatsChanged:(id)sender;

@property (weak, nonatomic) id<CHOptionDelegate> delegate;
@end
