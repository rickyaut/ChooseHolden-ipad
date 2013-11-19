//
//  CHVehicleFilterViewController.m
//  ChooseHolden
//
//  Created by Ricky Liu on 17/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHVehicleFilterViewController.h"
#import "CHCarCollectionViewCell.h"
#import "XMLReader.h"
#import "CHColorModelViewController.h"
#import "Global.h"
#import "UIImageView+AFNetworking.h"


@interface CHVehicleFilterViewController () <UIActionSheetDelegate>

@end

@implementation CHVehicleFilterViewController{
    NSDictionary* helpmechooseData;
    
}

-(id) initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    [self.collectionView registerClass:[CHCarCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    self.collectionView.backgroundColor= [UIColor whiteColor];

    NSError *error;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"/holden-model-specifications"
                                                     ofType:@"json"];
    NSArray *modelSpecs = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:&error];

    NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"/helpmechoose" ofType:@"xml"]];
    helpmechooseData = [XMLReader dictionaryForXMLData:data error:&error];
    NSArray *vehicles = [helpmechooseData mutableArrayValueForKeyPath:@"HelpMeChoose.Vehicles.Vehicle"];
    for (NSDictionary *vehicle in vehicles) {
        NSObject * modelOrModelList = [vehicle valueForKeyPath:@"Models.Model"];
        if(![modelOrModelList isKindOfClass: [NSArray class]]){
            NSArray *models = [[NSArray alloc] initWithObjects:modelOrModelList, nil];
            [[vehicle valueForKey:@"Models"] setObject:models forKey:@"Model"];
        }
    }
    
    NSMutableArray *models = [NSMutableArray array];
    for(NSArray *modelArray in [helpmechooseData mutableArrayValueForKeyPath:@"HelpMeChoose.Vehicles.Vehicle.Models.Model"] ){
        [models addObjectsFromArray:modelArray];
    }
    for (NSDictionary *model in models) {
        NSObject * highlightOrHighlightList = [model valueForKeyPath:@"Highlights.Highlight"];
        if(![highlightOrHighlightList isKindOfClass: [NSArray class]]){
            NSArray *hightlights = [[NSArray alloc] initWithObjects:highlightOrHighlightList, nil];
            [[model valueForKey:@"Highlights"] setObject:hightlights forKey:@"Highlight"];
        }
        NSObject * colourOrColourList = [model valueForKeyPath:@"Colours.Colour"];
        if(![colourOrColourList isKindOfClass: [NSArray class]]){
            NSArray *colours = [[NSArray alloc] initWithObjects:colourOrColourList, nil];
            [[model valueForKey:@"Colours"] setObject:colours forKey:@"Colour"];
        }
        NSObject * specOrSpecList = [model valueForKeyPath:@"Specifications.Specification"];
        if(![specOrSpecList isKindOfClass: [NSArray class]]){
            NSArray *specs = [[NSArray alloc] initWithObjects:specOrSpecList, nil];
            [[model valueForKey:@"Specifications"] setObject:specs forKey:@"Specification"];
        }
        for(NSMutableDictionary *specFromHelpmechoose in [model valueForKeyPath:@"Specifications.Specification"]){
            for(NSDictionary *matchedModelSpecs in modelSpecs){
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber *number1 = [matchedModelSpecs objectForKey:@"id"];
                NSNumber *number2 = [f numberFromString:[model valueForKey:@"Id"]];
                
                if([number1 isEqual:number2]){
                    for(NSDictionary *matchedSpec in [matchedModelSpecs valueForKey:@"specifications"]){
                        if([[matchedSpec valueForKey:@"name"] isEqual:[specFromHelpmechoose valueForKey:@"Name"]]){
                            [specFromHelpmechoose setValue:[matchedSpec valueForKey:@"id"] forKey:@"Id"];
                        }
                    }
                }
            }
            for (NSString *key in [specFromHelpmechoose allKeys]) {
                NSDictionary *value = [specFromHelpmechoose valueForKey:key];
                if([value isKindOfClass:[NSDictionary class]]){
                    if ( value == nil) {
                        [specFromHelpmechoose removeObjectForKey:key];
                    }else{
                        if([value count]==0 || ([value count] == 1 && [[value valueForKey:@"text"] isEqualToString: @""])){
                            [specFromHelpmechoose removeObjectForKey:key];
                        }
                    }
                }
            }
        }
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[helpmechooseData mutableArrayValueForKeyPath:@"HelpMeChoose.Vehicles.Vehicle"] count];
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak CHCarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    NSDictionary *vehicleData = [[helpmechooseData mutableArrayValueForKeyPath:@"HelpMeChoose.Vehicles.Vehicle"] objectAtIndex:indexPath.row];
    cell.vehicleNameLabel.text = [vehicleData objectForKey:@"Name"];
    NSString *thumbnailURLString = [vehicleData objectForKey:@"ThumbnailImage"];
    [cell.thumbnailView setImageWithURLRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:thumbnailURLString]]]
                              placeholderImage: nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           CGSize viewSize = cell.thumbnailView.frame.size;
                                           CGSize imageSize = image.size;
                                           CGFloat bestScale = fmin(viewSize.width/imageSize.width, viewSize.height/imageSize.height);
                                           CGSize bestSize = CGSizeMake(imageSize.width*bestScale, imageSize.height*bestScale);
                                           cell.thumbnailView.frame = CGRectMake(cell.thumbnailView.frame.origin.x, cell.thumbnailView.frame.origin.y, bestSize.width, bestSize.height);
                                           cell.thumbnailView.image = image;
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"fail to load image for: %@", [request URL]);
                                       }];
    NSArray *models = [vehicleData mutableArrayValueForKeyPath:@"Models.Model"];
    [cell.qualifiedModels addObjectsFromArray:models];
    cell.modelCountLabel.text = [NSString stringWithFormat:@"%d", [models count]];
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CHCarCollectionViewCell *cell = (CHCarCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *vehicleData = [[helpmechooseData mutableArrayValueForKeyPath:@"HelpMeChoose.Vehicles.Vehicle"] objectAtIndex:indexPath.row];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[[vehicleData valueForKey:@"Name"] stringByAppendingString:@" Models"] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSDictionary* modelData in cell.qualifiedModels) {
        [actionSheet addButtonWithTitle:[modelData valueForKey:@"Name"]];
    }
    [actionSheet showInView: cell];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex>=0){
        NSIndexPath *selectedIndexPath = (NSIndexPath*)([[self.collectionView indexPathsForSelectedItems] objectAtIndex:0]);
        NSDictionary *vehicleData = [[helpmechooseData mutableArrayValueForKeyPath:@"HelpMeChoose.Vehicles.Vehicle"] objectAtIndex:selectedIndexPath.row];
        NSDictionary *modelData = [[vehicleData valueForKeyPath:@"Models.Model"] objectAtIndex:buttonIndex ];
        CHColorModelViewController *modelViewController = [[CHColorModelViewController alloc] initWithNibName:@"CHColorModelViewController" bundle:nil vehicleName: [vehicleData valueForKey:@"Name"] modelData:modelData];
        [(UINavigationController*)([[UIApplication sharedApplication] keyWindow].rootViewController) pushViewController:modelViewController animated:YES];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    
}
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (void) refreshWithUserOption:(CHUserOption*)userOption{
    NSMutableArray *predicateArguments = [NSMutableArray array];
    NSString *predicateFormat = [self composePredicateFormatWithUserOption:userOption predicateArguments:predicateArguments];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat argumentArray: predicateArguments];
    NSArray* cellsPath = [self.collectionView indexPathsForVisibleItems];
    NSArray* vehiclesData = [helpmechooseData mutableArrayValueForKeyPath:@"HelpMeChoose.Vehicles.Vehicle"];
    for (NSIndexPath *cellPath in cellsPath) {
        CHCarCollectionViewCell *cell = (CHCarCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:cellPath];
        [cell.qualifiedModels removeAllObjects];
        NSDictionary *vehicleData = [vehiclesData objectAtIndex:cellPath.row];
        NSArray *modelsData = [vehicleData valueForKeyPath:@"Models.Model"];
        for(NSDictionary *modelData in modelsData){
            NSArray *specificationsData = [modelData valueForKeyPath:@"Specifications.Specification"];
            if ([[specificationsData filteredArrayUsingPredicate:predicate] count]>0) {
                [cell.qualifiedModels addObject:modelData];
            }
        }
        cell.modelCountLabel.text = [NSString stringWithFormat:@"%d / %d", [cell.qualifiedModels count], [modelsData count] ];
        
    }
}

