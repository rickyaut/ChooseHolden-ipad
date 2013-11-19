//
//  CHColorModelViewController.m
//  ChooseHolden
//
//  Created by Ricky Liu on 23/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHColorModelViewController.h"
#import "Global.h"
#import "CHSummaryViewController.h"
#import "UIImageView+AFNetworking.h"
#import <AFHTTPRequestOperation.h>

@interface CHColorModelViewController ()

@end

@implementation CHColorModelViewController{
    CHSwatchTableViewController *swatchTableViewController;
    CHSpecificationTableViewController *specificationTableViewController;
    CHOfferCollectionViewController *offerViewController;
    CHHighlightsTableViewController *highlightsTableViewController;
    NSString *vehicleName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil vehicleName: @"" modelData:[NSDictionary dictionary]];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil vehicleName:(NSString*) vehicleName modelData: (NSDictionary*) modelData{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modelData = modelData;
        self->vehicleName = vehicleName;
        self.title = [modelData valueForKey:@"Name"];
        NSArray *colourImages = [self findValidColourImages];
        NSArray *specificationsData = [modelData valueForKeyPath:@"Specifications.Specification"];
        self.imageView = [[UIImageView alloc] init];
        if([colourImages count] >0){
            NSString* imageURLString = [BASEURL stringByAppendingString:[[colourImages objectAtIndex:0] valueForKey:@"ModelImage"]];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: imageURLString]]];
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(70, 0, image.size.width, image.size.height);
            [self.view addSubview:self.imageView];
            
            highlightsTableViewController = [[CHHighlightsTableViewController alloc] initWithHighlightsData:[modelData valueForKeyPath:@"Highlights.Highlight"]];
            highlightsTableViewController.view.frame = CGRectMake(150, 40, 550,200);
            highlightsTableViewController.view.hidden = YES;
            [self.view addSubview: highlightsTableViewController.view];
            
            UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
            [self.view addGestureRecognizer:gestureRecognizer];

            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, image.size.height+30, image.size.width, 30)];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.text = [[[modelData valueForKey:@"Name"] stringByAppendingString:@" in "] stringByAppendingString:[[colourImages objectAtIndex:0] valueForKey:@"Name"]];
            [self.view addSubview:self.titleLabel];
        }
        
        swatchTableViewController = [[CHSwatchTableViewController alloc] initWithColourImages: colourImages parentViewController: self];
        CGRect rect;
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        switch (orientation) {
            //case UIDeviceOrientationLandscapeLeft:
            //case UIDeviceOrientationLandscapeRight:
            //    rect = CGRectMake(40, 40, 50, 50);
            //    break;
            default:
                rect = CGRectMake(40, 40, 50, 350);
                break;
        }
        swatchTableViewController.view.frame = rect;
        [self.view addSubview: swatchTableViewController.view];

        specificationTableViewController = [[CHSpecificationTableViewController alloc] initWithSpecificationsData:specificationsData];
        specificationTableViewController.view.frame = CGRectMake(40, 350, 550, 300);
        [self.view addSubview: specificationTableViewController.view];
        
        /*offer collection*/
        NSError *error;
        NSString *offersString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.holden.com.au/api/1.0/offersbyregionid?regionId=1236970274003"] encoding:NSASCIIStringEncoding error:&error];
        
        NSArray *offers = [NSJSONSerialization JSONObjectWithData:[offersString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        for(NSDictionary *offersForModel in offers){
            if([[offersForModel valueForKey:@"vehicleGroupTitle"] isEqualToString: vehicleName]){
                UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc] init];
                layout3.itemSize = CGSizeMake(200, 200);
                [layout3 setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
                offerViewController = [[CHOfferCollectionViewController alloc] initWithCollectionViewLayout:layout3 offersData: [offersForModel valueForKey:@"offers"]];
                offerViewController.collectionView.backgroundColor = [UIColor whiteColor];
                offerViewController.view.frame = CGRectMake(30, 650, 210*[[offersForModel valueForKey:@"offers"] count], 200);
                [self.view addSubview:offerViewController.view];
            }
        }
        
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(showSummary:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    /*UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please enter postcode!" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*) findValidColourImages{
    NSMutableArray *colourImages = [NSMutableArray array];
    for (NSDictionary *colourImage in [self.modelData valueForKeyPath:@"Colours.Colour"]) {
        if([colourImage valueForKey:@"ModelImage"] && [colourImage valueForKey:@"SwatchImage"] &&[colourImage valueForKey:@"Name"]){
            [colourImages addObject:colourImage];
        }
    }
    return colourImages;
}

-(void) updateModelImageWith:(UIImage*) image imageTitle:(NSString *)imageTitle{
    self.imageView.image = image;
    self.titleLabel.text = imageTitle;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    NSLog(@"%d, %@", buttonIndex, alertTextField.text);
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSLog(@"current orientation: %d", orientation);
}

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    BOOL imageStatus = self.imageView.hidden;
    self.imageView.hidden=!imageStatus;
    highlightsTableViewController.view.hidden = imageStatus;
}

- (void)showSummary:(id)sender
{
    NSArray *colours = [self findValidColourImages];
    NSArray *specificationsData = [self.modelData valueForKeyPath:@"Specifications.Specification"];
    NSIndexPath *selectedIndex = nil;
    NSDictionary *selectedColourData;
    NSDictionary *selectedSpecificationData;
    selectedIndex = [((UITableView*)swatchTableViewController.view) indexPathForSelectedRow];
    selectedColourData = [colours objectAtIndex:(selectedIndex?selectedIndex.row:0)];
    selectedIndex = specificationTableViewController.selectedSpecificationIndex;
    selectedSpecificationData = [specificationsData objectAtIndex:(selectedIndex?selectedIndex.row:0)];
    CHSummaryViewController *summaryViewController = [[CHSummaryViewController alloc] initWithNibName:@"CHSummaryViewController" bundle:nil vehicleName:vehicleName modelName:self.title colourName:[selectedColourData valueForKey:@"Name"] modelImageURL:[BASEURL stringByAppendingString:[selectedColourData valueForKey:@"ModelImage"]] specificationName:[selectedSpecificationData valueForKey:@"Name"] price:[selectedSpecificationData valueForKeyPath:@"Price.text"]];
    [self.navigationController pushViewController:summaryViewController animated:YES];
}
@end

@interface CHHighlightsTableViewController()
@end

@implementation CHHighlightsTableViewController{
    NSArray* _highlightsData;
}
-(id) initWithHighlightsData:(NSArray*) highlightsData{
    self = [super init];
    _highlightsData = highlightsData;
    self.tableView.separatorColor = [UIColor whiteColor];
    return self;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_highlightsData count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //[cell.layer setBorderWidth:1.0f];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *colourData = [_highlightsData objectAtIndex:indexPath.row];
    NSString *highlight = [colourData objectForKey:@"text"];
    cell.textLabel.text = highlight;
    
    return cell;
}

@end

@interface CHSwatchTableViewController()
@end

@implementation CHSwatchTableViewController{
    NSArray* _colourImages;
}
-(id) initWithColourImages:(NSArray*) colourImages parentViewController:(CHColorModelViewController*) parentViewController{
    self = [super init];
    _colourImages = colourImages;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.parentViewController = parentViewController;
    return self;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_colourImages count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //[cell.layer setBorderWidth:1.0f];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *colourData = [_colourImages objectAtIndex:indexPath.row];
    NSString *url = [BASEURL stringByAppendingString:[colourData objectForKey:@"SwatchImage"]];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    /*
    NSString *url = [BASEURL stringByAppendingString:[colourData objectForKey:@"SwatchImage"]];
    NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *posterOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
    posterOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [posterOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            cell.imageView.image = responseObject;
        } else {
            //cell.posterImage.image = responseObject;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error loading model image: %@", error);
    }];
    [posterOperation start];*/

    /*NSString *thumbnailURLString = [colourData objectForKey:@"SwatchImage"];
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:thumbnailURLString]]]
                              placeholderImage: nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           NSLog(@"success to load image for: %@", [request URL]);
                                           weakCell.imageView.image = image;
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"fail to load image for: %@", [request URL]);
                                       }];*/
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * colourData = [_colourImages objectAtIndex:indexPath.row];
    NSString *url = [BASEURL stringByAppendingString:[colourData valueForKey:@"ModelImage"]];
    NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *posterOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
    posterOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [posterOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [self.parentViewController updateModelImageWith:responseObject imageTitle:[colourData valueForKey:@"Name"]];
        } else {
            //cell.posterImage.image = responseObject;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error loading model image: %@", error);
    }];
    [posterOperation start];
}

