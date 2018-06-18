//
//  SelectTempleteView.m
//  BiznessECards
//  Created by Tarun Pal on 5/16/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.


#import "SelectTempleteView.h"
#import "PreviewView.h"
#import "FontView.h"
#import "DefinesAndHeaders.h"
@interface SelectTempleteView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *templetArr;
    Singleton * singleton;
    NSString *categoryID;
}

@end

@implementation SelectTempleteView

- (void)viewDidLoad {
    singleton = [Singleton createInstance];
    
    [[UILabel appearanceWhenContainedIn:[UISegmentedControl class], nil] setNumberOfLines:0];
    UIFont *font;
    if (IS_IPHONE_5) {
        font = [UIFont boldSystemFontOfSize:8.0f];
        
    }else
    {
        font = [UIFont boldSystemFontOfSize:10.0f];
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_segmentBTN setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];

    [super viewDidLoad];
    self.title = @"BiznessEcards";
    [_segmentBTN setSelectedSegmentIndex:0];
    // Do any additional setup after loading the view.
    _menuBtn.target = self.revealViewController;
    _menuBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
    // service call
    [self servicCall:@"1"];
    
   }

-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);    
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        _TV.delegate = self;
        _TV.dataSource = self;
        templetArr = [dic objectForKey:@"template-list"];
        categoryID = [dic objectForKey:@"category"];
        [_TV reloadData];
    }
    else
    {
        
    }
    
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request {
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"====%@",dic);
}


- (IBAction)backBTN:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segmentBtn:(id)sender
{

    if (_segmentBTN.selectedSegmentIndex==0)
    {
      [self servicCall:@"1"];
    }
    if (_segmentBTN.selectedSegmentIndex==1)
    {
       [self servicCall:@"2"];
    }
    if (_segmentBTN.selectedSegmentIndex==2)
    {
       [self servicCall:@"3"];
    }
    if (_segmentBTN.selectedSegmentIndex==3)
    {
      [self servicCall:@"4"];
    }
    if (_segmentBTN.selectedSegmentIndex==4)
    {
       [self servicCall:@"5"];
    }

    if (_segmentBTN.selectedSegmentIndex==5)
    {
      [self servicCall:@"6"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [templetArr count];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
   
    templatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];;
    
    [cell.Fimage sd_setImageWithURL:[NSURL URLWithString:[templetArr valueForKey:@"img_url3"][indexPath.row]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
    
    [cell.Bimage sd_setImageWithURL:[NSURL URLWithString:[templetArr valueForKey:@"img_url1"][indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
    
    cell.templetprice.text = [NSString stringWithFormat:@"$%@",[templetArr valueForKey:@"price"][indexPath.row]];
    _TV_Height.constant = _TV.contentSize.height;
    [cell.selectBTN addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectBTN.tag=indexPath.row;

    return cell;
}
-(void)addBtn:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:_TV];
    NSIndexPath *indexPath = [_TV indexPathForRowAtPoint:buttonPosition];
    NSArray *templateData = [templetArr objectAtIndex:indexPath.row];
    FontView *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FontView"];
    singleton.CardDetail = templateData;
    singleton.card_cost = [templateData valueForKey:@"price"];
    singleton.category_id = categoryID;
    [self.navigationController pushViewController:VC animated:YES];

}

-(void)servicCall:(NSString *)catID
{
    [SVProgressHUD showWithStatus:@"please wait"];
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    NSString *url=[NSString stringWithFormat:@"%@getTemplate/",BaseUrl];
    NSLog(@"Url %@",url);
    
    if (status) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setPostValue:catID forKey:@"category"];
        [request setPostValue:@"qwerty" forKey:@"api_user_name"];
        [request setPostValue:@"qwerty" forKey:@"api_key"];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        [request startAsynchronous];
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.appDelColor = [UIColor whiteColor];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

@end
