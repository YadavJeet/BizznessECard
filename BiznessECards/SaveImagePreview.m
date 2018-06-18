//
//  SaveImagePreview.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 8/2/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "SaveImagePreview.h"
#import "DefinesAndHeaders.h"
#import "MainView.h"
@interface SaveImagePreview ()
{
    Singleton *singleton;
    int saveExit;
}
@property (weak, nonatomic) IBOutlet UIImageView *front_image;
@property (weak, nonatomic) IBOutlet UIImageView *back_image;

@end

@implementation SaveImagePreview

- (void)viewDidLoad
{
    singleton = [Singleton createInstance];
    self.title = @"Preview Your Card Design";
    _front_image.image = [UIImage imageWithData:singleton.image1];
    _back_image.image = [UIImage imageWithData:singleton.image2];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBTN:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveBTN:(id)sender
{
    NSString *image1 = [Base64 encode:singleton.image1];
    NSString *image2 = [Base64 encode:singleton.image2];
    if (image1.length<=0)
    {
        [GlobleClass alertWithMassage:@"Please Save Front view design" Title:@"Alert!"];
    }
   else if (image2.length<=0)
    {
        [GlobleClass alertWithMassage:@"Please Save Back view design" Title:@"Alert!"];
    }else
    {
        [self serviceCall:image1 backimage:image2];
    }
    
}

- (IBAction)saveBTNandExit:(id)sender
{
    NSString *image1 = [Base64 encode:singleton.image1];
    NSString *image2 = [Base64 encode:singleton.image2];
    if (image1.length<=0)
    {
        [GlobleClass alertWithMassage:@"Please Save Front view design" Title:@"Alert!"];
    }
    else if (image2.length<=0)
    {
        [GlobleClass alertWithMassage:@"Please Save Back view design" Title:@"Alert!"];
    }else
    {
        saveExit =1;
        [self serviceCall:image1 backimage:image2];

    }
}

-(void)serviceCall :(NSString*)image1 backimage:(NSString*)image2
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    NSString *url=[NSString stringWithFormat:@"%@savedBiznesCard/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setPostValue:image1 forKey:@"frontview"];
        [request setPostValue:image2 forKey:@"backview"];
        [request setPostValue:@"back" forKey:@"displayview2"];
        [request setPostValue:@"front" forKey:@"displayview1"];
        [request setPostValue:[singleton.CardDetail valueForKey:@"template_id"] forKey:@"templateid"];
        [request setPostValue:singleton.category_id forKey:@"id"];
        NSLog(@"UserID: %@",[NSUserDefaults objectForKey:@"userID"]);
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }
}
-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    
    if (saveExit==1)
    {
        if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        singleton.savecard_id = [dic objectForKey:@"savedcard_id"];
        saveExit=0;
        [GlobleClass alertWithMassage:@"Card save Successfully." Title:@"Alert!"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        [self.navigationController pushViewController:ivc animated:NO];

    }
    }
   else if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        singleton.savecard_id = [dic objectForKey:@"savedcard_id"];
        [self performSegueWithIdentifier:@"payment1" sender:self];
    }
    else
    {
        [GlobleClass alertWithMassage:@"Card not save . try again..." Title:@"Alert!"];
    }
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}


@end
