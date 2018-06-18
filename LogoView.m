//
//  LogoView.m
//  BiznessECards
//
//  Created by Tarun Pal on 5/24/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "LogoView.h"
#import "DefinesAndHeaders.h"
@interface LogoView ()<SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

@end

@implementation LogoView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BiznessEcards";
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    _blankView.layer.cornerRadius = 8.0f;
    _blankView.layer.masksToBounds = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBTN:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
