//
//  SizesetClassVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 4/11/18.
//  Copyright © 2018 Jitendra yadav. All rights reserved.
//

#import "SizesetClassVC.h"
#import "GlobleClass.h"
#import "Singleton.h"

@interface SizesetClassVC ()
@property (weak, nonatomic) IBOutlet UITextField *widthtextfld;
@property (weak, nonatomic) IBOutlet UITextField *heightTextfld;

@end

@implementation SizesetClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ApplyBTN:(id)sender {
    if ((_widthtextfld.text).intValue <= 31) {
        [GlobleClass alertWithMassage:@"Minimum width size are 32" Title:@"Error!"];
    }else if ((_widthtextfld.text).intValue >= 257){
        [GlobleClass alertWithMassage:@"Maximum width size are 256" Title:@"Error!"];
    }else if ((_heightTextfld.text).intValue <= 31) {
        [GlobleClass alertWithMassage:@"Minimum height size are 32" Title:@"Error!"];
    }else if ((_heightTextfld.text).intValue >= 129){
        [GlobleClass alertWithMassage:@"Maximum height size are 128" Title:@"Error!"];
    }else{
        [Singleton createInstance].width = _widthtextfld.text;
        [Singleton createInstance].height = _heightTextfld.text;
        [Singleton createInstance].b_width = _widthtextfld.text;
        [Singleton createInstance].b_height = _heightTextfld.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)cancleBTN:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
