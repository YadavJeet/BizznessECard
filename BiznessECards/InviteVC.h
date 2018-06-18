//
//  InviteVC.h
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/13/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteVC : UIViewController
{
    NSString *share;
}
@property (nonatomic, strong) UIActivityViewController *activityViewController;
@end
