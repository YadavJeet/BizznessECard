//
//  FontView.m
//  BiznessECards
//
//  Created by Tarun Pal on 5/24/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "FontView.h"
#import "DefinesAndHeaders.h"
#import "BackgroundView.h"
#import "LogoView.h"
#import "ChangeTempletView.h"
#import "CustomStriker.h"
#import "SaveImagePreview.h"
#import "SizesetClassVC.h"

@interface FontView ()<SWRevealViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CHTStickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    UIPickerView *picker;
    NSArray *fontName;
    NSMutableArray *fontSize;
    NSString *colorTap;
    UILabel*lbl;
    Singleton * singleton;
    NSInteger btnSelectTag;
    BOOL isCheckView;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmenindex;
@property (weak, nonatomic) IBOutlet UITextField *fontsize;
@property (weak, nonatomic) IBOutlet UITextField *fontNameTxtfld;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (weak, nonatomic) IBOutlet UIView *ColorView;
@property (weak, nonatomic) IBOutlet UIButton *colorBTN;

@property (nonatomic, strong) CustomStriker *selectedView;
@property (nonatomic, strong) SPUserResizableView *userResizableView;
@end

@implementation FontView

- (void)viewDidLoad {
     singleton = [Singleton createInstance];
     singleton.width = @"64";
     singleton.height = @"64";
     singleton.b_width = @"64";
     singleton.b_height = @"64";
    
     [super viewDidLoad];
     lbl = [[UILabel alloc]init];
    _colorBTN.layer.cornerRadius = 5;
    _backView.hidden = YES;
    UIPanGestureRecognizer * tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fireScrollRectToVisible:)];
    
     UIPanGestureRecognizer * tap1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fireScrollRectToVisible1:)];
    
    [_temp_logo addGestureRecognizer:tap];
    [_temp_logo setUserInteractionEnabled:YES];
    
    [_profileImage addGestureRecognizer:tap1];
    [_profileImage setUserInteractionEnabled:YES];
    
    
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(twoFingerPinch:)];
    [_temp_logo addGestureRecognizer:twoFingerPinch];
    
    UIPinchGestureRecognizer *twoFingerPinch1 = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(twoFingerPinch1:)];
    [_profileImage addGestureRecognizer:twoFingerPinch1];
   
    NSLog(@"my detail %@",singleton.userDetail);
    
     [_temp_logo sd_setImageWithURL:[NSURL URLWithString:[singleton.userDetail objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [self frameSetLable:self.d_viewBC];
    [self frameSetLable:self.backView];
 
     _addressFld.hidden = YES;
     _phnTxtfld.hidden = YES;
     _weblink.hidden = YES;
     _emailfld.hidden = YES;
      colorTap = @"show";
     _ColorView.hidden = YES;
    
     fontSize = [[NSMutableArray alloc] init];
     self.title = @"BiznessEcards";
    
//    _menuBtn.target = self.revealViewController;
//    _menuBtn.action = @selector(revealToggle:);
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    NSSortDescriptor *valueDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
    fontName = [[UIFont familyNames] sortedArrayUsingDescriptors:@[valueDescriptor]];
    
    for (int i = 1; i <= 20; i++)
    {
        [fontSize addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    picker = [[UIPickerView alloc]init];
    picker.delegate=self;
    picker.dataSource=self;
    [picker setShowsSelectionIndicator:YES];
    [self.fontNameTxtfld setInputView:picker];
    [self.fontsize setInputView:picker];

    // Do any additional setup after loading the view.
}

-(void)fireScrollRectToVisible:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.d_viewBC];
    CGRect boundsRect;
    boundsRect = CGRectMake(point.x, point.y, _d_viewBC.frame.size.width-40, _d_viewBC.frame.size.height-40);
    if (CGRectContainsPoint(boundsRect, point))
    {
        _temp_logo.center = point;
    }
}

-(void)fireScrollRectToVisible1:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.backView];
    CGRect boundsRect;
    boundsRect = CGRectMake(point.x, point.y, _backView.frame.size.width-40, _backView.frame.size.height-40);
    if (CGRectContainsPoint(boundsRect, point))
    {
        _profileImage.center = point;
    }
}





