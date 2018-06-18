//
//  ServerController.h
//  Howee
//
//  Created by Harendra Sharma on 05/08/16.
//  Copyright © 2016 Harendra Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Completion)(NSMutableDictionary* response, NSError *error);

//192.168.30.126

#define BaseUrl @"http://biznessecards.com/BiznessEcards/"
#define API_SaveCard @"saveBizCard/"
#define API_login @"login/"
#define API_signup @"registration/"
#define API_otp @"otp/"
#define API_forgotPassword @"forgotPassword/"
#define coupen_code @"discountAmount/"


@interface ServerController : NSObject<NSURLSessionDelegate>


-(void)PostDataWithParam:(NSDictionary*)params withApi:(NSString*)apiName isNeedLoader:(bool)isNeeded :(Completion)block;

@end
