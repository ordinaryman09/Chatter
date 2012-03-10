//
//  AddCommentView.h
//  Chatter
//
//  Created by William Wu on 12/31/00.
//  Copyright (c) 2000 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

@interface AddCommentView :  UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,
CLLocationManagerDelegate>
{
    //UITextField *commentField;
    UIView *commentView;
    UIActivityIndicatorView *commentSpinner;
    UIImagePickerController *ipc;
    IBOutlet UITextView *commentField;
    ASIFormDataRequest *request;
    NSString * userName;
    NSString * tID;
    // comment
}

@property (nonatomic, retain) UITextView *theContent;



//-(IBAction) buttonClicked;

-(IBAction) sendRequest;

-(IBAction) showNewUserView;



-(IBAction) backRequest;
-(void) setThreadID :(NSString*) threadID setUserName:(NSString *) theUser;

@end


