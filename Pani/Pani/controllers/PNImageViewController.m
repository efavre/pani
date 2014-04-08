//
//  PNImageViewController.m
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import "PNImageViewController.h"

@interface PNImageViewController ()

@end

@implementation PNImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayImage];
}

- (void)displayImage
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1-%d.png", [self.imageIdentifier intValue]]];
    self.imageView.image = image;
}


@end
