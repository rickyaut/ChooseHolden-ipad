//
//  CHAppDelegate.h
//  ChooseHolden
//
//  Created by Ricky Liu on 16/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHViewController;

@interface CHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) CHViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
