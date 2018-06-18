//
//  CurrentOfferVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 12/16/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "CurrentOfferVC.h"
#import "CurrentOfferCell.h"
#import "DefinesAndHeaders.h"

@interface CurrentOfferVC ()
{
     NSArray *dataArr;
     Singleton*singleton;
     NSMutableArray*cellSelected;

}
@end

@implementation CurrentOfferVC

- (void)viewDidLoad {
    [super viewDidLoad];
     singleton = [Singleton createInstance];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=@"http://biznessecards.com/BiznessEcards/promocode/";
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
        dataArr = [dic objectForKey:@"coupon-list"];
        [_TV reloadData];
    }
    else{
        [GlobleClass alertWithMassage:@"Sorry,currently there are no offers available for you" Title:@"Alert!"];
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
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CurrentOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.Offername.text = [[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"couponcode"]]uppercaseString];
        
    cell.DetailofferLBL.text = [NSString stringWithFormat:@"Use promocode %@ to get $%@ off on your purchase of BiznessEcards.",[[[dataArr objectAtIndex:indexPath.row]valueForKey:@"couponcode"]uppercaseString],[[dataArr objectAtIndex:indexPath.row]valueForKey:@"discountamount"]];
    
    cell.offerValue.text = [[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"discountamount"]]uppercaseString];
    
    NSString *str = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"todate"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString: str];
    dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *convertedString = [dateFormatter stringFromDate:date];
    NSLog(@"Converted String : %@",convertedString);
    cell.date.text = [NSString stringWithFormat:@"Offer valid till %@",convertedString];

    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6 || IS_IPHONE_X) {
        return 140;
    }else if (IS_IPHONE_5)
    {
        return 150;
    }
    else{
        return 125;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (IBAction)backBTN:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
