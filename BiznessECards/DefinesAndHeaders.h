//
//  DefinesAndHeaders.h
//  HashTag
//
//  Created by Harendra on 07/06/16.
//  Copyright © 2016 Afycon. All rights reserved.
//

#ifndef DefinesAndHeaders_h
#define DefinesAndHeaders_h

#define kAppBaseURL @"http://54.190.15.53/hashtag/public/api/"
#define GetClassName NSStringFromClass([self class])


//#define AdUnitID @"ca-app-pub-3940256099942544/2934735716"// default
//#define AdUnitID @"ca-app-pub-3332044332205551/3426125421"// harry, don't click on banner otherwise account may be blocked. this is only for testing.
//#define AdUnitID @"ca-app-pub-5635064404729702/5139386878"//

#define AdUnitID @"ca-app-pub-5635064404729702/5139386878" // changed as per rahul sir suggestion in version 1.2.8


#define NSUserDefaults [NSUserDefaults standardUserDefaults]

//


#define kUIImage(imgName) [UIImage imageNamed:imgName]

# define KAppdelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]


#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))




/*********************
 Globle Imports
 *********************/

#import "ServerController.h"
#import "AppDelegate.h"
#import "GlobleClass.h"
#import "SWRevealViewController.h"
#import <IQKeyboardReturnKeyHandler.h>
#import <SVProgressHUD.h>
#import "Reachability.h"
#import "Singleton.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LinkedInHelper.h"
#import "Base64.h"
#import "templatCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"
#import "UIBarButtonItem+Badge.h"
#import <Stripe/Stripe.h>



#define kColor(_r_, _g_, _b_, _a_) [UIColor colorWithRed:_r_/255.0 green:_g_/255.0 blue:_b_/255.0 alpha:_a_]

#define KtimeZone [[NSTimeZone localTimeZone] name]
#define KApnsToken [KAppdelegate apnsToken]

/******************************************************
 Import All device type info by macros
 ******************************************************/

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)




#endif /* DefinesAndHeaders_h */