- (NSString*) composePredicateFormatWithUserOption:(CHUserOption*) userOption predicateArguments: (NSMutableArray* )predicateArguments{
    NSString *predicateFormat = @"";
    
    //start of fuel type predicate
    predicateFormat = [predicateFormat stringByAppendingString:@"("];
    if(userOption.isPetrol){
        predicateFormat = [predicateFormat stringByAppendingString:@"FuelType.text=%@ "];
        [predicateArguments addObject:@"PETROL"];
    }else{
        predicateFormat = [predicateFormat stringByAppendingString:@"FALSEPREDICATE "];
    }
    if(userOption.isDiesel){
        predicateFormat = [predicateFormat stringByAppendingString:@"OR FuelType.text=%@ "];
        [predicateArguments addObject:@"DIESEL"];
    }else{
        predicateFormat = [predicateFormat stringByAppendingString:@"OR FALSEPREDICATE "];
    }
    if (userOption.isLPG){
        predicateFormat = [predicateFormat stringByAppendingString:@"OR FuelType.text=%@ "];
        [predicateArguments addObject:@"LPG"];
    }else{
        predicateFormat = [predicateFormat stringByAppendingString:@"OR FALSEPREDICATE "];
    }
    predicateFormat = [predicateFormat stringByAppendingString:@")"];
    //end of fuel type predicate
    
    //start of fuel consumption predicate
    predicateFormat = [predicateFormat stringByAppendingString:@"AND "];
    predicateFormat = [predicateFormat stringByAppendingString:@"FuelConsumption.text.floatValue between %@ "];
    [predicateArguments addObject:@[userOption.minFuelConsumption, userOption.maxFuelConsumption]];
    //end of fuel consumption predicate
    
    //start of budget predicate
    predicateFormat = [predicateFormat stringByAppendingString:@"AND "];
    predicateFormat = [predicateFormat stringByAppendingString:@"Price.text.floatValue between %@ "];
    [predicateArguments addObject:@[userOption.minCost, userOption.maxCost]];
    //end of budget predicate
    
    //start of transmission predicate
    predicateFormat = [predicateFormat stringByAppendingString:@"AND ("];
    if(userOption.isManual){
        predicateFormat = [predicateFormat stringByAppendingString:@"Transmission.text=%@ "];
        [predicateArguments addObject:@"Manual"];
    }else{
        predicateFormat = [predicateFormat stringByAppendingString:@"FALSEPREDICATE "];
    }
    if (userOption.isAutomatic){
        predicateFormat = [predicateFormat stringByAppendingString:@"OR Transmission.text=%@ "];
        [predicateArguments addObject:@"Automatic"];
    }else{
        predicateFormat = [predicateFormat stringByAppendingString:@"OR FALSEPREDICATE "];
    }
    predicateFormat = [predicateFormat stringByAppendingString:@")"];
    //end of transmission predicate
    
    //start of drive train predicate
    predicateFormat = [predicateFormat stringByAppendingString:@"AND ("];
    if(userOption.is2WD){
        predicateFormat = [predicateFormat stringByAppendingString:@"DriveTrain.text=%@ "];
        [predicateArguments addObject:@"2WD"];
    }else{
        predicateFormat = [predicateFormat stringByAppendingString:@"FALSEPREDICATE "];
    }
    if (userOption.isAWD){
        predicateFormat = [predicateFormat stringByAppendingString:@"OR DriveTrain.text=%@ "];
        [predicateArguments addObject:@"AWD"];
    }else{
        predicateFormat = [predicateFormat stringByAppendingString:@"OR FALSEPREDICATE "];
    }
    if (userOption.is4WD){
        predicateFormat = [predicateFormat stringByAppendingString:@"OR DriveTrain.text=%@ "];
        [predicateArguments addObject:@"4WD"];
    }else{
        predicateFormat = [predicateFormat stringByAppendingString:@"OR FALSEPREDICATE "];
    }
    predicateFormat = [predicateFormat stringByAppendingString:@")"];
    //end of drive train predicate
    
    //start of max power predicate
    if(userOption.maxPower){
        predicateFormat = [predicateFormat stringByAppendingString:@"AND "];
        predicateFormat = [predicateFormat stringByAppendingString:@"Power.text.floatValue >= %@ "];
        [predicateArguments addObject:userOption.maxPower];
    }
    //end of max power predicate
    
    //start of max towing capacity predicate
    if(userOption.maxTowingCapacity){
        predicateFormat = [predicateFormat stringByAppendingString:@"AND "];
        predicateFormat = [predicateFormat stringByAppendingString:@"TowingCapacity.text.floatValue >= %@ "];
        [predicateArguments addObject:userOption.maxTowingCapacity];
    }
    //end of max towing capacity predicate
    
    //start of ANCAP predicate
    if(userOption.maxANCAPRating>0){
        predicateFormat = [predicateFormat stringByAppendingString:@"AND "];
        predicateFormat = [predicateFormat stringByAppendingString:@"AncapRating.text.floatValue >= %@ "];
        [predicateArguments addObject:userOption.maxANCAPRating];
    }
    //end of ANCAP predicate
    
    //start of Boot Capacity predicate
    if(userOption.maxBootCapacity){
        predicateFormat = [predicateFormat stringByAppendingString:@"AND "];
        predicateFormat = [predicateFormat stringByAppendingString:@"BootCapacity.text.floatValue >= %@ "];
        [predicateArguments addObject:userOption.maxBootCapacity];
    }
    //end of Boot Capacity predicate
    
    //start of adult seat predicate
    if(userOption.maxAdultSeats>0){
        predicateFormat = [predicateFormat stringByAppendingString:@"AND "];
        predicateFormat = [predicateFormat stringByAppendingString:@"AdultSeats.text.floatValue >= %@ "];
        [predicateArguments addObject:userOption.maxAdultSeats];
    }
    //end of adult seat predicate
    return predicateFormat;
}
@end
