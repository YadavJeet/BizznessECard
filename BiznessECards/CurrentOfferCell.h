//
//  CurrentOfferCell.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 12/16/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentOfferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Offername;
@property (weak, nonatomic) IBOutlet UILabel *DetailofferLBL;
@property (weak, nonatomic) IBOutlet UILabel *offerValue;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UIButton *select;


@end
