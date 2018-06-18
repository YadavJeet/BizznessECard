//
//  ChangeTempCell.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 8/3/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeTempCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Fimage;
@property (weak, nonatomic) IBOutlet UIImageView *Bimage;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *templetprice;
@property (weak, nonatomic) IBOutlet UIButton *selectBTN;

@end
