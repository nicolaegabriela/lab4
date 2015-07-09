//
//  ViewController.m
//  Places
//
//  Created by ios2 on 07/07/15.
//  Copyright (c) 2015 Gabriela. All rights reserved.
//

#import "ViewController.h"
#import "Profile.h"
#import "Settings.h"

@interface ViewController ()
@property(strong,nonatomic) Profile * prof;
@property(weak,nonatomic) IBOutlet UIButton *profileButton;
@property(weak,nonatomic) IBOutlet UIButton *settingsButton;
@property(weak,nonatomic) IBOutlet UIView * profileView;
@property(weak,nonatomic) IBOutlet UIView * settingsView;
@property(weak,nonatomic) IBOutlet UITextField *firstName;
@property(weak,nonatomic) IBOutlet UITextField *lastName;
@property(weak,nonatomic) IBOutlet UILabel *label_firstName;
@property(weak,nonatomic) IBOutlet UILabel *label_lastName;
@property(weak,nonatomic) IBOutlet UIImageView *profileImage;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint *modfifyconstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.prof=[[Profile alloc]init];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:
     UIKeyboardWillHideNotification object:nil];
    
}
-(void)closeKeyboard {
    [self.view endEditing:YES];
}
-(CGFloat)whereislabelfromKeyboard:(CGRect)keyboard andwhattextfield:(UITextField *)textfiled{
    
    if((keyboard.size.height+textfiled.frame.origin.y)>self.view.frame.size.height)
        return ((keyboard.size.height+textfiled.frame.origin.y+textfiled.frame.size.height)-self.view.frame.size.height);
    else return 0;
    
}
-(void)keyboardWillShow:(NSNotification *)note{
    
    CGRect keyboard=[[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect frame=self.view.frame;
    if([_firstName isFirstResponder]){
        frame.origin.y = - ([self whereislabelfromKeyboard:keyboard andwhattextfield:_firstName]+52);
    }
    else if ([_lastName isFirstResponder]){
        frame.origin.y = - ([self whereislabelfromKeyboard:keyboard andwhattextfield:_lastName]+52);
    }
    [self.view setFrame:frame];
    
}
-(void)keyboardWillHide{
    CGRect frame=self.view.frame;
     frame.origin.y=0;
    [self.view setFrame:frame];
}

-(IBAction)buttonPressed:(UIButton *) sender{
    if(![sender isSelected]){
        
        if ( [sender isEqual:_profileButton]){
            [_profileView setHidden:NO];
            [_settingsView setHidden:YES];
            [_profileButton setSelected:YES ];
            [_settingsButton setSelected:NO];
            _modfifyconstraint.constant=0;
            
        }
        else
        {
            [_profileView setHidden:YES];
            [_settingsView setHidden:NO];
            [_profileButton setSelected:NO ];
            [_settingsButton setSelected:YES];
            _modfifyconstraint.constant=sender.frame.size.width;

        }
        [self.view layoutIfNeeded];
        
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:_firstName])
        self.prof.firstName=[textField text];
    else{
            self.prof.lastName=[textField text];
        if (self.prof.firstName.length==0 )
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"alert" message:@"please set your name" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
            [alert show];
            _label_firstName.textColor=[UIColor redColor];
        }
        if (self.prof.lastName.length==0 )
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"alert" message:@"please set your name" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
            [alert show];
            _label_lastName.textColor=[UIColor redColor];
        }
        
        
        
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateIndicationViewWithDuration:0.0];
}
-(void)updateIndicationViewWithDuration:(CGFloat)duration
{
    if ([_profileButton isSelected]){
        _modfifyconstraint.constant=0;
    }
    else{
        _modfifyconstraint.constant=_settingsButton.frame.size.width;
    }
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{[self.view layoutIfNeeded];} completion:nil];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_firstName])
         _label_firstName.textColor=[UIColor blackColor];
        
    else
        _label_lastName.textColor=[UIColor blackColor];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:_firstName]){
        [self.lastName becomeFirstResponder];
        
    }
    else{
        [self.lastName resignFirstResponder];
    }
    return YES;
}
-(IBAction)setPicker:(UIDatePicker *) sender{
    self.prof.birthday=sender.date;
}
-(IBAction)pressPhoto:(id)sender{
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo",@"Select photo from galery", nil ];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [self uploadPhotoFrom:UIImagePickerControllerSourceTypeCamera];
        }
            break;
         case 1:
        {
            [self uploadPhotoFrom:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        default:
            break;
    }
}
-(void)uploadPhotoFrom:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        imagePicker.sourceType=sourceType;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType=info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString: (NSString *) kUTTypeImage])
    {
        _prof.photo=info[UIImagePickerControllerOriginalImage];
        _profileImage.image=_prof.photo;
    }
}

@end
