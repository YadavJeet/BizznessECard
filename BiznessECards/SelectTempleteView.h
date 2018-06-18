//
//  SelectTempleteView.h
//  BiznessECards
//
//  Created by Tarun Pal on 5/16/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTempleteView : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBTN;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TV_Height;
@property (weak, nonatomic) IBOutlet UITableView *TV;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@end
