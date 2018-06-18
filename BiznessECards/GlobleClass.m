//
//  GlobleClass.m
//  Howee
//
//  Created by Harendra Sharma on 27/07/16.
//  Copyright © 2016 Harendra Sharma. All rights reserved.
//

#import "GlobleClass.h"
#import "Reachability.h"


@implementation GlobleClass


+(UIImageView*)GetBaseImageBGWithImageName:(NSString*)imgName andRect:(CGRect)iRect
{
    UIImageView* superBg = [[UIImageView alloc]initWithFrame:iRect];
    [superBg setImage:[UIImage imageNamed:imgName]];
    superBg.contentMode = UIViewContentModeScaleAspectFill;
    return superBg;

}

//1.Email Validation

+(BOOL)emailValidation :(UITextField *)emailTextfield
{
    BOOL emailTextedBool=false;
    if (emailTextfield.text.length > 0 )
    {
        NSString *strEmailValidation = emailTextfield.text;
        char *str_Email_Validation_chr = (char *)[strEmailValidation UTF8String];
        
        for (int i=0; i<strlen(str_Email_Validation_chr);i++)
        {
            if(str_Email_Validation_chr[i] == '@')
            {
                for(int j=i+1;j<strlen(str_Email_Validation_chr);j++)
                {
                    if(str_Email_Validation_chr[j] != '.')
                    {
                        if(str_Email_Validation_chr[j+1] == '.')
                        {
                            for(int k=j+1;k<strlen(str_Email_Validation_chr);k++)
                            {
                                emailTextedBool  =  TRUE;
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    return emailTextedBool;
}
//1.Email Validation

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
//2.Add image on left side of textfield

+(void)addImageInLeftCornerOnTextField :(UITextField *)searchField :(UIImage *)imageToAdd
{
    searchField.leftView = [[UIImageView alloc] initWithImage:imageToAdd];
    searchField.leftViewMode = UITextFieldViewModeAlways;
}

//3.Pass a number to Phone Call

+(void)methodForPhoneCall :(NSString *)phoneNumberString
{
    NSURL *dialingURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@",phoneNumberString]];
    
    [[UIApplication sharedApplication] openURL:dialingURL];
}

//4.Get Current Day from current Date

+(NSString *)currentDay :(NSDate *)date
{
    NSDateFormatter *theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay =  [theDateFormatter stringFromDate:date];
    return weekDay;
}


//5.Get Current time from current Date in hour and minute

+(NSString *)currentTime
{
    NSDate *currentDateForNotification = [NSDate date];
    NSDateFormatter *hourDateFormater=[[NSDateFormatter alloc] init];
    [hourDateFormater setDateFormat:@"hh:mm"];
    NSString *currentHour = [hourDateFormater stringFromDate:currentDateForNotification];
    return currentHour;
}

//6.My Label add with view

+(UILabel *)myLabel :(float)xaxis yaxis:(float) yaxis width:(float)width height:(float)height labelTitle:(NSString *)labelTitle fontStyle:(NSString *)fontStyle fontColor:(UIColor *)fontColor fontSize:(float)fontSize
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xaxis,yaxis, width, height)];
    [label setText:labelTitle];
    label.font = [UIFont fontWithName:fontStyle size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = NSTextAlignmentCenter;
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
}

//7.My Button add with view

+(UIButton *) myButton :(float)xaxis yaxis:(float) yaxis width:(float)width height:(float)height buttonTitle:(NSString *)buttonTitle backgroundImage:(NSString *)backgroundImage selectedImage:(NSString*)selectedImage
{
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(xaxis, yaxis, width, height);
    [myButton setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    [myButton setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateSelected];
    [myButton setTitle:buttonTitle forState:UIControlStateNormal];
    return myButton;
}

//9. My textfield add with view

+(UITextField *) myTextField :(float)xaxis yaxis:(float) yaxis width:(float)width height:(float)height placeholder:(NSString *)placeholder backgroundImage:(NSString *)backgroundImage
{
    UITextField *myText = [[UITextField alloc] initWithFrame:CGRectMake(xaxis, yaxis, width, height)];
    [myText setPlaceholder:placeholder];
    myText.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
    return myText;
}

//10.Mobile number Validation

+ (BOOL)validateNumber :(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

//11. age validation

+ (BOOL)ageValidation :(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{2}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}
//12. CheckInternetStatus

+ (BOOL)CheckInternetStatus{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    return netStatus;
}

//13. Alert 
+(void)alert:(NSString*) alertmessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithFrame:CGRectMake(50, 50, 200, 100)];
    alert.backgroundColor=[UIColor colorWithRed:150 green:60 blue:70 alpha:10];
    [alert setTitle:@"Alert!"];
    [alert setDelegate:self];
    [alert setMessage:alertmessage];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}
+(void)alertWithMassage:(NSString*) alertmessage Title:(NSString*)title{
    UIAlertView *alert=[[UIAlertView alloc]initWithFrame:CGRectMake(50, 50, 200, 100)];
    alert.backgroundColor=[UIColor colorWithRed:150 green:60 blue:70 alpha:10];
    [alert setTitle:title];
    [alert setDelegate:self];
    [alert setMessage:alertmessage];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

+(NSMutableAttributedString*)decorateTags:(NSString *)stringWithTags
{
    
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    
    //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:stringWithTags options:0 range:NSMakeRange(0, stringWithTags.length)];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:stringWithTags];
    
    NSInteger stringLength=[stringWithTags length];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSRange wordRange = [match rangeAtIndex:1];
        
        NSString* word = [stringWithTags substringWithRange:wordRange];
        
        //Set Font
        UIFont *font;
        font=[UIFont fontWithName:@"OpenSans" size:15];
        font= [UIFont fontWithName:@"OpenSans-Light" size:15.0f];
        
        [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, stringLength)];
        
        //Set Background Color
        UIColor *backgroundColor=[UIColor clearColor];
        [attString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:wordRange];
        
        //Set Foreground Color
        UIColor *foregroundColor=[UIColor colorWithRed:204.0/255.0 green:139.0/255.0 blue:12.0/255.0 alpha:1.0];
        [attString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:wordRange];
        NSLog(@"Found tag %@", word);
        
    }
    
    // Set up your text field or label to show up the result
    
    //    yourTextField.attributedText = attString;
    //
    //    yourLabel.attributedText = attString;
    
    return attString;
}


+(void) CustomizeItWith:(UIView*)view
{
    [view setClipsToBounds:YES];
    [view.layer setCornerRadius:view.frame.size.height/2];
    
    if ([view isKindOfClass:[UIButton class]]) {
        return;
    }
    
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:1.2f];
    [view setBackgroundColor:[UIColor clearColor]];
    
    
}

+ (UIViewController *)currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


+(NSString*)RemoveNull:(NSDictionary*)data and:(NSString*)key
{
    NSString* str = @"";
    if((data[key] == nil) || (data[key] == [NSNull null]))
    {
        return str;
        
    }
    return [NSString stringWithFormat:@"%@",data[key]];
}

+(void)ClearAllFieldsWithView:(UIView*)parentView
{
    for(id x in [parentView subviews])
    {
        if([x isKindOfClass:[UITextField class]])
        {
            [(UITextField*)x setText:@""];
        }
    }
}




+(void)ConfigureBtnStateColours:(UIButton*)button andCornerRadius:(BOOL)isNeeded
{
    if (isNeeded) {
        [button.layer setCornerRadius:button.frame.size.height/2];
        [button setClipsToBounds:YES];
        [button layoutIfNeeded];
    }
    
    [button setBackgroundImage:[self imageFromColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageFromColor:[UIColor redColor]] forState:UIControlStateSelected];
    
    [button layoutIfNeeded];
    
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width/3, 100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSArray*)GetDataFromUitextfields:(UIView*)parentView
{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for(id x in [parentView subviews])
    {
        if([x isKindOfClass:[UITextField class]])
        {
            [temp addObject:[(UITextField*)x text]];
        }
    }
    
    NSLog(@"GetDataFromUitextfields data - %@",temp);
    
    
    return temp;
    
}



+(void)setplaceholderColourWith:(UITextField*)textField WithColour:(UIColor*)colour
{
    
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:colour}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
}
+(void)AddPadding:(UITextField*)tf andNeededright:(BOOL)right andNeededLeft:(BOOL)left
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    if (right)tf.rightView = paddingView;
    if (left)tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    
}
+(void)PrintDebuggable:(NSString*)Title andJsonObject:(id)jsonObject
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&err];
    NSLog(@"%@ %@",Title, [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}



@end
