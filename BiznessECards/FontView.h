//
//  FontView.h
//  BiznessECards
//
//  Created by Tarun Pal on 5/24/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserResizableView.h"

@interface FontView : UIViewController
<UIGestureRecognizerDelegate, SPUserResizableViewDelegate> {
    SPUserResizableView *currentlyEditingView;
    SPUserResizableView *lastEditedView;
}


@property (weak, nonatomic) IBOutlet UIView *d_viewBC;
@property (weak, nonatomic) IBOutlet UILabel *fonttype;
@property (weak, nonatomic) IBOutlet UILabel *font_dis;
@property (weak, nonatomic) IBOutlet UITextField *addressFld;

@property (weak, nonatomic) IBOutlet UIButton *addresButton;
@property (weak, nonatomic) IBOutlet UIButton *fountButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *WebBTN;

@property (weak, nonatomic) IBOutlet UIButton *LogoButton;
@property (weak, nonatomic) IBOutlet UIButton *backGButton;
@property (weak, nonatomic) IBOutlet UIButton *changeBTN;

- (IBAction)webButton:(id)sender;
- (IBAction)fontBTN:(id)sender;
- (IBAction)phoneBTN:(id)sender;
- (IBAction)emailBTN:(id)sender;
- (IBAction)Addressbtn:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *f_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *f_width;

@property (weak, nonatomic) IBOutlet UIImageView *temp_logo;

@property (weak, nonatomic) IBOutlet UIButton *phonebutton;
@property (weak, nonatomic) IBOutlet UITextField *phnTxtfld;
@property (weak, nonatomic) IBOutlet UITextField *emailfld;
@property (weak, nonatomic) IBOutlet UITextField *weblink;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b_width;


@end