-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:YES];
    [self.d_viewBC.superview bringSubviewToFront:_temp_logo];

    if ([singleton.category_id isEqualToString:@"6"])
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (_segmenindex.selectedSegmentIndex==0)
        {
         self.d_viewBC.backgroundColor = appDelegate.appDelColor;
            
        }
         else self.backView.backgroundColor = appDelegate.appDelColor;
        
    }else{
        
    }
    
    //MARK: check logo size selectedSegmentIndex
    
    if (_segmenindex.selectedSegmentIndex==0)
    {
    _f_height.constant = (singleton.height).integerValue;
    _f_width.constant = (singleton.width).integerValue;
    }
    else{
     _f_height.constant = (singleton.b_height).integerValue;
     _f_width.constant = (singleton.b_width).integerValue;
    }
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[singleton.CardDetail valueForKey:@"img_url4"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [picker selectRow:15  inComponent:0 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_fontNameTxtfld isFirstResponder])
    {
        return [fontName count];
    }else if ([_fontsize isFirstResponder])
    {
         return [fontSize count];
    }
    return YES;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *retval = (UILabel*)view;
    if (!retval)
    {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    retval.font = [UIFont fontWithName:@"OpenSans-Bold" size:30];
    retval.textAlignment = NSTextAlignmentCenter;
    
    if ([_fontNameTxtfld isFirstResponder]){
           retval.text = [[fontName objectAtIndex:row] capitalizedString] ;

    }
    else if ([_fontsize isFirstResponder])
    {
         retval.text = [fontSize objectAtIndex:row];

    }
    
    return retval;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ([_fontNameTxtfld isFirstResponder])
    {
        
        NSArray *components= self.selectedView.subviews;
        
        for (UILabel *currentObj in components)
        {
            lbl = currentObj;
            _fontNameTxtfld.text = [fontName objectAtIndex: row];
            lbl.font = [UIFont fontWithName:_fontNameTxtfld.text size:12];
            CGSize size =  [self inputLBL:lbl.text];
            lbl.frame=CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y,300, size.height);
            _fontsize.text  = @"";
            btnSelectTag = 0;
        }
        NSArray *componts;
        if (_segmenindex.selectedSegmentIndex==0)
        {
            componts=self.d_viewBC.subviews;
        }else
        {
            componts=self.backView.subviews;
        }
        for (SPUserResizableView *userResizableView in componts) {
            NSArray *components= self.userResizableView.subviews;
            for (UILabel *currentObj in components) {
                if (currentObj.tag==5)
                {
                    btnSelectTag = 5;
                    if (currentObj.tag==userResizableView.tag)
                    {
                        btnSelectTag = 5;
                        lbl=userResizableView.subviews.firstObject;

                        _fontNameTxtfld.text = [fontName objectAtIndex: row];
                        lbl.font = [UIFont fontWithName:_fontNameTxtfld.text size:12];
                        CGSize size =  [self inputLBL:lbl.text];
                        lbl.frame=CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y,300, size.height);
                        _fontsize.text  = @"";
                        btnSelectTag = 0;

                        
                    }
                    
                }
            }
        }

        
        
    }
    else if ([_fontsize isFirstResponder])
    {
        if (_fontNameTxtfld.text.length>0)
        {
            NSArray *components= self.selectedView.subviews;
            for (UILabel *currentObj in components)
            {
                lbl=currentObj;
                _fontsize.text = [fontSize objectAtIndex: row];
                lbl.font = [UIFont fontWithName:_fontNameTxtfld.text size:[_fontsize.text  integerValue]];
                CGSize size =  [self inputLBL:lbl.text];
                lbl.frame=CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y,300, size.height);
                btnSelectTag=0;
            }
            
            
            
            NSArray *componts;
            if (_segmenindex.selectedSegmentIndex==0)
            {
                componts=self.d_viewBC.subviews;
            }else
            {
                componts=self.backView.subviews;
            }
            for (SPUserResizableView *userResizableView in componts) {
                NSArray *components= self.userResizableView.subviews;
                for (UILabel *currentObj in components) {
                    if (currentObj.tag==5)
                    {
                        btnSelectTag = 5;
                        if (currentObj.tag==userResizableView.tag)
                        {
                            btnSelectTag = 5;
                            lbl=userResizableView.subviews.firstObject;
                            
                            _fontsize.text = [fontSize objectAtIndex: row];
                            lbl.font = [UIFont fontWithName:_fontNameTxtfld.text size:[_fontsize.text  integerValue]];
                            CGSize size =  [self inputLBL:lbl.text];
                            lbl.frame=CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y,300, size.height);
                            
                        }
                        
                    }
                }
            }

            
        }else
        {
            [GlobleClass alertWithMassage:@"Please select font Family After set font size" Title:@"Alert!"];
            [_fontsize resignFirstResponder];
        }
        
    }
}

