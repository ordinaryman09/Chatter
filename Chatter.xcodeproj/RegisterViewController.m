//
//  RegisterViewController.m
//  Chatter
//
//  Created by Richard Lung on 3/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"


@implementation RegisterViewController

@synthesize theUsername;
@synthesize thePassword;
@synthesize theConfirmation;


- (IBAction) registerUser {
   
    
    if([thePassword.text isEqualToString:theConfirmation.text]) 
    {
    
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/newUser.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
           
    [request addPostValue:theUsername.text forKey:@"username"];
    [request addPostValue:thePassword.text forKey:@"password"];
    
    
    [request setCompletionBlock:^{
        
            //doSomething;
        NSLog(@"%@", request.responseString);
            theUsername.text =@"";
            thePassword.text =@"";
            theConfirmation.text =@"";
        
            
        
    }];
    
    [request setFailedBlock:^{
        
        NSLog(@"%@", request.error);
    }];
    
    [request startAsynchronous];   
    }
}

- (IBAction)switchViews:(id)sender {
    
    [self.view removeFromSuperview];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    thePassword.delegate = self;
    theUsername.delegate = self;
    theConfirmation.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
