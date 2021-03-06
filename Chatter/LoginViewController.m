//
//  SecondViewController.m
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ThirdViewController.h"


@implementation LoginViewController
@synthesize thePassword;
@synthesize theUsername;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    thePassword.delegate = self;
    theUsername.delegate = self;
    thePassword.secureTextEntry = YES;
       [super viewDidLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)switchViews:(id)sender {
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterView" bundle:nil];
    
    [self.view addSubview:registerViewController.view];
    
      // [registerViewController release];
    

}

- (NSString *) saveFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"loginSave1.plist"];
}


- (IBAction) authorizeUser {
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/userAuth.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    
    NSLog(@"%@", theUsername.text);

    
    [request addPostValue:theUsername.text forKey:@"user"];
    [request addPostValue:thePassword.text forKey:@"pass"];
    
    
    [request setCompletionBlock:^{
            
        if([request.responseString isEqualToString:@"TRUE"]){
            
            
            //save to iphone
            
            NSString *myPath = [self saveFilePath];
            
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
            
            if(fileExists) {
                
                NSLog(@"FILE EXIST");
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
                
                [myUserName removeAllObjects];
                [myUserName addObject:theUsername.text];
               // [theUsername.text writeToFile:[self saveFilePath] atomically:YES];
                
                
                [myUserName writeToFile:[self saveFilePath] atomically:YES];    
            
            }
            
            else {
                
                NSLog(@"HERE");
                NSMutableArray *myUserName = [[NSMutableArray alloc] initWithObjects:theUsername.text, nil];                
                //[myUserName addObject:theUsername.text];
                // [theUsername.text writeToFile:[self saveFilePath] atomically:YES];
                
                
                [myUserName writeToFile:[self saveFilePath] atomically:YES];   
                
                
            }
            
            
            //doSomething;
            ThirdViewController *thirdViewController = [[ThirdViewController alloc]initWithNibName:@"ThirdView" bundle:nil];
            
            [thirdViewController setUserName:theUsername.text];
            
            theUsername.text =@"";
            thePassword.text =@"";
            
            [self.view addSubview:thirdViewController.view];
            
        }
        
    }];
    
    [request setFailedBlock:^{
        
        NSLog(@"%@", request.error);
    }];
    
    [request startAsynchronous];   
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc
{
    [super dealloc];
}

@end
