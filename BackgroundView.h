//
//  BackgroundView.h
//  BiznessECards
//
//  Created by Tarun Pal on 5/24/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScreenBDelegate <NSObject>
- (void)screenBChangedColor:(UIColor *)color;
@end
@interface BackgroundView : UIViewController
@property (weak, nonatomic) IBOutlet UIView *blankView;

@end