- (IBAction)TextColorBTN:(UIButton*)sender
{
    UIColor *color = sender.backgroundColor;
    NSArray *components= self.selectedView.subviews;
     btnSelectTag = 0;
    for (UILabel *currentObj in components)
    {
        lbl=currentObj;
        [lbl setTextColor:color];
    }
    
    NSArray *componts;
    if (_segmenindex.selectedSegmentIndex==0)
    {
          componts=self.d_viewBC.subviews;
    }else
    {
          componts=self.backView.subviews;
    }
     for (SPUserResizableView *userResizableView in componts) {
        NSArray *components= self.userResizableView.subviews;
        for (UILabel *currentObj in components) {
            if (currentObj.tag==5)
            {
                btnSelectTag = 5;
                if (currentObj.tag==userResizableView.tag)
                {
                    lbl=userResizableView.subviews.firstObject;
                    [lbl setTextColor:color];
                }
            }
        }
    }

     colorTap=@"show";
    _ColorView.hidden = YES;
}

- (IBAction)ColorBTN:(id)sender
{
    if ([colorTap isEqualToString:@"show"])
    {
         colorTap=@"hide";
        _ColorView.hidden = NO;
        [self.view bringSubviewToFront:_ColorView];
    }
    else{
        
         colorTap=@"show";
        _ColorView.hidden = YES;
    }
}


