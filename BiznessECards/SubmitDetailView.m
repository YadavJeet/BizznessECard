//
//  SubmitDetailView.m
//  BiznessECards
//  Created by Tarun Pal on 5/16/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "SubmitDetailView.h"
#import "DefinesAndHeaders.h"
#import "MainView.h"

@interface SubmitDetailView ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IQKeyboardReturnKeyHandler * returnKeyHandler;
    NSString *strEncoded;
    Singleton*singleton;
    int set_id;
}
@end
    
@implementation SubmitDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    singleton = [Singleton createInstance];
    self.title = @"BiznessEcards";
    
    if (IS_IPHONE_6P) {
        _btn_height.constant = 750;
        
    }else if (IS_IPHONE_5){
        _btn_height.constant = 650;
    }
    _address_textfld.delegate = self;
    _address_textfld.text = @" Address";
    _address_textfld.textColor= [UIColor lightGrayColor];
    _address_textfld.layer.cornerRadius=5.0f;
    _address_textfld.layer.masksToBounds=YES;
    _address_textfld.layer.borderColor = [[UIColor colorWithRed:0.92 green:0.91 blue:0.91 alpha:1.0]CGColor];
    _address_textfld.layer.borderWidth = 1.0f;
    
    _menuBtn.target = self.revealViewController;
    _menuBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    _Company_name.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"company"]];
            _slogan_textfld.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"tagline"]];
    _full_name.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"name"]];
    
    _mobile_number.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"mobile"]];
    
    _job_title.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"designation"]];
    _email_id.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"emailid"]];
    
    _address_textfld.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"address"]];
    _website_textfld.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"website"]];
    
    _facebook_FLD.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"facebook"]];
    _linked_in_FLD.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"linkedin"]];
    
    _twitter_FLD.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"twitter"]];
    _skype_FLD.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"skype"]];
    
    _address_textfld.textColor= [UIColor blackColor];
    

    // Do any additional setup after loading the view.
}
- (IBAction)backBTN:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:ivc animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}
- (IBAction)SaveBTN:(id)sender
{
    if (_full_name.text.length<=0 ||_email_id.text.length<=0 ||_mobile_number.text.length<=0 ||_job_title.text.length<=0 || _address_textfld.text.length<=0 || _website_textfld.text.length<=0 )
    {
        [GlobleClass alertWithMassage:@"please your enter detail's" Title:@"Error!"];
    }
    else if (![GlobleClass NSStringIsValidEmail:_email_id.text])
    {
        [GlobleClass alertWithMassage:@"Please enter valid email address." Title:@"Error!"];
    }
    else if (![GlobleClass validateNumber:_mobile_number.text])
    {
        [GlobleClass alertWithMassage:@"Please enter valid mobile number" Title:@"Error!"];
    }else if ([_address_textfld.text isEqualToString:@" Address"])
    {
        [GlobleClass alertWithMassage:@"Please enter address" Title:@"Error!"];
    }
    else{
    
    
        [SVProgressHUD showWithStatus:@"Please Wait..."];
        Reachability *reach=[Reachability reachabilityForInternetConnection];
        
        NetworkStatus status=[reach currentReachabilityStatus];
        
        NSString *url=[NSString stringWithFormat:@"%@saveBizCard/",BaseUrl];
        NSLog(@"Url %@",url);
        
        if (status) {
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
            [request setPostValue:_Company_name.text forKey:@"company"];
            [request setPostValue:_slogan_textfld.text forKey:@"tagline"];
            [request setPostValue:_job_title.text forKey:@"designation"];
            [request setPostValue:_email_id.text forKey:@"emailid"];
            [request setPostValue:_facebook_FLD.text forKey:@"facebook"];
            [request setPostValue:_address_textfld.text forKey:@"address"];
            [request setPostValue:_website_textfld.text forKey:@"website"];
            [request setPostValue:_linked_in_FLD.text forKey:@"linkedin"];
            [request setPostValue:_twitter_FLD.text forKey:@"twitter"];
            [request setPostValue:_skype_FLD.text forKey:@"skype"];
            if (strEncoded.length<=0)
            {
                NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"logo"]]];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                strEncoded= [Base64 encode:imageData];
                [request setPostValue:strEncoded forKey:@"logo"];
            }else
            {
                [request setPostValue:strEncoded forKey:@"logo"];
            }
            
            [request setPostValue:_mobile_number.text forKey:@"mobile"];
            [request setPostValue:_full_name.text forKey:@"name"];
            [request setPostValue:@"qwerty" forKey:@"api_user_name"];
            [request setPostValue:@"qwerty" forKey:@"api_key"];
            [request setDidFinishSelector:@selector(uploadRequestFinished:)];
            [request setDidFailSelector:@selector(uploadRequestFailed:)];
            [request startAsynchronous];
        }
      //  NSLog(@"params %@",logins);
    }
}
-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
         [self getUserDetailService];
    }
    else if (set_id == 1)
    {
        singleton.userDetail = dic;
        [self performSegueWithIdentifier:@"detail" sender:self];
        set_id = 0;
    }else
    {
        [GlobleClass alertWithMassage:[dic objectForKey:@"responseMessage"] Title:@"Alert!"];
    }
    
    [SVProgressHUD dismiss];
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@" Address"]) {
        _address_textfld.text = @"";
        textView.textColor = [UIColor blackColor];//optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _address_textfld.text = @" Address";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (IBAction)Upload_logo:(id)sender
{
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlertView show];
        
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

-(void)galleryAction {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
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
    strEncoded = [Base64 encode:pic];
    [self dismissViewControllerAnimated:YES completion:NULL];
 
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)getUserDetailService
{
        [SVProgressHUD showWithStatus:@"Please Wait..."];
        Reachability *reach=[Reachability reachabilityForInternetConnection];
        
        NetworkStatus status=[reach currentReachabilityStatus];
        
        NSString *url=[NSString stringWithFormat:@"%@getBizCard/",BaseUrl];
        NSLog(@"Url %@",url);
        set_id = 1;
        
        if (status) {
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
            [request setPostValue:@"qwerty" forKey:@"api_user_name"];
            [request setPostValue:@"qwerty" forKey:@"api_key"];
            [request setDidFinishSelector:@selector(uploadRequestFinished:)];
            [request setDidFailSelector:@selector(uploadRequestFailed:)];
            [request startAsynchronous];
    }
}
-(NSString*)ValidateStringWithKey:(NSString*)key
{
    NSString *string  = [NSString stringWithFormat:@"%@",[singleton.userDetail objectForKey:key]];
    
    if ([string isKindOfClass:[NSNull class]] || string.length<=0 || string==NULL|| [string  isEqualToString:@"<null>"]) {
        return string = @"";
    }
    else return string;
}

@end
