//
//  ChangeTempletView.m
//  BiznessECards
//
//  Created by Tarun Pal on 5/24/17.
//  Copyright © 2017 Jitendra yadav. All rights reserved.
//

#import "ChangeTempletView.h"
#import "DefinesAndHeaders.h"
#import "ChangeTempCell.h"
#import "FontView.h"
@interface ChangeTempletView ()<SWRevealViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
     NSArray * tempData;
     NSString*catagoryID;
    Singleton * singleton;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

@end

@implementation ChangeTempletView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    singleton = [Singleton createInstance];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    // Do any additional setup after loading the view.
    self.title = @"Select Templete";
    [self servicCall:singleton.category_id];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return tempData.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeTempCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.Fimage sd_setImageWithURL:[NSURL URLWithString:[tempData valueForKey:@"img_url3"][indexPath.row]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]options:SDWebImageRefreshCached];
    
    cell.templetprice.text = [NSString stringWithFormat:@"$%@",[tempData valueForKey:@"price"][indexPath.row]];

    
    //cell.backgroundColor=[UIColor greenColor];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float size = (self.view.frame.size.width)/3 - 15;
    
    return CGSizeMake(size, size);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *templateData = [tempData objectAtIndex:indexPath.row];
    singleton.CardDetail = templateData;
    singleton.card_cost = [templateData valueForKey:@"price"];
    singleton.category_id = catagoryID;
    [self.navigationController popViewControllerAnimated:YES];

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

-(void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:nil];
    NSLog(@"data %@", dic);
    
    if ([[dic objectForKey:@"responsecode"] boolValue])
    {
        _CV.delegate = self;
        _CV.dataSource = self;
        tempData = [dic objectForKey:@"template-list"];
        catagoryID = [dic objectForKey:@"category"];
        [_CV reloadData];
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


- (IBAction)backBTN:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
