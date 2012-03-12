//
//  SettingsViewController.m
//  Chatter
//
//  Created by William Wu on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    int rgbValue = 0x3366CC;
    
    UILabel* registerInfo = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-70, screenHeight/2-100, screenWidth, 25)];
    registerInfo.text = @"Not registered? Touch        .";
    registerInfo.font = [UIFont systemFontOfSize:10];
    registerInfo.textColor = [UIColor darkGrayColor];
    registerInfo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:registerInfo];
    
    UILabel* logoutInfo = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-49, screenHeight/2-85, screenWidth, 25)];
    logoutInfo.text = @"Or, you can           .";
    logoutInfo.font = [UIFont systemFontOfSize:10];
    logoutInfo.textColor = [UIColor darkGrayColor];
    logoutInfo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:logoutInfo];
    
    registerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [registerButton setFrame:CGRectMake(screenWidth/2+28, screenHeight/2-100, 30, 25)];
    [registerButton setTitle:@"here" forState:UIControlStateNormal];
    [registerButton setTitle:@"here" forState:UIControlStateHighlighted];
    [registerButton setTitle:@"here" forState:UIControlStateDisabled];
    [registerButton setTitle:@"here" forState:UIControlStateSelected];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [registerButton addTarget:self 
                       action:@selector(showNewUserView:)
              forControlEvents:UIControlEventTouchUpInside];
    
    registerButton.titleLabel.textColor = [UIColor \
                               colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                               green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                               blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    
    [self.view addSubview:registerButton];
    
    logoutButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [logoutButton setFrame:CGRectMake(screenWidth/2+6, screenHeight/2-85, 30, 25)];
    [logoutButton setTitle:@"logout" forState:UIControlStateNormal];
    [logoutButton setTitle:@"logout" forState:UIControlStateHighlighted];
    [logoutButton setTitle:@"logout" forState:UIControlStateDisabled];
    [logoutButton setTitle:@"logout" forState:UIControlStateSelected];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [logoutButton addTarget:self 
                       action:@selector(authLogout:)
             forControlEvents:UIControlEventTouchUpInside];
    
    logoutButton.titleLabel.textColor = [UIColor \
                                           colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                           blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    
    [self.view addSubview:logoutButton];
    
    // Add a hidden activity indicator
    submitSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    submitSpinner.frame = CGRectMake(screenWidth/2-15, 18, 20, 20);
    submitSpinner.hidesWhenStopped = YES;
    [self.view addSubview:submitSpinner];
    
    // Add a hidden success image
    UIImage *one = [UIImage imageNamed:@"19-check@2x.png"];
    //creating a UIImageView
    successIndicator = [[[UIImageView alloc] initWithImage:one] autorelease];
    [successIndicator setHidden:YES];
    successIndicator.frame = CGRectMake(screenWidth/2-8, 19, 15, 15);
    [self.view addSubview:successIndicator];
    
}

- (NSString *) saveFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"loginSave1.plist"];
}

