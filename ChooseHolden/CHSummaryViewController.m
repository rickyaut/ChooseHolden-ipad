//
//  CHSummaryViewController.m
//  ChooseHolden
//
//  Created by Ricky Liu on 5/11/2013.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHSummaryViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CHSummaryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (weak, nonatomic) IBOutlet UILabel *lblModelName;
@property (weak, nonatomic) IBOutlet UILabel *lblColourName;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecificationName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *modelImageView;

@end

@implementation CHSummaryViewController{
    NSString *vehicleName;
    NSString *modelName;
    NSString *colourName;
    NSString *modelImageURL;
    NSString *specificationName;
    NSString *price;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil vehicleName:(NSString*) vehicleName modelName:(NSString*) modelName colourName:(NSString*) colourName modelImageURL:(NSString*) modelImageURL specificationName:(NSString*) specificationName price:(NSString*) price
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Summary";
        self->vehicleName = vehicleName;
        self->modelName = modelName;
        self->colourName = colourName;
        self->modelImageURL = modelImageURL;
        self->specificationName = specificationName;
        self->price = price;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lblVehicleName.text = self->vehicleName;
    self.lblModelName.text = modelName;
    self.lblColourName.text = colourName;
    self.lblSpecificationName.text = specificationName;
    self.lblPrice.text = price;

    [self.modelImageView setImageWithURLRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:modelImageURL]]
                              placeholderImage: nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           CGSize imageSize = image.size;
                                           self.modelImageView.frame = CGRectMake(self.modelImageView.frame.origin.x, self.modelImageView.frame.origin.y, imageSize.width, imageSize.height);
                                           self.modelImageView.image = image;
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"fail to load image for: %@", [request URL]);
                                       }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
