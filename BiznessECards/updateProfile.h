//
//  updateProfile.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/15/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface updateProfile : UIViewController
- (IBAction)BTNUpdate:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *addresstexfld;

@property (weak, nonatomic) IBOutlet UITextField *mobile_number;
@property (weak, nonatomic) IBOutlet UITextField *full_name;
@property (weak, nonatomic) IBOutlet UIView *editview;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end
