//
//  orderSummary.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/27/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderSummary : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *front_image;
@property (weak, nonatomic) IBOutlet UILabel *total_card;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *trantn_date;
@property (weak, nonatomic) IBOutlet UIButton *preViewBTN;
@property (weak, nonatomic) IBOutlet UIButton *ReOrderBTN;

@end
