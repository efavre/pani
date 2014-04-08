//
//  PNImageViewController.h
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNImageViewController : UIViewController

@property (strong, nonatomic) NSNumber *imageIdentifier;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
