//
//  CHColorModelViewController.h
//  ChooseHolden
//
//  Created by Ricky Liu on 23/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHColorModelViewController : UIViewController
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) NSDictionary *modelData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil vehicleName:(NSString*) vehicleName modelData: (NSDictionary*) modelData;
-(void) updateModelImageWith:(UIImage*) image imageTitle:(NSString*) imageTitle;
@end

@interface CHSwatchTableViewController: UITableViewController
@property(strong, nonatomic) CHColorModelViewController *parentViewController;
-(id) initWithColourImages:(NSArray*) colourImages parentViewController:(UIViewController*) parentViewController;
@end

@interface CHSpecificationTableViewController: UITableViewController
@property(strong, nonatomic) NSIndexPath *selectedSpecificationIndex;
-(id) initWithSpecificationsData:(NSArray*) specificationsData;
@end

@interface CHHighlightsTableViewController: UITableViewController
-(id) initWithHighlightsData:(NSArray*) highlightsData;
@end

@interface CHOfferCollectionViewCell : UICollectionViewCell
@property(strong, nonatomic) UIImageView *offerVehicleImageView;
@property(strong, nonatomic) UILabel *offerPriceLabel;
@end

@interface CHOfferCollectionViewController : UICollectionViewController

-(id) initWithCollectionViewLayout:(UICollectionViewLayout *)layout offersData:(NSArray*) offersData;

@end