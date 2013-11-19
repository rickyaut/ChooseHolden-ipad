//
//  CHVehicleFilterViewController.h
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHUserOption.h"

@interface CHVehicleFilterViewController : UICollectionViewController

-(void) refreshWithUserOption:(CHUserOption*) userOption;
@end
