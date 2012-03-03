//
//  ThirdViewController.h
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import "JSONKit.h"



@interface ThirdViewController : UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,
CLLocationManagerDelegate>
{

    UIImagePickerController *ipc;
   // IBOutlet UIImageView *theImage;
    IBOutlet UIButton *theButton;
    IBOutlet UITextField *theTitle;
    IBOutlet UITextView *theContent;
    ASIFormDataRequest *request;
    NSString * lat;
    NSString * lon;
    NSString * userName;
}

@property (nonatomic, retain) UITextField *theTitle;

//@property (nonatomic, retain) UIImageView *theImage;

@property (nonatomic, retain) UIButton *theButton;

@property (nonatomic, retain) UITextView *theContent;



//-(IBAction) buttonClicked;

-(IBAction) sendRequest;

-(IBAction) logOut;
-(void) setUserName :(NSString*) theUser;


@end
