//
//  changePasswordVC.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changePasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldtextfld;
@property (weak, nonatomic) IBOutlet UITextField *NewTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *changepwdButton;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UITextField *RePassfld;
@property (weak, nonatomic) IBOutlet UIButton *chngPwdBTN;

- (IBAction)cancelBTN:(id)sender;

@end
