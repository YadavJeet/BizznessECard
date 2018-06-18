//
//  pricingVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 8/10/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "pricingVC.h"
#import "templatCell.h"
#import "MainView.h"
#import "DefinesAndHeaders.h"
#import "SubmitDetailView.h"

@interface pricingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataArr;
    NSMutableArray*cellSelected;
    Singleton*singleton;
}


@end

@implementation pricingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    singleton = [Singleton createInstance];
    // Do any additional setup after loading the view.
    cellSelected = [[NSMutableArray alloc]init];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@/package/",BaseUrl];
    NSLog(@"Url %@",url);
    if (status) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
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
    NSLog(@"Response:  %@", dic);
    
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        dataArr = [dic objectForKey:@"package_list"];
        [_TV reloadData];
    }
 
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    templatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_price"];
    
    cell.name.text =[[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"package_name"]]capitalizedString];
    cell.price_value.text =[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"price"]];
    cell.cardvalue.text =[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"card_count"]];
    
    _TV.tintColor =  [UIColor whiteColor];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    cellSelected = [[NSMutableArray alloc]init];
  [cellSelected addObject:[[dataArr objectAtIndex:indexPath.row]objectForKey:@"id"]];
    singleton.pricing_id = [NSString stringWithFormat:@"%@",cellSelected[0]];
    NSLog(@"add: %@", singleton.pricing_id);
    

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (IBAction)buybtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SubmitDetailView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"SubmitDetailView"];
    [self.navigationController pushViewController:ivc animated:YES];
}

- (IBAction)backBTN:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:ivc animated:NO];
}
@end
