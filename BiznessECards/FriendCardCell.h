//
//  FriendCardCell.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_front;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIButton *viewDetailBTN;

@end
