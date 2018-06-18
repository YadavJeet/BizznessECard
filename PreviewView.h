//
//  PreviewView.h
//  BiznessECards
//
//  Created by Tarun Pal on 5/20/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewView : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *F_imageview;
@property (weak, nonatomic) IBOutlet UIImageView *B_imageview;
@property (weak, nonatomic) IBOutlet UILabel *cardLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property(nonatomic,strong)NSArray*deatil;
@property(nonatomic,strong)NSString*check;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *linkedinButton;
@property (weak, nonatomic) IBOutlet UIButton *twetterButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;

@property (weak, nonatomic) IBOutlet UILabel *phntxt;

@property (weak, nonatomic) IBOutlet UILabel *webtxt;



@end
