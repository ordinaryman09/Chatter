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
#import "JSONKit.h"

@interface AddCommentView :  UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,
CLLocationManagerDelegate>
{
    
    UIImagePickerController *ipc;
    // IBOutlet UIImageView *theImage;
    IBOutlet UIButton *theButton;
    IBOutlet UITextView *theContent;
    ASIFormDataRequest *request;
    NSString * userName;
    NSString * tID;
}

@property (nonatomic, retain) UIButton *theButton;

@property (nonatomic, retain) UITextView *theContent;



//-(IBAction) buttonClicked;

-(IBAction) sendRequest;

-(IBAction) backRequest;
-(void) setThreadID :(NSString*) threadID setUserName:(NSString *) theUser;

@end


