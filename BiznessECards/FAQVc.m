//
//  FAQVc.m
//  BiznessEcards
//
//  Created by JItendra Yadav on 8/8/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "FAQVc.h"
#import "MainView.h"
#import "DefinesAndHeaders.h"

@interface FAQVc ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataArr;
}
@end

@implementation FAQVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    NetworkStatus status=[reach currentReachabilityStatus];
    
    NSString *url=[NSString stringWithFormat:@"%@getFaq/",BaseUrl];
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
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
         NSLog(@"====%@",dic);

        dataArr = [dic objectForKey:@"faq_list"];
        [_TV reloadData];
    }else
    {
        [GlobleClass alertWithMassage:@"No FAQ Detail found for given User" Title:@"Alert!"];
    
    }

       
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    
    
    NSLog(@"====%@",dic);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    templatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_faq"];
    
    cell.QuesLBL.text =[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"question"]];
    
    NSString *htmlString = [[dataArr objectAtIndex:indexPath.row]valueForKey:@"answer"];
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSRange range = (NSRange){0,[str length]};
    [str enumerateAttribute:NSFontAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        UIFont* currentFont = value;
        UIFont *replacementFont = nil;
        
        if ([currentFont.fontName rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            replacementFont = [UIFont boldSystemFontOfSize:15];
        } else {
            replacementFont = [UIFont systemFontOfSize:14];
        }
        
        [str addAttribute:NSFontAttributeName value:replacementFont range:range];
    }];
    
    cell.ansLBL.text =[NSString stringWithFormat:@"%@",str.string];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (IBAction)backBTN:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainView *ivc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:ivc animated:NO];
}

@end
