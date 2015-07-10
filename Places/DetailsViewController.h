//
//  DetailsViewController.h
//  Places
//
//  Created by ios2 on 7/10/15.
//  Copyright (c) 2015 Gabriela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface DetailsViewController : UIViewController
@property(strong,nonatomic) GMSPlace *place;
@end
