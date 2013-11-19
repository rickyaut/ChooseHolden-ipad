//
//  CHCheckBox.h
//  ChooseHolden
//
//  Created by Ricky Liu on 23/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCheckBox : UIControl
-(id)initWithFrame:(CGRect)frame label: (NSString*) label initialStatus: (BOOL) initialStatus;
-(id)initWithFrame:(CGRect) frame label: (NSString*) label initialStatus: (BOOL) initialStatus statusOnImageName: (NSString*) statusOnImageName statusOffImageName: (NSString*) statusOffImageName;
@property(assign, nonatomic) BOOL checked;
@end
