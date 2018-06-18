//
//  Singleton.h
//  WeboTalk
//
//  Created by ISKPRO on 4/20/17.
//  Copyright © 2017 Afycon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
+(Singleton *)createInstance;
@property(strong,nonatomic)NSString *category_id,*savecard_id;
@property(strong,nonatomic)NSDictionary *userDetail;
@property(strong,nonatomic)NSArray *CardDetail,*payment;
@property(strong,nonatomic)NSData *image1,*image2;
@property(strong,nonatomic)NSString *card_cost;
@property(strong,nonatomic)NSString *pricing_id;
@property(strong,nonatomic)NSString *offername;

@property(strong,nonatomic)NSString *height;
@property(strong,nonatomic)NSString *width;
@property(strong,nonatomic)NSString *b_height;
@property(strong,nonatomic)NSString *b_width;


@end
