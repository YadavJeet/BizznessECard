//
//  OrderSummaryVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 7/27/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "OrderSummaryVC.h"
#import "orderSummary.h"
#import "DefinesAndHeaders.h"
#import "PreviewView.h"
#import "MainView.h"

@interface OrderSummaryVC ()<UITableViewDelegate,UITableViewDataSource>
{
     NSArray*mycardArray;
    Singleton*singleton;
}
@end

@implementation OrderSummaryVC

- (void)viewDidLoad {
    singleton = [Singleton createInstance];
    [super viewDidLoad];
    self.title = @"Your Order Summary";
    [self serviceCall];
    _TV.delegate = self;
    _TV.dataSource = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       orderSummary *cell=[[[NSBundle mainBundle] loadNibNamed:@"orderSummary" owner:self options:nil] firstObject];
    
    [cell.front_image sd_setImageWithURL:[NSURL URLWithString:[self ValidateStringWithKey:@"frontview" forIndexPath:indexPath]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
    
    cell.total_card.text = [NSString stringWithFormat:@"%@ Card",[self ValidateStringWithKey:@"cardcount" forIndexPath:indexPath]];
    
     cell.priceLbl.text = [NSString stringWithFormat:@"$%@",[self ValidateStringWithKey:@"packageprice" forIndexPath:indexPath]];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"dd-MM-yyyy";
//    NSDate *string = [formatter dateFromString:[NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"transactiondate" forIndexPath:indexPath]]];
//    formatter.dateFormat = @"MM-dd-yyyy";
    
    cell.trantn_date.text = [NSString stringWithFormat:@"Transaction Date : %@",[self ValidateStringWithKey:@"transactiondate" forIndexPath:indexPath]];
    [cell.ReOrderBTN addTarget:self action:@selector(re_orderBTN:) forControlEvents:UIControlEventTouchUpInside];
    cell.ReOrderBTN.tag=indexPath.row;
    
    [cell.preViewBTN addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
    cell.preViewBTN.tag=indexPath.row;
    
        return cell;
}

-(void)re_orderBTN:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [mycardArray objectAtIndex:indexPath.row];
    singleton.savecard_id = [templateData valueForKey:@"savedcard_id"];
    NSLog(@"%@",templateData);
    [self performSegueWithIdentifier:@"payment2" sender:self];
}

-(void)preview:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [mycardArray objectAtIndex:indexPath.row];
    NSLog(@"%@",templateData);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreviewView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"PreviewView"];
    [ivc setDeatil:templateData];
    [self.navigationController pushViewController:ivc animated:YES];

}

-(void)serviceCall
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@orderSummary/",BaseUrl];
    NSLog(@"Url %@",url);
    
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
-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
//        mycardArray = [[[dic objectForKey:@"orderSummary_list"] reverseObjectEnumerator] allObjects];
        mycardArray = [dic objectForKey:@"orderSummary_list"];
        [_TV reloadData];
    }else
    {
        [GlobleClass alertWithMassage:[dic objectForKey:@"responseMessage"] Title:@"Alert!"];
    }
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}
- (IBAction)BackBTN:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:ivc animated:NO];
}

-(NSString*)ValidateStringWithKey:(NSString*)key forIndexPath:(NSIndexPath*)indexpath
{
    NSString *string  = [NSString stringWithFormat:@"%@",[[mycardArray objectAtIndex:indexpath.row] objectForKey:key]];
    
    if ([string isKindOfClass:[NSNull class]] || string.length<=0 || string==NULL || [string isEqualToString:@"<null>"]) {
        return string =@"0";
        
    }
    else return string;
}


@end
