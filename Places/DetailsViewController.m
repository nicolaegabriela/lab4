//
//  DetailsViewController.m
//  Places
//
//  Created by ios2 on 7/10/15.
//  Copyright (c) 2015 Gabriela. All rights reserved.
//

#import "DetailsViewController.h"
@interface DetailsViewController ()
@property(weak,nonatomic) IBOutlet UILabel *label1;
@property(weak,nonatomic) IBOutlet UILabel *label2;
@property(weak,nonatomic) IBOutlet UILabel *label3;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _label1.text=_place.name;
    _label2.text=_place.formattedAddress;
    _label3.text=_place.phoneNumber;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