@end

@interface CHSpecificationTableViewController()
@end

@implementation CHSpecificationTableViewController{
    int currentExpandedIndex;
    NSArray* _specificationsData;
}

-(id) initWithSpecificationsData:(NSArray*) specificationsData{
    self = [super init];
    _specificationsData = specificationsData;
    self.tableView.separatorColor = [UIColor whiteColor];
    return self;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(currentExpandedIndex>=0){
        return [_specificationsData count] + [[_specificationsData objectAtIndex:currentExpandedIndex] count];
    }
    return [_specificationsData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ParentCellIdentifier = @"ParentCell";
    static NSString *ChildCellIdentifier = @"ChildCell";
    
    BOOL isChild = currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex && indexPath.row <= currentExpandedIndex + [[_specificationsData objectAtIndex:currentExpandedIndex] count];
    UITableViewCell *cell;
    if (isChild) {
        cell = [tableView dequeueReusableCellWithIdentifier:ChildCellIdentifier];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:ParentCellIdentifier];
    }
    cell.contentMode = UIViewContentModeRedraw;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ParentCellIdentifier];
    }
    if (isChild) {
        NSDictionary *specificationData = [_specificationsData objectAtIndex:currentExpandedIndex];
        NSString *key = [[specificationData allKeys] objectAtIndex:indexPath.row - currentExpandedIndex - 1];
        NSObject *value = [specificationData valueForKey:key];
        if([value isKindOfClass:[NSDictionary class]]){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", key, [value valueForKey:@"text"]];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", key, value];
        }
    } else {
        int topIndex = (currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex) ? indexPath.row - [[_specificationsData objectAtIndex:currentExpandedIndex] count] : indexPath.row;
        
        cell.textLabel.text = [[_specificationsData objectAtIndex:topIndex] valueForKey:@"Name"];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isChild = currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex && indexPath.row <= currentExpandedIndex + [[_specificationsData objectAtIndex:currentExpandedIndex] count];
    if (isChild) {
        NSLog(@"A child was tapped, do what you will with it");
        return;
    }else{
        self.selectedSpecificationIndex = indexPath;
    }
    [self.tableView beginUpdates];
    if (currentExpandedIndex == indexPath.row) {
        [self collapseSubItemsAtIndex:currentExpandedIndex];
        currentExpandedIndex = -1;
    } else {
        BOOL shouldCollapse = currentExpandedIndex > -1;
        
        if (shouldCollapse) {
            [self collapseSubItemsAtIndex:currentExpandedIndex];
        }
        
        currentExpandedIndex = (shouldCollapse && indexPath.row > currentExpandedIndex) ? indexPath.row - [[_specificationsData objectAtIndex:currentExpandedIndex] count] : indexPath.row;
        
        [self expandItemAtIndex:currentExpandedIndex];
    }
    
    [self.tableView endUpdates];
}

