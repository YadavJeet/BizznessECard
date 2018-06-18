//
//  MycardVC.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/13/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MycardVC : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailling;
- (IBAction)ProfileBTN:(id)sender;

- (IBAction)editBTN:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *walletamount_lbl;
@property (weak, nonatomic) IBOutlet UIButton *ProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *usermailiD;
@property (weak, nonatomic) IBOutlet UILabel *userNo;
@property(nonatomic,strong)NSString *stringvalue;
@end
