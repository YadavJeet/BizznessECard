//
//  ActiveCardCell.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *front_image;
@property (weak, nonatomic) IBOutlet UILabel *card_value;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIButton *reOrderBTN;
@property (weak, nonatomic) IBOutlet UIButton *shareBTN;

@end
