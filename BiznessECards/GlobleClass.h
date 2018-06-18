//
//  GlobleClass.h
//  Howee
//
//  Created by Harendra Sharma on 27/07/16.
//  Copyright © 2016 Harendra Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobleClass : NSObject




@property (nonatomic, retain) UIActivityIndicatorView * activityView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;



+(UIImageView*)GetBaseImageBGWithImageName:(NSString*)imgName andRect:(CGRect)iRect;

//1.Email Validation
+(BOOL) emailValidation :(UITextField *)emailTextfield;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;

//2.Add image on left side of textfield
+(void)addImageInLeftCornerOnTextField :(UITextField *)searchField :(UIImage *)imageToAdd;

//3.Pass a number to Phone Call
+(void)methodForPhoneCall :(NSString *)phoneNumberString;

//4.Get Current Day from current Date
+(NSString *)currentDay :(NSDate *)date;

//5.Get Current time from current Date in hour and minute
+(NSString *)currentTime;

//6.My Label add with view
+(UILabel *)myLabel :(float)xaxis yaxis:(float) yaxis width:(float)width height:(float)height labelTitle:(NSString *)labelTitle fontStyle:(NSString *)fontStyle fontColor:(UIColor *)fontColor fontSize:(float)fontSize;

//7.My Button add with view
+(UIButton *) myButton :(float)xaxis yaxis:(float) yaxis width:(float)width height:(float)height buttonTitle:(NSString *)buttonTitle backgroundImage:(NSString *)backgroundImage selectedImage:(NSString*)selectedImage;


//9. My textfield add with view
+(UITextField *) myTextField :(float)xaxis yaxis:(float) yaxis width:(float)width height:(float)height placeholder:(NSString *)placeholder backgroundImage:(NSString *)backgroundImage;

//10.Mobile number Validation
+ (BOOL)validateNumber :(NSString*)number;

//11. age validation
+ (BOOL)ageValidation :(NSString*)number;

//12. CheckInternetStatus
+(BOOL)CheckInternetStatus;

//13. Alert
+(void)alert:(NSString*) alertmessage;
+(void)alertWithMassage:(NSString*) alertmessage Title:(NSString*)title;

//14 Decode tags from string
+(NSMutableAttributedString*)decorateTags:(NSString *)stringWithTags;


// add corner radious
+(void) CustomizeItWith:(UIView*)view;

//  get top or current visible viewcontroller on root 
+ (UIViewController *)currentTopViewController;
+(NSString*)RemoveNull:(NSDictionary*)data and:(NSString*)key;

// will clear all textfield text at once, pass uitextfield's superview only
+(void)ClearAllFieldsWithView:(UIView*)parentView;


+(void)ConfigureBtnStateColours:(UIButton*)button andCornerRadius:(BOOL)isNeeded;

+ (UIImage *)imageFromColor:(UIColor *)color;

+(NSArray*)GetDataFromUitextfields:(UIView*)parentView;
+(void)setplaceholderColourWith:(UITextField*)textField WithColour:(UIColor*)colour;
+(void)AddPadding:(UITextField*)tf andNeededright:(BOOL)right andNeededLeft:(BOOL)left;
+(void)PrintDebuggable:(NSString*)Title andJsonObject:(id)jsonObject;

@end
