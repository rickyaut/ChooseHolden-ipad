//
//  CHCarCollectionViewCell.h
//  ChooseHolden
//
//  Created by Ricky Liu on 19/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCarCollectionViewCell : UICollectionViewCell
@property(strong, nonatomic) UILabel* vehicleNameLabel;
@property(strong, nonatomic) UIImageView* thumbnailView;
@property(strong, nonatomic) UILabel* modelCountLabel;
@property(strong, nonatomic) NSMutableArray* qualifiedModels;
@end