/*- (IBAction) authorizeUser {
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/userAuth.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    
   // NSLog(@"%@", theUsername.text);
    
    
    [request addPostValue:userField.text forKey:@"user"];
    [request addPostValue:passField.text forKey:@"pass"];
    
    
    [request setCompletionBlock:^{
        
        if([request.responseString isEqualToString:@"TRUE"]){
            
            
            //save to iphone
            
            NSString *myPath = [self saveFilePath];
            
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
            
            if(fileExists) {
                
                NSLog(@"FILE EXIST");
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
                
                [myUserName removeAllObjects];
                [myUserName addObject:userField.text];
                // [theUsername.text writeToFile:[self saveFilePath] atomically:YES];
                
                
                [myUserName writeToFile:[self saveFilePath] atomically:YES];    
                
            }
            
            else {
                
                NSLog(@"CREATING PASSWORD FILE");
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithObjects:userField.text, nil];                
                //[myUserName addObject:theUsername.text];
                // [theUsername.text writeToFile:[self saveFilePath] atomically:YES];
                
                
                [myUserName writeToFile:[self saveFilePath] atomically:YES];   
                
                
            }
            
            // Display a success indicator on the view
            
            
        } else {
            // The provided user/pass info was incorrect
        }
        
    }];
    
    [request setFailedBlock:^{
        
        NSLog(@"%@", request.error);
    }];
    
    [request startAsynchronous];   
}*/
- (void) dismissNewUserView:(id)sender {
    // Close the view
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionAutoreverse //change to whatever animation you like
                    animations:^ { [userRegView removeFromSuperview]; }
                    completion:nil];
}
- (void) createUser:(id)sender {
    [regSubmitSpinner startAnimating];
 
    if([regPassField.text isEqualToString:regConfirmPassField.text] && (regUserField.text.length > 0)) 
    {
        
        NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/newUser.php"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request addPostValue:regUserField.text forKey:@"username"];
        [request addPostValue:regPassField.text forKey:@"password"];
        
        
        [request setCompletionBlock:^{
            [regSubmitSpinner stopAnimating];
            //doSomething;
     
            if ([request.responseString  isEqualToString:@"SUCCESS"]) {
                
                // Set the values in the main user/pass fields
                userField.text = regUserField.text;
                passField.text = regPassField.text;
                
                // Close the view
                [self dismissNewUserView:nil];
                
                // Auto-start the user validation process for the main settings view
                [self validateUser:userField.text userPass:passField.text];
                
            } else if ([request.responseString isEqualToString:@"ALREADY_TAKEN"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                                message:@"This username is already in use. Please choose a different username." 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                [regUserField becomeFirstResponder];
                regUserField.text = @"";
            }
            
            
        }];
        
        [request setFailedBlock:^{
            
        }];
        
        [request startAsynchronous];
        
    } else {
        // Input Validation Error
        [regSubmitSpinner stopAnimating];
        [regFailLabel setHidden:NO];
        [regConfirmPassField becomeFirstResponder];
    }
}

- (void) authLogout:(id)sender {
    
    int rgbValue = 0x3366CC;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [logoutButton release];
    
    logoutButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [logoutButton setFrame:CGRectMake(screenWidth/2+6, screenHeight/2-85, 30, 25)];
    [logoutButton setTitle:@"logout" forState:UIControlStateNormal];
    [logoutButton setTitle:@"logout" forState:UIControlStateHighlighted];
    [logoutButton setTitle:@"logout" forState:UIControlStateDisabled];
    [logoutButton setTitle:@"logout" forState:UIControlStateSelected];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [logoutButton addTarget:self 
                     action:@selector(authLogout:)
           forControlEvents:UIControlEventTouchUpInside];
    
    logoutButton.titleLabel.textColor = [UIColor \
                                         colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                         green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                         blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    
    [self.view addSubview:logoutButton];
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *myPath = [self saveFilePath];
    
    BOOL fileExists = [fileManager fileExistsAtPath:myPath];
    
    //BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
    NSError *error;
    if(fileExists) {
        // Delete any past user/pass info saved on device
        [[NSFileManager defaultManager] removeItemAtPath:myPath error:&error];
        
        // Clear the fields
        userField.text = @"";
        passField.text = @"";
        [successIndicator setHidden:YES];
        
        
        // Pop-up notification telling user that invalid entry
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                        message:@"You have been logged out." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    } else {
        
        // Pop-up notification telling user that invalid entry
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                        message:@"Not currently logged in." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

    
}

- (void) showNewUserView:(id)sender {
    UIButton* temp = sender;
    temp.selected = NO;
    temp.highlighted = NO;
    
    int rgbValue = 0x3366CC;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [registerButton release];
    registerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    //UIButton* registerButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2+32, screenHeight/2-100, screenWidth, 100)];
    [registerButton setFrame:CGRectMake(screenWidth/2+28, screenHeight/2-100, 30, 25)];
    [registerButton setTitle:@"here" forState:UIControlStateNormal];
    [registerButton setTitle:@"here" forState:UIControlStateHighlighted];
    [registerButton setTitle:@"here" forState:UIControlStateDisabled];
    [registerButton setTitle:@"here" forState:UIControlStateSelected];
    //   registerButton.titleLabel.text = @"here";
    registerButton.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [registerButton addTarget:self 
                       action:@selector(showNewUserView:)
             forControlEvents:UIControlEventTouchUpInside];
    
    registerButton.titleLabel.textColor = [UIColor \
                                           colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                           blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    
    [self.view addSubview:registerButton];
    
  
        
    //RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterView" bundle:nil];
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"UserRegistrationView" owner:self options:nil];
    userRegView = [subviewArray objectAtIndex:0];
    userRegView.layer.cornerRadius = 15;
    
    userRegView.layer.masksToBounds = NO;
    //self.layer.cornerRadius = 8; // if you like rounded corners
    userRegView.layer.shadowOffset = CGSizeMake(0, 0);
    userRegView.layer.shadowRadius = 20;
    userRegView.layer.shadowOpacity = 0.8;
    userRegView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    userRegView.layer.borderWidth = 4.0f;
    userRegView.layer.shadowPath = [UIBezierPath bezierPathWithRect:userRegView.bounds].CGPath;
    
    [userRegView setFrame:CGRectMake(screenWidth/2-143, /*screenHeight/2-150*/17, userRegView.frame.size.width, userRegView.frame.size.height)];
    
    // Add the display view controller to the stack
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionAutoreverse //change to whatever animation you like
                    animations:^ { [self.view addSubview:userRegView]; }
                    completion:nil];

    // Add selector to the UIButton in the UserRegistrationView
    regUserField = (UITextField*) [userRegView viewWithTag:10];
    regPassField = (UITextField*) [userRegView viewWithTag:11];
    regConfirmPassField = (UITextField*) [userRegView viewWithTag:12];
    UIButton* submitButton = (UIButton*) [userRegView viewWithTag:3];
    UIButton* closeButton = (UIButton*) [userRegView viewWithTag:13];
    regSubmitSpinner = [userRegView viewWithTag:4];
    regFailLabel = (UILabel*) [userRegView viewWithTag:5];
    
    
    regUserField.clearButtonMode = UITextFieldViewModeWhileEditing;
    regUserField.returnKeyType = UIReturnKeyNext;
    regUserField.delegate = self;
    regUserField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //int rgbValue = 0x3366CC;
    regUserField.textColor = [UIColor \
                              colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                              green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                              blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    regUserField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    regPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    regPassField.returnKeyType = UIReturnKeyNext;
    regPassField.delegate = self;
    regPassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    regPassField.textColor = [UIColor \
                           colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                           blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    regPassField.secureTextEntry = YES;
    regPassField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    regConfirmPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    regConfirmPassField.returnKeyType = UIReturnKeyGo;
    regConfirmPassField.delegate = self;
    regConfirmPassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    regConfirmPassField.textColor = [UIColor \
                              colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                              green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                              blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    regConfirmPassField.secureTextEntry = YES;
    regConfirmPassField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    //NSLog(@"%@", regUserField.text);
    /*regUserField.delegate = self;
    regPassField.delegate = self;
    regConfirmPassField.delegate = self;*/
    
    [submitButton addTarget:self 
                       action:@selector(createUser:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [closeButton addTarget:self action:@selector(dismissNewUserView:) forControlEvents:UIControlEventTouchUpInside];
    [regUserField becomeFirstResponder];
    
                                     //[self.view addSubview:userRegView];
    
    //[self.view addSubview:self.UserRegistrationView];
        
        
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Account Setup";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //if (textField != regUserField && textField == regPassField && textField != regConfirmPassField) {
        [textField resignFirstResponder];
    //}
    
    if (textField == userField) {
        [passField becomeFirstResponder];
    } else if (textField == regUserField) {
        [regPassField becomeFirstResponder];
    } else if (textField == regPassField) {
        [regConfirmPassField becomeFirstResponder];
    } else if (textField == regConfirmPassField) {
        [self createUser:nil];
    }
     
    return YES;// return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *myPath = [self saveFilePath];
    
    BOOL fileExists = [fileManager fileExistsAtPath:myPath];
    

        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel *startDtLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
        startDtLbl.font = [UIFont boldSystemFontOfSize:16];
        if (indexPath.row == 0)
            startDtLbl.text = @"Username";
        else {
            startDtLbl.text = @"Password";
        }
        
        startDtLbl.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:startDtLbl];
        
        [startDtLbl release];
        
        if (indexPath.row == 0) {
            userField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
            userField.delegate = self;
            userField.returnKeyType = UIReturnKeyNext;
            userField.clearButtonMode = UITextFieldViewModeWhileEditing;
            userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            if (fileExists) {
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
                userField.text = [myUserName objectAtIndex:0];
                [myUserName release];
            }
            
            [userField addTarget:self 
                          action:@selector(methodToFire:)
                forControlEvents:UIControlEventEditingDidEndOnExit];
            
            int rgbValue = 0x3366CC;
            userField.textColor = [UIColor \
                                   colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                   green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                   blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
            userField.autocorrectionType = UITextAutocorrectionTypeNo;
            userField.tag = 0;
            [cell.contentView addSubview:userField];
        } else {
            passField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
            passField.delegate = self;
            passField.returnKeyType = UIReturnKeyGo;
            passField.clearButtonMode = UITextFieldViewModeWhileEditing;
            passField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            if (fileExists) {
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
                passField.text = [myUserName objectAtIndex:1];
                [myUserName release];
            }
            
            [passField addTarget:self 
                          action:@selector(methodToFire:)
                forControlEvents:UIControlEventEditingDidEndOnExit];
            
            int rgbValue = 0x3366CC;
            passField.textColor = [UIColor \
                                   colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                   green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                   blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
            passField.secureTextEntry = YES;
            passField.tag = 1;
            passField.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:passField];
            
        }
        
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    // Hide success indicator in case it was previously shown
    [successIndicator setHidden:YES];
    
    // If the user has just entered in a password
    if (textField.tag == 1 && textField != regPassField) {
        // Check to make sure they have also entered in a username
        if ([userField.text length] > 0) {
            [self validateUser:userField.text userPass:textField.text];
        } else {
            // Pop-up notification telling user that invalid entry
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No username provided" 
                                                            message:@"You must enter a valid username." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    //do stuff
    
}

- (BOOL) validateUser:(NSString *)theUsername userPass:(NSString *)thePassword {
    
    [submitSpinner startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/userAuth.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *myPath = [self saveFilePath];
    
    
    [request addPostValue:theUsername forKey:@"user"];
    [request addPostValue:thePassword forKey:@"pass"];
    
    
    [request setCompletionBlock:^{
        [submitSpinner stopAnimating];
        // If valid user/pass provided
        if([request.responseString isEqualToString:@"TRUE"]){
            
            // Show the success checkmark (view)
            [successIndicator setHidden:NO];
            
            //save to iphone
            

            
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
            
            if(fileExists) {
                
         
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
                
                [myUserName removeAllObjects];
                [myUserName addObject:theUsername];
                [myUserName addObject:thePassword];
                // [theUsername.text writeToFile:[self saveFilePath] atomically:YES];
                
                
                [myUserName writeToFile:[self saveFilePath] atomically:YES];
            }
            
            else {
                
    
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithObjects:theUsername, thePassword, nil];                
                //[myUserName addObject:theUsername.text];
                // [theUsername.text writeToFile:[self saveFilePath] atomically:YES];
                
                
                [myUserName writeToFile:[self saveFilePath] atomically:YES];   
                
                
            }
            

        } else {

            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
            NSError *error;
            if(fileExists) {
                // Delete any past user/pass info saved on device
                [[NSFileManager defaultManager] removeItemAtPath:myPath error:&error];
            }
            
            // Pop-up notification telling user that invalid entry
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Account Info" 
                                                            message:@"Wrong username or password." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }];
    
    [request setFailedBlock:^{
        
      
    }];
    
    [request startAsynchronous];   
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
