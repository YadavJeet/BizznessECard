//
//  CardShareVC.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 8/5/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "CardShareVC.h"
#import "DefinesAndHeaders.h"
#import "CardshareCell.h"
#import "MycardVC.h"

@interface CardShareVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableString *cellText;
    NSMutableArray *cellArray;
    NSMutableArray *dataArray;
    UIView *backView;
    NSMutableArray*cellSelected;
    int submit;
}
@end

@implementation CardShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    cellSelected = [[NSMutableArray alloc]init];
    cellArray = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    self.title = @"Register User's";
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@registeredUserList/",BaseUrl];
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
    if (submit ==1)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MycardVC *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MycardVC"];
        [self.navigationController pushViewController:ivc animated:NO];
        submit=0;
    }
    else if ([[dic objectForKey:@"responsecode"] boolValue])
    {
          dataArray = [dic objectForKey:@"userList"];
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
- (IBAction)backBTN:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardshareCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"CardshareCell" owner:self options:nil] firstObject];
    
     cell.name.text = [NSString stringWithFormat:@"%@",[self ValidateStringWithKey:@"name" forIndexPath:indexPath]];
    cell.user_image.layer.cornerRadius = 30;
    cell.user_image.clipsToBounds = YES;
    
    [cell.user_image sd_setImageWithURL:[NSURL URLWithString:[self ValidateStringWithKey:@"image" forIndexPath:indexPath]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
    
    
    
    _TV.tintColor =  [UIColor blackColor];
    
    if ([cellSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([cellSelected containsObject:indexPath])
    {
        [cellSelected removeObject:indexPath];
        [cellArray removeObject:[[dataArray objectAtIndex:indexPath.row]objectForKey:@"userid"]];
         NSLog(@"remove: %@",cellArray);
    }
    else
    {
        [cellSelected addObject:indexPath];
        [cellArray addObject:[[dataArray objectAtIndex:indexPath.row]objectForKey:@"userid"]];
        NSLog(@"add: %@",cellArray);
    }
    [tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(NSString*)ValidateStringWithKey:(NSString*)key forIndexPath:(NSIndexPath*)indexpath
{
    NSString *string  = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexpath.row] objectForKey:key]];
    
    if ([string isKindOfClass:[NSNull class]] || string.length<=0 || string==NULL) {
        return string =@"";
        
    }
    else return string;
}


- (IBAction)submitBTN:(id)sender
{
    cellText = [[NSMutableString alloc] init];
    if (cellArray.count==0)
    {
        [GlobleClass alertWithMassage:@"please select user " Title:@"Alert!"];
        
    }
    else{
        
    for (int i=0; i<cellArray.count; i++) {
        [cellText appendString:[cellArray objectAtIndex:i]];
        if (i< cellArray.count-1)
        {
            [cellText appendString:@","];
        }
        NSLog(@"%@",cellText);
      }
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
        
    NSString *url=[NSString stringWithFormat:@"%@biznesscardShare/",BaseUrl];
        
    NSLog(@"Url %@",url);
    
    if (status) {
        submit = 1;
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSUserDefaults objectForKey:@"userID"] forKey:@"userid"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setPostValue:[NSString stringWithFormat:@"%lu",(unsigned long)cellArray.count] forKey:@"sharedcount"];
        [request setPostValue:cellText forKey:@"shareto"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
    }
    }

}

@end
