//
//  ThirdViewController.h
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"



@interface ThirdViewController : UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{

    UIImagePickerController *ipc;
    IBOutlet UIImageView *theImage;
    IBOutlet UIButton *theButton;
    ASIFormDataRequest *request;
    
}

@property (nonatomic, retain) UIImageView *theImage;

@property (nonatomic, retain) UIButton *theButton;

@property (nonatomic, retain) ASIFormDataRequest *request;

-(IBAction) buttonClicked;

-(IBAction) sendRequest;



@end
