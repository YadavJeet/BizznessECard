//
//  templatCell.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/4/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface templatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Fimage;
@property (weak, nonatomic) IBOutlet UIImageView *Bimage;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *templetprice;
@property (weak, nonatomic) IBOutlet UIButton *selectBTN;


@property (weak, nonatomic) IBOutlet UILabel *notificationLBL;
@property (weak, nonatomic) IBOutlet UIButton *declineBTN;
@property (weak, nonatomic) IBOutlet UIButton *acceptBTN;

@property (weak, nonatomic) IBOutlet UILabel *QuesLBL;
@property (weak, nonatomic) IBOutlet UILabel *ansLBL;

@property (weak, nonatomic) IBOutlet UILabel *cardvalue;
@property (weak, nonatomic) IBOutlet UILabel *price_value;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *back_image;


@end
