//
//  PNDetailViewController.h
//  Pani
//
//  Created by Eric Favre on 08/04/2014.
//  Copyright (c) 2014 Eric Favre. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface PNAlbumContentViewController : UIViewController <UISplitViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *albumName;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;

@end
