//
//  ServerController.m
//  Howee
//
//  Created by Harendra Sharma on 05/08/16.
//  Copyright © 2016 Harendra Sharma. All rights reserved.
//

#import "ServerController.h"
#import <SVProgressHUD.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "DefinesAndHeaders.h"



@implementation ServerController


/*********************************** Check Internet Connectivity *****************************/

- (BOOL)checkNetworkStatusWithAlert:(BOOL)shouldAlert
{
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    BOOL isNetworkAvail = YES;
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            isNetworkAvail = NO;
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            isNetworkAvail = YES;
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            isNetworkAvail = YES;
            break;
        }
    }
    
    if(isNetworkAvail == NO && shouldAlert == YES) {
        
        [GlobleClass alertWithMassage:@"Internet connection appears to be offline. Try again." Title:@"No internet connection!"];
    }
    return isNetworkAvail;
}


/*********************************** Post \ Get Request ***************************/

-(void)PostDataWithParam:(NSMutableDictionary*)params withApi:(NSString*)apiName isNeedLoader:(bool)isNeeded :(Completion)block{
    
    if (isNeeded) [SVProgressHUD showWithStatus:@"Please Wait..."];
    
    if (![self checkNetworkStatusWithAlert:YES]) {
        [SVProgressHUD dismiss];
        return;
    }
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,apiName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSData *postData;
    
    if (params) postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    
    NSLog(@"Post url: %@ \n Post params - %@",url,params);
    
    if (postData && postData.length>0)[request setHTTPBody:postData];  // this validation is for to support get request
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
     NSLog(@"Server Controller, Response code - %li",(long)[(NSHTTPURLResponse *)response statusCode]);
        
        if (error) {
            if (block){
                block(nil, error);
                NSLog(@"Error Occurrd - %@",[error localizedDescription]);
            }
        }
        else
        {
            if (block) {
                NSError *pError;
                NSMutableDictionary * fromResponse = [NSJSONSerialization
                                                      JSONObjectWithData:data options:kNilOptions error:&pError];
                block(fromResponse, nil);
            }
        }
        [SVProgressHUD dismiss];
    }];
    
    [postDataTask resume];
    
}


@end
