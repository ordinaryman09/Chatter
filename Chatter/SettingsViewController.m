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
    
   // UIButton* registerButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    UIButton * registerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
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

    
    // Add a hidden success indicator
    // Add a hidden activity indicator
    submitSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    submitSpinner.frame = CGRectMake(screenWidth/2-15, 18, 20, 20);
    submitSpinner.hidesWhenStopped = YES;
    [self.view addSubview:submitSpinner];
    
}

- (NSString *) saveFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"loginSave1.plist"];
}

- (IBAction) authorizeUser {
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
}

- (void) createUser:(id)sender {
    [regSubmitSpinner startAnimating];
    NSLog(@"%@", regUserField.text);
    if([regPassField.text isEqualToString:regConfirmPassField.text] && (regUserField.text.length > 0)) 
    {
        
        NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/newUser.php"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request addPostValue:regUserField.text forKey:@"username"];
        [request addPostValue:regPassField.text forKey:@"password"];
        
        
        [request setCompletionBlock:^{
            
            //doSomething;
            NSLog(@"%@", request.responseString);
            
            if ([request.responseString  isEqualToString:@"SUCCESS"]) {
                [regSubmitSpinner stopAnimating];
                
                // Set the values in the main user/pass fields
                userField.text = regUserField.text;
                passField.text = regPassField.text;
                
                // Store the user/pass in the local filesystem
                
                
                // Close the view
                [UIView transitionWithView:self.view duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                                animations:^ { [userRegView removeFromSuperview]; }
                                completion:nil];
                
            } else if ([request.responseString isEqualToString:@"ALREADY_TAKEN"]) {
                
            }
            
            
            
            
        }];
        
        [request setFailedBlock:^{
            
            NSLog(@"%@", request.error);
        }];
        
        [request startAsynchronous];
        
    } else {
        // Input Validation Error
        [regSubmitSpinner stopAnimating];
        [regFailLabel setHidden:NO];
    }
}

- (void) showNewUserView:(id)sender {
    UIButton* temp = sender;
    temp.selected = NO;
    temp.highlighted = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
        
    //RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterView" bundle:nil];
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"UserRegistrationView" owner:self options:nil];
    userRegView = [subviewArray objectAtIndex:0];
    userRegView.layer.cornerRadius = 15;
    
    userRegView.layer.masksToBounds = NO;
    //self.layer.cornerRadius = 8; // if you like rounded corners
    userRegView.layer.shadowOffset = CGSizeMake(0, 0);
    userRegView.layer.shadowRadius = 30;
    userRegView.layer.shadowOpacity = 0.6;
    userRegView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    userRegView.layer.borderWidth = 4.0f;
    userRegView.layer.shadowPath = [UIBezierPath bezierPathWithRect:userRegView.bounds].CGPath;
    NSLog(@"%f %f",userRegView.frame.size.width, userRegView.frame.size.height);
    [userRegView setFrame:CGRectMake(screenWidth/2-143, /*screenHeight/2-150*/0, userRegView.frame.size.width, userRegView.frame.size.height)];
    
    // Add the display view controller to the stack
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                    animations:^ { [self.view addSubview:userRegView]; }
                    completion:nil];

    // Add selector to the UIButton in the UserRegistrationView
    regUserField = (UITextField*) [userRegView viewWithTag:10];
    regPassField = (UITextField*) [userRegView viewWithTag:11];
    regConfirmPassField = (UITextField*) [userRegView viewWithTag:12];
    UIButton* submitButton = (UIButton*) [userRegView viewWithTag:3];
    regSubmitSpinner = [userRegView viewWithTag:4];
    regFailLabel = (UILabel*) [userRegView viewWithTag:5];
    
    
    regUserField.clearButtonMode = UITextFieldViewModeWhileEditing;
    regUserField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    int rgbValue = 0x3366CC;
    regUserField.textColor = [UIColor \
                              colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                              green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                              blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    regUserField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    regPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    regPassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    regPassField.textColor = [UIColor \
                           colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                           blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    regPassField.secureTextEntry = YES;
    regPassField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    regConfirmPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        
        if (indexPath.row == 0) {
            userField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
            userField.delegate = self;
            userField.clearButtonMode = UITextFieldViewModeWhileEditing;
            userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
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
            passField.clearButtonMode = UITextFieldViewModeWhileEditing;
            passField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
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
        
        /*if (indexPath.row == 0)
            passwordTF.tag = 0;
        else {
            passwordTF.tag = 1;
            passwordTF.secureTextEntry = YES;
        }*/
        
        
    }
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
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
    
    
    NSLog(@"%@", theUsername);
    
    
    [request addPostValue:theUsername forKey:@"user"];
    [request addPostValue:thePassword forKey:@"pass"];
    
    
    [request setCompletionBlock:^{
        //[submitSpinner stopAnimating];
        // If valid user/pass provided
        if([request.responseString isEqualToString:@"TRUE"]){
            NSLog(@"here...");
            
            //save to iphone
            
            NSString *myPath = [self saveFilePath];
            
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
            
            if(fileExists) {
                
                NSLog(@"FILE EXIST");
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
                
                [myUserName removeAllObjects];
                [myUserName addObject:theUsername];
                // [theUsername.text writeToFile:[self saveFilePath] atomically:YES];
                
                
                [myUserName writeToFile:[self saveFilePath] atomically:YES];    
                
            }
            
            else {
                
                NSLog(@"HERE");
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithObjects:theUsername, nil];                
                //[myUserName addObject:theUsername.text];
                // [theUsername.text writeToFile:[self saveFilePath] atomically:YES];
                
                
                [myUserName writeToFile:[self saveFilePath] atomically:YES];   
                
                
            }
            
            // Update the table to show approved status
        } else {
            // Display an error dialog
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
        
        NSLog(@"%@", request.error);
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
