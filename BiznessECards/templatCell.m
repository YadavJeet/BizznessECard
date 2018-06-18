//
//  templatCell.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/4/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "templatCell.h"

@implementation templatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _declineBTN.layer.cornerRadius=5.0f;
    _declineBTN.layer.masksToBounds=YES;
    _acceptBTN.layer.cornerRadius=5.0f;
    _acceptBTN.layer.masksToBounds=YES;
    _back_image.layer.cornerRadius=5.0f;
    _back_image.layer.masksToBounds=YES;

   

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
