//
//  RegisterViewController.h
//  Chatter
//
//  Created by Richard Lung on 3/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UIViewController
<UITextFieldDelegate> {
    IBOutlet UITextField *theUsername;
    IBOutlet UITextField *thePassword;
    IBOutlet UITextField *theConfirmation;
}


- (IBAction)switchViews:(id)sender;
@property (nonatomic, retain) UITextField *theUsername;
@property (nonatomic, retain) UITextField *thePassword;
@property (nonatomic, retain) UITextField *theConfirmation;
- (IBAction) registerUser;


@end
