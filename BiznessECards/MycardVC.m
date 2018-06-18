//
//  MycardVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/13/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "MycardVC.h"
#import "changePasswordVC.h"
#import "DefinesAndHeaders.h"
#import "ActiveCardCell.h"
#import "SaveCardCell.h"
#import "FriendCardCell.h"
#import "PaymentView.h"
#import "MainView.h"
#import "PreviewView.h"
#import "updateProfile.h"
#import "CardShareVC.h"

@interface MycardVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    NSArray*mycardArray;
    Singleton*singleton;
    int imageupdate;
   
}

@property (nonatomic, strong) UIActivityViewController *activityViewController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *TV;
@property (weak, nonatomic) IBOutlet UILabel *pointNumber;

@end

@implementation MycardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    singleton = [Singleton createInstance];
    self.title = @"Profile & My Card";
    
    _TV.delegate = self;
    _TV.dataSource = self;
    
    _ProfileButton.layer.cornerRadius = 50.0f;
    _ProfileButton.layer.masksToBounds=YES;
    _ProfileButton.layer.borderColor=[[UIColor whiteColor]CGColor];
    _ProfileButton.layer.borderWidth= 2.0f;
    
    

    // Do any additional setup after loading the view.
    if ([_stringvalue isEqualToString:@"1"])
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self serviceCall:@"1"];
    
//    _walletamount_lbl.text =  [NSUserDefaults objectForKey:@"walletamount"];
    
    if (IS_IPHONE_5)
    {
        _trailling.constant = 22;
    }
    else if (IS_IPHONE_6P)
    {
        _trailling.constant = 41;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if ([NSUserDefaults  objectForKey:@"url"] != nil){
        NSData *profileData = [[NSData alloc] initWithData:[NSUserDefaults  objectForKey:@"url"]];
        [_ProfileButton setBackgroundImage:[UIImage imageWithData:profileData] forState:UIControlStateNormal];
    }else
    {
        
    }

    _pointNumber.text = [NSString stringWithFormat:@"$%@",[NSUserDefaults objectForKey:@"walletamount"]];
    _username.text = [NSUserDefaults objectForKey:@"name"];
    _usermailiD.text = [NSUserDefaults objectForKey:@"email"];
    _userNo.text = [NSUserDefaults objectForKey:@"phone"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackBTN:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:ivc animated:NO];
}
- (IBAction)changePasswordBTN:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    changePasswordVC *ivc = [storyboard instantiateViewControllerWithIdentifier:@"changePasswordVC"];
    ivc.providesPresentationContextTransitionStyle = YES;
    ivc.definesPresentationContext = YES;
    ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [ivc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:ivc animated:YES completion:nil];
}



-(IBAction)segmentBtn:(id)sender
{
    if (_segment.selectedSegmentIndex==0)
    {
        [self serviceCall:@"1"];
    }
    if (_segment.selectedSegmentIndex==1)
    {
         [self serviceCall:@"2"];
       
    }
    if (_segment.selectedSegmentIndex==2)
    {
         [self serviceCall:@"3"];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mycardArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segment.selectedSegmentIndex==0)
    {
       ActiveCardCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"ActiveCardCell" owner:self options:nil] firstObject];
        
         [cell.front_image sd_setImageWithURL:[NSURL URLWithString:[self ValidateStringWithKey:@"frontview" forIndexPath:indexPath]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
        
        cell.card_value.text = [NSString stringWithFormat:@"%@ Cards Remaining",[self ValidateStringWithKey:@"availablecount" forIndexPath:indexPath]];
        
        cell.date.text = [NSString stringWithFormat:@" Last Purchase Date : %@",[self ValidateStringWithKey:@"lastpurchasedate" forIndexPath:indexPath]];
        
        [cell.reOrderBTN addTarget:self action:@selector(re_orderBTN:) forControlEvents:UIControlEventTouchUpInside];
        cell.reOrderBTN.tag=indexPath.row;
        
        [cell.shareBTN addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.shareBTN.tag=indexPath.row;
        
        return cell;
    }
    if (_segment.selectedSegmentIndex==1)
    {
        SaveCardCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"SaveCardCell" owner:self options:nil] firstObject];
        
         [cell.image_front sd_setImageWithURL:[NSURL URLWithString:[mycardArray valueForKey:@"frontview"][indexPath.row]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
        
        cell.card_cost.text = [NSString stringWithFormat:@"$%@",[self ValidateStringWithKey:@"cost" forIndexPath:indexPath]];
        
        cell.date.text = [NSString stringWithFormat:@"Last Editing Date : %@",[self ValidateStringWithKey:@"lastediteddate" forIndexPath:indexPath]];
        
        [cell.orderBTN addTarget:self action:@selector(orderBTN:) forControlEvents:UIControlEventTouchUpInside];
        cell.orderBTN.tag=indexPath.row;
        return cell;
    }
    if (_segment.selectedSegmentIndex==2)
    {
        FriendCardCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"FriendCardCell" owner:self options:nil] firstObject];
        
         [cell.image_front sd_setImageWithURL:[NSURL URLWithString:[mycardArray valueForKey:@"frontview"][indexPath.row]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
        
        cell.name.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"name" forIndexPath:indexPath]];
        cell.position.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"designation" forIndexPath:indexPath]];
        [cell.viewDetailBTN addTarget:self action:@selector(viewDetail:) forControlEvents:UIControlEventTouchUpInside];
        cell.viewDetailBTN.tag=indexPath.row;
        return cell;
    }
    
    return nil;
}
-(void)serviceCall: (NSString*)cardType
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@cardList/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setPostValue:cardType forKey:@"type"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }    
}
-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    
    if (imageupdate==1)
    {
        
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"profile_image"]]];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:pictureURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                [NSUserDefaults setObject:data forKey:@"url"];
            }
            else
            {
                NSLog(@"%@",connectionError);
            }
        }];

         [self dismissViewControllerAnimated:YES completion:NULL];
    }
     else if ([[dic objectForKey:@"status"] boolValue])
    {
        NSLog(@"data %@", dic);
        
        NSString*  share = [[NSString alloc]initWithFormat:@"Hi, Please check my BusineeEcard created using the app BiznessEcard :- \n%@ \n\n%@\n\n https://goo.gl/abG9QB",[dic objectForKey:@"frontview"],[dic objectForKey:@"backview"]];
      
        self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[share] applicationActivities:nil];
        [self presentViewController:self.activityViewController animated:YES completion:nil];
    }
    
    else if ([[dic objectForKey:@"responsecode"] boolValue])
    {
//         mycardArray = [[[dic objectForKey:@"savedcard-list"] reverseObjectEnumerator] allObjects];
        mycardArray = [dic objectForKey:@"savedcard-list"];
        [_TV reloadData];
    }
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}

