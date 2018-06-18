//
//  BackgroundView.m
//  BiznessECards
//
//  Created by Tarun Pal on 5/24/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "BackgroundView.h"
#import "DefinesAndHeaders.h"

@interface BackgroundView ()<SWRevealViewControllerDelegate>
{
    Singleton*singleton ;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@end

@implementation BackgroundView

- (void)viewDidLoad {
    singleton = [Singleton createInstance];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    _blankView.layer.cornerRadius = 8.0f;
    _blankView.layer.masksToBounds = YES;
    self.title = @"BiznessEcards";
    [super viewDidLoad];
    
    
    [[UILabel appearanceWhenContainedIn:[UISegmentedControl class], nil] setNumberOfLines:0];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TextColorBTN:(UIButton*)sender
{
    UIColor *color = sender.backgroundColor;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.appDelColor = color;
    
  [sender setBackgroundImage:[UIImage imageNamed:@"select-template-icon"] forState:UIControlStateNormal];
    
//    const CGFloat *components = CGColorGetComponents(color.CGColor);
//    NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
//    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:colorAsString forKey:@"color"];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)backBTN:(id)sender
{
     [self.navigationController popViewControllerAnimated:NO];
}
@end
