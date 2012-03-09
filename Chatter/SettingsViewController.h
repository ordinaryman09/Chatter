//
//  SettingsViewController.h
//  Chatter
//
//  Created by William Wu on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "ASIFormDataRequest.h"

@interface SettingsViewController : UITableViewController
{
    UITextField * userField;
    UITextField * passField;
    
    UIView* userRegView;
    UIActivityIndicatorView * submitSpinner;
    UITextField * regUserField;
    UITextField * regPassField;
    UITextField * regConfirmPassField;
    UILabel * regFailLabel;
}


- (BOOL) validateUser:(NSString *)theUsername userPass:(NSString *)thePassword;

- (void) showNewUserView:(id)sender;
- (void) createUser:(id)sender;

@end
