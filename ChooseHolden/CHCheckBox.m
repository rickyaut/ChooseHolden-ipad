//
//  CHCheckBox.m
//  ChooseHolden
//
//  Created by Ricky Liu on 23/09/13.
//  Copyright (c) 2013 Ricky Liu. All rights reserved.
//

#import "CHCheckBox.h"

@implementation CHCheckBox{
    UIImageView* _imageView;
    UIImage *_statusOnImage;
    UIImage *_statusOffImage;
    UILabel* _label;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame label: @"test checkbox" initialStatus:YES];
}

-(id)initWithFrame:(CGRect)frame label: (NSString*) label initialStatus: (BOOL) initialStatus{
    return [self initWithFrame:frame label: label initialStatus:initialStatus statusOnImageName:@"cb_box_on" statusOffImageName:@"cb_box_off" ];
}

-(id)initWithFrame:(CGRect) frame label: (NSString*) label initialStatus: (BOOL) initialStatus statusOnImageName: (NSString*) statusOnImageName statusOffImageName: (NSString*) statusOffImageName{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *fileLocation = [[NSBundle mainBundle] pathForResource:statusOnImageName ofType:@"png"];
        _statusOnImage = [UIImage imageWithContentsOfFile:fileLocation];
        fileLocation = [[NSBundle mainBundle] pathForResource:statusOffImageName ofType:@"png"];
        _statusOffImage = [UIImage imageWithContentsOfFile:fileLocation];
        UIImage* image = initialStatus?_statusOnImage:_statusOffImage;
        _imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_imageView];
        _label = [[UILabel alloc]initWithFrame:CGRectMake( _statusOffImage.size.width+5, 0, 80, _statusOffImage.size.height)];
        _label.text = label;
        [self addSubview:_label];
        self.checked = initialStatus;
        
    }
    return self;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"beginning tracking");
    return YES;
    
}

-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"continuing tracking");
    return YES;
}

-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.checked = !self.checked;
    _imageView.image = self.checked? _statusOnImage: _statusOffImage;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void) layoutSubviews{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