- (void)expandItemAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *currentSubItems = [_specificationsData objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)collapseSubItemsAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = index + 1; i <= index + [[_specificationsData objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
@end

@implementation CHOfferCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.offerPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 200, 30)];
        self.backgroundColor = [UIColor whiteColor];
        self.offerPriceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.offerPriceLabel];
        
        self.offerVehicleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 140)];
        [self.contentView addSubview:self.offerVehicleImageView];
    }
    return self;
}
@end

@interface CHOfferCollectionViewController()
@end

@implementation CHOfferCollectionViewController{
    NSArray *offers;
}
-(id) initWithCollectionViewLayout:(UICollectionViewLayout *)layout offersData:(NSArray *)offersData
{
    self = [super initWithCollectionViewLayout:layout];
    self->offers = offersData;
    [self.collectionView registerClass:[CHOfferCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    return self;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [offers count];
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHOfferCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    NSDictionary *offerData = [offers objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[BASEURL stringByAppendingString:[offerData valueForKeyPath:@"offerVehicleEntryImage.imageLocation"]]]]];
    cell.offerVehicleImageView.image = image;
    cell.offerPriceLabel.text = [NSString stringWithFormat:@"%@ %@", [offerData valueForKey:@"primaryPricePrefix"], [offerData valueForKey:@"primaryPrice"]];
    return cell;
}

-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"");
    return nil;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row>=0){
    }
}

@end