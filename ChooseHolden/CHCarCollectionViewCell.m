//
//  CHCarCollectionViewCell.m
//  ChooseHolden
//
//  Created by Ricky Liu on 19/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHCarCollectionViewCell.h"

@implementation CHCarCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vehicleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 130, 20)];
        self.vehicleNameLabel.textColor = [UIColor blackColor];
        self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 130, 100)];
        self.modelCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, 150, 130, 20)];
        self.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.vehicleNameLabel];
        [self.contentView addSubview:self.thumbnailView];
        [self.contentView addSubview:self.modelCountLabel];
        self.qualifiedModels = [NSMutableArray array];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSInteger count = 1;
    NSLog(@"%d", count);
}*/

@end
