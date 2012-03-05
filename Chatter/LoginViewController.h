//
//  SecondViewController.h
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface LoginViewController : UIViewController
<UITextFieldDelegate>

{
    IBOutlet UITextField *theUsername;
    IBOutlet UITextField *thePassword;
}


@property (nonatomic, retain) UITextField *theUsername;
@property (nonatomic, retain) UITextField *thePassword;

- (IBAction)switchViews:(id)sender;
- (IBAction) authorizeUser;

@end
