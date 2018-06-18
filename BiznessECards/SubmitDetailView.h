//
//  SubmitDetailView.h
//  BiznessECards
//
//  Created by Tarun Pal on 5/16/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitDetailView : UIViewController
- (IBAction)Upload_logo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *skype_FLD;
@property (weak, nonatomic) IBOutlet UITextField *linked_in_FLD;
@property (weak, nonatomic) IBOutlet UITextField *twitter_FLD;
@property (weak, nonatomic) IBOutlet UITextField *facebook_FLD;
@property (weak, nonatomic) IBOutlet UITextField *website_textfld;
@property (weak, nonatomic) IBOutlet UITextView *address_textfld;
@property (weak, nonatomic) IBOutlet UITextField *email_id;
@property (weak, nonatomic) IBOutlet UITextField *job_title;
@property (weak, nonatomic) IBOutlet UITextField *mobile_number;
@property (weak, nonatomic) IBOutlet UITextField *full_name;
@property (weak, nonatomic) IBOutlet UITextField *Company_name;
@property (weak, nonatomic) IBOutlet UITextField *slogan_textfld;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_height;

@end
