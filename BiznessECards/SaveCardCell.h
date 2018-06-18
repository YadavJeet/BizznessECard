//
//  SaveCardCell.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *card_cost;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIButton *orderBTN;
@property (weak, nonatomic) IBOutlet UIImageView *image_front;

@end