-(void)orderBTN:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [mycardArray objectAtIndex:indexPath.row];
    singleton.savecard_id = [templateData valueForKey:@"savedcard_id"];
    singleton.card_cost = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"cost" forIndexPath:indexPath]];
    [self performSegueWithIdentifier:@"payment" sender:self];
    
}

-(void)re_orderBTN:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [mycardArray objectAtIndex:indexPath.row];
    NSLog(@"%@",templateData);
    singleton.savecard_id = [templateData valueForKey:@"savedcard_id"];
    NSLog(@"%@",singleton.savecard_id);
    [self performSegueWithIdentifier:@"payment" sender:self];
    
}
-(void)viewDetail:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [mycardArray objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreviewView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"PreviewView"];
    [ivc setDeatil:templateData];
    [ivc setCheck:@"1"];
    [self.navigationController pushViewController:ivc animated:YES];
    
}

- (IBAction)ProfileBTN:(id)sender
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
    
    [_ProfileButton setImage:[UIImage imageWithData:pic] forState:UIControlStateNormal];
    imageupdate = 1;
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@updateProfileImg/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setPostValue:[Base64 encode:pic] forKey:@"profile_image"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];

    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickercontroller
{
    [pickercontroller dismissViewControllerAnimated:YES completion:NULL];
}

-(void)shareBtn:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [mycardArray objectAtIndex:indexPath.row];
    NSLog(@"%@",templateData);
    singleton.savecard_id = [templateData valueForKey:@"savedcard_id"];
    NSLog(@"%@",singleton.savecard_id);
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"Do you want to Share card" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *YesAction = [UIAlertAction actionWithTitle:@"Share Register User" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        CardShareVC *spec = [self.storyboard instantiateViewControllerWithIdentifier:@"CardShareVC"];
        [self.navigationController pushViewController:spec animated:YES];
       
    }];
    
    UIAlertAction *NOAction = [UIAlertAction actionWithTitle:@"Other's" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [self whatsAppShare:singleton.savecard_id];
        
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
    
    [actionSheet addAction:YesAction];
    [actionSheet addAction:NOAction];
    [actionSheet addAction:cancle];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}




- (IBAction)editBTN:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    updateProfile *ivc = [storyboard instantiateViewControllerWithIdentifier:@"updateProfile"];
    ivc.providesPresentationContextTransitionStyle = YES;
    ivc.definesPresentationContext = YES;
    ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [ivc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:ivc animated:YES completion:nil];
}


-(NSString*)ValidateStringWithKey:(NSString*)key forIndexPath:(NSIndexPath*)indexpath
{
    NSString *string  = [NSString stringWithFormat:@"%@",[[mycardArray objectAtIndex:indexpath.row] objectForKey:key]];
    
    if ([string isKindOfClass:[NSNull class]] || string.length<=0 || string==NULL) {
        return string =@"";
        
    }
    else return string;
}

-(void)whatsAppShare: (NSString*)savecard_ID
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@whatsappShare/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
    
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setPostValue:savecard_ID forKey:@"savedcard_id"];
        [request setPostValue:@"1" forKey:@"sharedcount"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }
}


@end