- (IBAction)backBTN:(id)sender
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert!"
                                 message:@"“Are you sure you want to go back to previous screen.!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [self.navigationController popViewControllerAnimated:YES];

                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    
    
    [alert addAction:noButton];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)saveBTN:(id)sender
{
    if (_segmenindex.selectedSegmentIndex==1)
    {
        UIGraphicsBeginImageContextWithOptions(_backView.bounds.size, _backView.opaque, 0.0);
        [_backView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        singleton.image2 = UIImagePNGRepresentation(img2);
    }
    else
    {
    UIGraphicsBeginImageContextWithOptions(_d_viewBC.bounds.size, _d_viewBC.opaque, 0.0);
    [_d_viewBC.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    singleton.image1 = UIImagePNGRepresentation(img2);
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SaveImagePreview *ivc = [storyboard instantiateViewControllerWithIdentifier:@"SaveImagePreview"];
    [self.navigationController pushViewController:ivc animated:NO];

}

- (IBAction)Addressbtn:(id)sender {
    
    [_addresButton setBackgroundImage:[UIImage imageNamed:@"pre_add_select"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"pre_emailBtn"] forState:UIControlStateNormal];
    [_WebBTN setBackgroundImage:[UIImage imageNamed:@"pre_websiteBtn"] forState:UIControlStateNormal];
    [_fountButton setBackgroundImage:[UIImage imageNamed:@"pre_frantBtn"] forState:UIControlStateNormal];
     [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone"] forState:UIControlStateNormal];
    [_LogoButton setBackgroundImage:[UIImage imageNamed:@"pre_logoBtn"] forState:UIControlStateNormal];
    [_changeBTN setBackgroundImage:[UIImage imageNamed:@"pre_changeBtn"] forState:UIControlStateNormal];
    [_backGButton setBackgroundImage:[UIImage imageNamed:@"pre_backBtn"] forState:UIControlStateNormal];
    _phnTxtfld.hidden = YES;
    _weblink.hidden = YES;
    _emailfld.hidden = YES;
    _addressFld.hidden = NO;
    _ColorView.hidden = YES;
    _fontsize.hidden =YES;
    _colorBTN.hidden = YES;
    _fontNameTxtfld.hidden = YES;
    _fonttype.text=@"Address";
    _font_dis.text = @"Please enter Address the box below";
     _addressFld.text= nil;
    
    btnSelectTag=5;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGSize size;
    NSArray *componts;
    if (_segmenindex.selectedSegmentIndex==1)
    {
         componts=self.backView.subviews;
    }else
    {
        componts=self.d_viewBC.subviews;
    }
    for (CustomStriker *strikers in componts) {
        
        if (btnSelectTag==strikers.tag) {
            
            lbl=strikers.subviews.firstObject;
      }
    }
    

    for (SPUserResizableView *userResizableView in componts) {
        
        if (btnSelectTag==userResizableView.tag) {
            
            lbl=userResizableView.subviews.firstObject;
        }
    }
    
    
    if (_addressFld.resignFirstResponder) {
         lbl.text  = _addressFld.text;
         size=  [self inputLBL:lbl.text];
        
        [textField resignFirstResponder];
         _addressFld.text = nil;
    }
    if (_phnTxtfld.resignFirstResponder) {
        lbl.text = _phnTxtfld.text;
        size=  [self inputLBL:lbl.text];
        
        [textField resignFirstResponder];
        _phnTxtfld.text = nil;
    }
    if (_emailfld.resignFirstResponder) {
         lbl.text = _emailfld.text;
        size=  [self inputLBL:lbl.text];
        
        [textField resignFirstResponder];
         _emailfld.text = nil;
    }
    if (_weblink.resignFirstResponder) {
        lbl.text = _weblink.text;
        size=  [self inputLBL:lbl.text];
        
        [textField resignFirstResponder];
        _weblink.text = nil;
    }
    lbl.frame=CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, size.width, size.height);
 }
- (IBAction)emailBTN:(id)sender
{
    [_addresButton setBackgroundImage:[UIImage imageNamed:@"pre_addressBtn"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"pre_email_selected"] forState:UIControlStateNormal];
    [_WebBTN setBackgroundImage:[UIImage imageNamed:@"pre_websiteBtn"] forState:UIControlStateNormal];
    [_fountButton setBackgroundImage:[UIImage imageNamed:@"pre_frantBtn"] forState:UIControlStateNormal];
    [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone"] forState:UIControlStateNormal];
    [_LogoButton setBackgroundImage:[UIImage imageNamed:@"pre_logoBtn"] forState:UIControlStateNormal];
    [_changeBTN setBackgroundImage:[UIImage imageNamed:@"pre_changeBtn"] forState:UIControlStateNormal];
    [_backGButton setBackgroundImage:[UIImage imageNamed:@"pre_backBtn"] forState:UIControlStateNormal];
    
    _phnTxtfld.hidden = YES;
    _weblink.hidden = YES;
    _emailfld.hidden = NO;
    _addressFld.hidden = YES;
    _ColorView.hidden = YES;
    _fontsize.hidden =YES;
    _colorBTN.hidden = YES;
    _fontNameTxtfld.hidden = YES;
    _fonttype.text=@"Email Address";
    _font_dis.text = @"Please enter Email Address the box below";
    _addressFld.text= nil;
     btnSelectTag=6;

}

- (IBAction)webButton:(id)sender
{
    [_addresButton setBackgroundImage:[UIImage imageNamed:@"pre_addressBtn"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"pre_emailBtn"] forState:UIControlStateNormal];
    [_WebBTN setBackgroundImage:[UIImage imageNamed:@"pre_web_selectd"] forState:UIControlStateNormal];
    [_fountButton setBackgroundImage:[UIImage imageNamed:@"pre_frantBtn"] forState:UIControlStateNormal];
    [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone"] forState:UIControlStateNormal];
    [_LogoButton setBackgroundImage:[UIImage imageNamed:@"pre_logoBtn"] forState:UIControlStateNormal];
    [_changeBTN setBackgroundImage:[UIImage imageNamed:@"pre_changeBtn"] forState:UIControlStateNormal];
    [_backGButton setBackgroundImage:[UIImage imageNamed:@"pre_backBtn"] forState:UIControlStateNormal];
   
    _phnTxtfld.hidden = YES;
    _weblink.hidden = NO;
    _emailfld.hidden = YES;
    _addressFld.hidden = YES;
    _ColorView.hidden = YES;
    _fontsize.hidden =YES;
    _colorBTN.hidden = YES;
    _fontNameTxtfld.hidden = YES;
    _fonttype.text=@"WebSite Address";
    _font_dis.text = @"Please enter website address the box below";
    _addressFld.text= nil;
     btnSelectTag=4;
}

- (IBAction)fontBTN:(id)sender
{
    
    _fonttype.text=@"Font";
    _font_dis.text = @"Please select font family, font size and font color";
    
    [_addresButton setBackgroundImage:[UIImage imageNamed:@"pre_addressBtn"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"pre_emailBtn"] forState:UIControlStateNormal];
    [_WebBTN setBackgroundImage:[UIImage imageNamed:@"pre_websiteBtn"] forState:UIControlStateNormal];
    [_fountButton setBackgroundImage:[UIImage imageNamed:@"pre_font_select"] forState:UIControlStateNormal];
    [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone"] forState:UIControlStateNormal];
    [_LogoButton setBackgroundImage:[UIImage imageNamed:@"pre_logoBtn"] forState:UIControlStateNormal];
    [_changeBTN setBackgroundImage:[UIImage imageNamed:@"pre_changeBtn"] forState:UIControlStateNormal];
    [_backGButton setBackgroundImage:[UIImage imageNamed:@"pre_backBtn"] forState:UIControlStateNormal];
    
    _phnTxtfld.hidden = YES;
    _weblink.hidden = YES;
    _emailfld.hidden = YES;
    _addressFld.hidden = YES;
    _ColorView.hidden = YES;
    _fontsize.hidden =NO;
    _colorBTN.hidden = NO;
    _fontNameTxtfld.hidden = NO;
   
}

- (IBAction)phoneBTN:(id)sender
{
    btnSelectTag=3;
    [_addresButton setBackgroundImage:[UIImage imageNamed:@"pre_addressBtn"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"pre_emailBtn"] forState:UIControlStateNormal];
    [_WebBTN setBackgroundImage:[UIImage imageNamed:@"pre_websiteBtn"] forState:UIControlStateNormal];
    [_fountButton setBackgroundImage:[UIImage imageNamed:@"pre_frantBtn"] forState:UIControlStateNormal];
    [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone_select"] forState:UIControlStateNormal];
    
    [_LogoButton setBackgroundImage:[UIImage imageNamed:@"pre_logoBtn"] forState:UIControlStateNormal];
    [_changeBTN setBackgroundImage:[UIImage imageNamed:@"pre_changeBtn"] forState:UIControlStateNormal];
    [_backGButton setBackgroundImage:[UIImage imageNamed:@"pre_backBtn"] forState:UIControlStateNormal];
    
    
    _phnTxtfld.hidden = NO;
    _weblink.hidden = YES;
    _emailfld.hidden = YES;
    _addressFld.hidden = YES;
    _ColorView.hidden = YES;
    _fontsize.hidden =YES;
    _colorBTN.hidden = YES;
    _fontNameTxtfld.hidden = YES;
    _fonttype.text=@"Phone Number";
    _font_dis.text = @"Please enter Phone Number the box below";
    _addressFld.text= nil;
    
}

- (IBAction)Segment:(UIButton*)sender {
    
    if (_segmenindex.selectedSegmentIndex==0)
    {
        _backView.hidden = YES;
        _d_viewBC.hidden = NO;
        
         [_imageView sd_setImageWithURL:[NSURL URLWithString:[singleton.CardDetail valueForKey:@"img_url4"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
       
         [_temp_logo sd_setImageWithURL:[NSURL URLWithString:[singleton.userDetail objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
       // [self frameSetLable:self.d_viewBC];
    }
    else if (_segmenindex.selectedSegmentIndex==1)
    {
        _backView.hidden = NO;
        _d_viewBC.hidden = YES;

        [_backImage sd_setImageWithURL:[NSURL URLWithString:[singleton.CardDetail valueForKey:@"img_url2"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [_profileImage sd_setImageWithURL:[NSURL URLWithString:[singleton.userDetail objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
       
    }
}
- (IBAction)BackGroundBTN:(id)sender
{
    if ([singleton.category_id isEqualToString:@"6"])
    {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BackgroundView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"BackgroundView"];
    ivc.providesPresentationContextTransitionStyle = YES;
    ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    ivc.definesPresentationContext = YES;
    [ivc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController pushViewController:ivc animated:NO];
    }else
    {
        [GlobleClass alertWithMassage:@"Sorry this option is available only incase of custom template" Title:@"Alert!"];
    }
    
    [_addresButton setBackgroundImage:[UIImage imageNamed:@"pre_addressBtn"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"pre_emailBtn"] forState:UIControlStateNormal];
    [_WebBTN setBackgroundImage:[UIImage imageNamed:@"pre_websiteBtn"] forState:UIControlStateNormal];
    [_fountButton setBackgroundImage:[UIImage imageNamed:@"pre_frantBtn"] forState:UIControlStateNormal];
    [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone"] forState:UIControlStateNormal];
     [_LogoButton setBackgroundImage:[UIImage imageNamed:@"pre_logoBtn"] forState:UIControlStateNormal];
     [_changeBTN setBackgroundImage:[UIImage imageNamed:@"pre_changeBtn"] forState:UIControlStateNormal];
     [_backGButton setBackgroundImage:[UIImage imageNamed:@"pre_back_selected"] forState:UIControlStateNormal];
}
- (IBAction)logoBTN:(id)sender
{
    [_addresButton setBackgroundImage:[UIImage imageNamed:@"pre_addressBtn"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"pre_emailBtn"] forState:UIControlStateNormal];
    [_WebBTN setBackgroundImage:[UIImage imageNamed:@"pre_websiteBtn"] forState:UIControlStateNormal];
    [_fountButton setBackgroundImage:[UIImage imageNamed:@"pre_frantBtn"] forState:UIControlStateNormal];
    [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone_select"] forState:UIControlStateNormal];
     [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone"] forState:UIControlStateNormal];
    
    [_LogoButton setBackgroundImage:[UIImage imageNamed:@"pre_logo_select"] forState:UIControlStateNormal];
    [_changeBTN setBackgroundImage:[UIImage imageNamed:@"pre_changeBtn"] forState:UIControlStateNormal];
    [_backGButton setBackgroundImage:[UIImage imageNamed:@"pre_backBtn"] forState:UIControlStateNormal];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    LogoView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"LogoView"];
//    ivc.providesPresentationContextTransitionStyle = YES;
//    ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    ivc.definesPresentationContext = YES;
//    [ivc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//    [self presentViewController:ivc animated:YES completion:nil];

        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"  style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"\ue008 Take New Picture"  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self cameraAction];
            
        }];
        
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"     \ue03b Choose From Library"  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self galleryAction];
            
        }];
        
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Choose Profile Picture"];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:23.0]
                      range:NSMakeRange(0, 22)];
        [actionSheet setValue:hogan forKey:@"attributedTitle"];
       [actionSheet addAction:cancelAction];
        [actionSheet addAction:cameraAction];
        [actionSheet addAction:libraryAction];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
- (void)cameraAction {
        UIImagePickerController *pickercontroller = [[UIImagePickerController alloc] init];
        pickercontroller.delegate = self;
        pickercontroller.allowsEditing = YES;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [myAlertView show];
        }
        else
        {
            pickercontroller.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickercontroller animated:YES completion:NULL];
        }
    }
    
    -(void)galleryAction {
        UIImagePickerController *pickercontroller = [[UIImagePickerController alloc] init];
        pickercontroller.delegate = self;
        pickercontroller.allowsEditing = YES;
        pickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickercontroller animated:YES completion:NULL];
    }
    
    - (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)sourceImage editingInfo:(NSDictionary *)editingInfo
    {
        float i_width = 320;
        float oldWidth = sourceImage.size.width;
        float scaleFactor = i_width / oldWidth;
        float newHeight = sourceImage.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData * pic = UIImageJPEGRepresentation(newImage, scaleFactor);
        
        if (_segmenindex.selectedSegmentIndex==1)
        {
            _profileImage.image = [UIImage imageWithData:pic];
        }
        else
        {
            _temp_logo.image = [UIImage imageWithData:pic];
        }

        //strEncoded = [Base64 encode:pic];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickercontroller
{
        [pickercontroller dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)changeNTB:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SizesetClassVC *ivc = [storyboard instantiateViewControllerWithIdentifier:@"SizesetClassVC"];
    ivc.providesPresentationContextTransitionStyle = YES;
    ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    ivc.definesPresentationContext = YES;
    [ivc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//    [self presentViewController:ivc animated:YES completion:nil];
    
//    if (![singleton.category_id isEqualToString:@"6"])
//    {
//       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        SizesetClassVC *ivc = [storyboard instantiateViewControllerWithIdentifier:@"SizesetClassVC"];
//        ivc.providesPresentationContextTransitionStyle = YES;
//        ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        ivc.definesPresentationContext = YES;
//        [ivc setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self.navigationController pushViewController:ivc animated:YES];
//
//    }else
//    {
//        [GlobleClass alertWithMassage:@"Sorry this option is available only incase of custom template" Title:@"Alert!"];
//    }
    [_addresButton setBackgroundImage:[UIImage imageNamed:@"pre_addressBtn"] forState:UIControlStateNormal];
    [_emailButton setBackgroundImage:[UIImage imageNamed:@"pre_emailBtn"] forState:UIControlStateNormal];
    [_WebBTN setBackgroundImage:[UIImage imageNamed:@"pre_websiteBtn"] forState:UIControlStateNormal];
    [_fountButton setBackgroundImage:[UIImage imageNamed:@"pre_frantBtn"] forState:UIControlStateNormal];
    [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone_select"] forState:UIControlStateNormal];
    [_phonebutton setBackgroundImage:[UIImage imageNamed:@"pre_phone"] forState:UIControlStateNormal];
    [_LogoButton setBackgroundImage:[UIImage imageNamed:@"pre_logoBtn"] forState:UIControlStateNormal];
    [_changeBTN setBackgroundImage:[UIImage imageNamed:@"pre_changeselected"] forState:UIControlStateNormal];
    [_backGButton setBackgroundImage:[UIImage imageNamed:@"pre_backBtn"] forState:UIControlStateNormal];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

-(CGSize)inputLBL:(NSString*)lableStr{
    
    CGSize constraint = CGSizeMake(296,9999);
    CGSize size = [lbl.text sizeWithFont:[UIFont systemFontOfSize:lbl.font.pointSize]
                       constrainedToSize:constraint
                           lineBreakMode:UILineBreakModeWordWrap];
    
    return size;
}
-(void)frameSetLable:(UIView*)myView
{
    NSMutableArray * dataArr = [[NSMutableArray alloc]init];
    [dataArr addObject:[singleton.userDetail objectForKey:@"name"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"company"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"designation"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"mobile"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"website"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"address"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"emailid"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"facebook"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"linkedin"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"twitter"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"skype"]];
    [dataArr addObject:[singleton.userDetail objectForKey:@"tagline"]];

    
    NSLog(@"my data : %@",dataArr);
    
    int yPosition=3;
    
    for (int i=0; i<dataArr.count; i++) {
        lbl=[[UILabel alloc] init];
        lbl.font = [UIFont systemFontOfSize:10];
        lbl.text=[dataArr objectAtIndex:i];
        
        CGSize size=[self inputLBL:lbl.text];
        
        lbl.frame=CGRectMake(100, yPosition, size.width, size.height);
        lbl.tag=i;
        
        _selectedView=[[CustomStriker alloc] initWithContentView:lbl isMove:YES];
        _selectedView.delegate = self;
        _selectedView.inititalSize=CGRectMake(myView.frame.size.width/4, myView.frame.size.height/4, myView.frame.size.width, myView.frame.size.height);
        _selectedView.mainCanvasFrm=myView.frame;
        _selectedView.tag=i;
        yPosition=yPosition+size.height+3;
        [myView addSubview:_selectedView];
        
        if (lbl.tag==5) {
            
           _userResizableView = [[SPUserResizableView alloc] initWithFrame:CGRectMake(250, yPosition+5, size.width, 50)];
            lbl.frame = CGRectMake(250, yPosition+5, size.width, size.height);
            _userResizableView.contentView = lbl;
            _userResizableView.delegate = self;
            lbl.text=[dataArr objectAtIndex:i];
            lbl.numberOfLines=0;
            lbl.lineBreakMode = NSLineBreakByWordWrapping;
            _userResizableView.tag =5;
            
            [_userResizableView showEditingHandles];
            currentlyEditingView = _userResizableView;
            lastEditedView = _userResizableView;
            [myView addSubview:_userResizableView];
            
//            _selectedView=[[CustomStriker alloc] initWithContentView:lbl isMove:YES];
//             lbl.text = @"ufguds ugefteiruw i8erhg  ";
//            _selectedView.delegate = self;
//            _selectedView.inititalSize=CGRectMake(myView.frame.size.width/4, myView.frame.size.height/4, myView.frame.size.width, myView.frame.size.height);
            
        }
        UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [gestureRecognizer addTarget:self action:@selector(onLongPress:)];
        gestureRecognizer.delegate = self;
        [lbl addGestureRecognizer: gestureRecognizer];
        lbl.userInteractionEnabled = YES;
        
        
        UILongPressGestureRecognizer *back = [[UILongPressGestureRecognizer alloc] init];
        [back addTarget:self action:@selector(deleteimage)];
        back.delegate = self;
        [_profileImage addGestureRecognizer: back];
        _profileImage.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *front = [[UILongPressGestureRecognizer alloc] init];
        [front addTarget:self action:@selector(deleteimage)];
        front.delegate = self;
        [_temp_logo addGestureRecognizer: front];
        _temp_logo.userInteractionEnabled = YES;

        
        UITapGestureRecognizer *gestureRecognizerTOUCH = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
        [gestureRecognizerTOUCH setDelegate:self];
        [myView addGestureRecognizer:gestureRecognizerTOUCH];
        
    }

}

- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView1 {
    [currentlyEditingView hideEditingHandles];
    currentlyEditingView = userResizableView1;
}

- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView1 {
    lastEditedView = userResizableView1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([currentlyEditingView hitTest:[touch locationInView:currentlyEditingView] withEvent:nil]) {
        return NO;
    }
    return YES;
}

- (void)hideEditingHandles {
    [lastEditedView hideEditingHandles];
}


-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{
    if (pGesture.state == UIGestureRecognizerStateRecognized)
    {
        //Do something to tell the user!
    }
    if (pGesture.state == UIGestureRecognizerStateEnded)
    {
        NSArray *components= self.selectedView.subviews;
        for (UILabel *currentObj in components)
        {
            lbl=currentObj;
            [self deleteStriker:_selectedView];
        }
    }
}
- (void)setSelectedView:(CustomStriker *)selectedView {
    
    if (_selectedView != selectedView) {
        
        _selectedView = selectedView;
    }
    
    if (_selectedView) {
        [_selectedView.superview bringSubviewToFront:_selectedView];
    }
    
}
- (void)stickerViewDidBeginMoving:(CustomStriker *)stickerView
{
        self.selectedView = stickerView;
    
}

- (void)stickerViewDidTap:(CustomStriker *)stickerView {
    NSArray *components=stickerView.subviews;
    
    for (UILabel *currentObj in components) {
        lbl=currentObj;
    }
    
    self.selectedView = stickerView;
}

#pragma mark CustomStriker Delegate Methods

-(void)stikerViewZoom:(CustomStriker *)stickerView{
    
    self.selectedView = stickerView;
    
}

-(void)deleteStriker:(CustomStriker *)stickerView{
    
    UIAlertController* alertAS = [UIAlertController alertControllerWithTitle:nil message:@"Areyou sure you want to delete this information from the BiznessEcard " preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera=[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                           {
                              lbl.text=@"";
                               
                           }];
    [alertAS addAction:camera];
    
    UIAlertAction *Cancelaction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancelaction");
    }];
    
    
    [alertAS addAction:Cancelaction];
    
    alertAS.popoverPresentationController.sourceView = self.view;
    alertAS.popoverPresentationController.sourceRect = CGRectMake(_selectedView.frame.origin.x+100, _selectedView.frame.origin.y+100,100,100);
    
    [self presentViewController:alertAS animated:YES completion:nil];
    
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)pinchGesture
{
    if (UIGestureRecognizerStateBegan == pinchGesture.state ||
        UIGestureRecognizerStateChanged == pinchGesture.state) {
        
        // Use the x or y scale, they should be the same for typical zooming (non-skewing)
        float currentScale = [[pinchGesture.view.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        
        // Variables to adjust the max/min values of zoom
        float minScale = 0.5;
        float maxScale = 1.5;
        float zoomSpeed = 1.5;
        
        float deltaScale = pinchGesture.scale;
        
        // You need to translate the zoom to 0 (origin) so that you
        // can multiply a speed factor and then translate back to "zoomSpace" around 1
        deltaScale = ((deltaScale - 1) * zoomSpeed) + 1;
        
        // Limit to min/max size (i.e maxScale = 2, current scale = 2, 2/2 = 1.0)
        //  A deltaScale is ~0.99 for decreasing or ~1.01 for increasing
        //  A deltaScale of 1.0 will maintain the zoom size
        deltaScale = MIN(deltaScale, maxScale / currentScale);
        deltaScale = MAX(deltaScale, minScale / currentScale);
        
        CGAffineTransform zoomTransform = CGAffineTransformScale(pinchGesture.view.transform, deltaScale, deltaScale);
        pinchGesture.view.transform = zoomTransform;
        
        // Reset to 1 for scale delta's
        //  Note: not 0, or we won't see a size: 0 * width = 0
        pinchGesture.scale = 1;
    }}

- (void)twoFingerPinch1:(UIPinchGestureRecognizer *)pinchGesture
{
    if (UIGestureRecognizerStateBegan == pinchGesture.state ||
        UIGestureRecognizerStateChanged == pinchGesture.state) {
        
        // Use the x or y scale, they should be the same for typical zooming (non-skewing)
        float currentScale = [[pinchGesture.view.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        
        // Variables to adjust the max/min values of zoom
        float minScale = 0.5;
        float maxScale = 1.5;
        float zoomSpeed = 1.5;
        
        float deltaScale = pinchGesture.scale;
        
        // You need to translate the zoom to 0 (origin) so that you
        // can multiply a speed factor and then translate back to "zoomSpace" around 1
        deltaScale = ((deltaScale - 1) * zoomSpeed) + 1;
        
        // Limit to min/max size (i.e maxScale = 2, current scale = 2, 2/2 = 1.0)
        //  A deltaScale is ~0.99 for decreasing or ~1.01 for increasing
        //  A deltaScale of 1.0 will maintain the zoom size
        deltaScale = MIN(deltaScale, maxScale / currentScale);
        deltaScale = MAX(deltaScale, minScale / currentScale);
        
        CGAffineTransform zoomTransform = CGAffineTransformScale(pinchGesture.view.transform, deltaScale, deltaScale);
        pinchGesture.view.transform = zoomTransform;
        
        // Reset to 1 for scale delta's
        //  Note: not 0, or we won't see a size: 0 * width = 0
        pinchGesture.scale = 1;
    }}

-(void)deleteimage{
    
    UIAlertController* alertAS = [UIAlertController alertControllerWithTitle:nil message:@"Areyou sure you want to delete Logo from the BiznessEcard " preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera=[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                           {
                               if (_segmenindex.selectedSegmentIndex==0)
                               {
                                   [_temp_logo removeFromSuperview];                               }
                               else
                               {
                                [_profileImage removeFromSuperview];
                               }
                               
                           }];
    [alertAS addAction:camera];
    
    UIAlertAction *Cancelaction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancelaction");
    }];
    
    
    [alertAS addAction:Cancelaction];
    [self presentViewController:alertAS animated:YES completion:nil];
    
}


@end
