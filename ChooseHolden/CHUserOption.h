//
//  CHUserOption.h
//  ChooseHolden
//
//  Created by Ricky Liu on 24/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHUserOption : NSObject
@property(assign, nonatomic) BOOL isPetrol;
@property(assign, nonatomic) BOOL isDiesel;
@property(assign, nonatomic) BOOL isLPG;
@property(strong, nonatomic) NSNumber *minFuelConsumption;
@property(strong, nonatomic) NSNumber *maxFuelConsumption;

@property(strong, nonatomic) NSNumber *minCost;
@property(strong, nonatomic) NSNumber *maxCost;

@property(assign, nonatomic) BOOL isManual;
@property(assign, nonatomic) BOOL isAutomatic;
@property(assign, nonatomic) BOOL is2WD;
@property(assign, nonatomic) BOOL isAWD;
@property(assign, nonatomic) BOOL is4WD;
@property(strong, nonatomic) NSNumber *maxPower;
@property(strong, nonatomic) NSNumber *maxTowingCapacity;

@property(assign, nonatomic) NSNumber *maxAdultSeats;
@property(assign, nonatomic) NSNumber *maxBootCapacity;
@property(assign, nonatomic) NSNumber *maxANCAPRating;

@end
