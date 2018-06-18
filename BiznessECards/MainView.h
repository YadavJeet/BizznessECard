//
//  MainView.h
//  BiznessECards
//
//  Created by Tarun Pal on 5/14/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIViewController

{
    __weak IBOutlet UIView *view1;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notficationBtn;
@property (weak, nonatomic) IBOutlet UILabel *Active_count;
@property (weak, nonatomic) IBOutlet UILabel *save_count;
@end
