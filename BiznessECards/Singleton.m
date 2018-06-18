//
//  Singleton.m
//  WeboTalk
//
//  Created by ISKPRO on 4/20/17.
//  Copyright © 2017 Afycon. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton


static Singleton *instance = nil;
+(Singleton *)createInstance
{
    if (instance==nil)
    {
        instance=[[Singleton alloc]init];
}
    return instance;
}



@end
