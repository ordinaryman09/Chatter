//
//  AddCommentView.m
//  Chatter
//
//  Created by William Wu on 12/31/00.
//  Copyright (c) 2000 __MyCompanyName__. All rights reserved.
//

#import "AddCommentView.h"
#import "UIImage+Scale.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddCommentView

@synthesize theContent;


-(void) setThreadID :(NSString*) threadID setUserName:(NSString *) theUser {
    userName = theUser;
    tID = threadID;
}


-(IBAction) backRequest {
    [self.view removeFromSuperview];
    
}


-(IBAction) sendRequest {
    
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/makeComment.php"];
    request = [ASIFormDataRequest requestWithURL:url];
    
    [request addPostValue:commentField.text forKey:@"content"];
    [request addPostValue:userName forKey:@"username"];
    [request addPostValue:tID forKey:@"thread_id"];
    
    NSLog(@"%@", theContent.text);
    NSLog(@"%@", userName);
    NSLog(@"%@", tID);
    
    [request setFailedBlock:^{
        
        NSLog(@"%@", request.error);
    }];
    
    [request startAsynchronous];   
    
}

- (IBAction) showNewUserView {
    
    int rgbValue = 0x3366CC;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    /*
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
    */
    
    
    //RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterView" bundle:nil];
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"AddCommentView" owner:self options:nil];
    commentView = [subviewArray objectAtIndex:0];
    commentView.layer.cornerRadius = 15;
    
    commentView.layer.masksToBounds = NO;
    //self.layer.cornerRadius = 8; // if you like rounded corners
    commentView.layer.shadowOffset = CGSizeMake(0, 0);
    commentView.layer.shadowRadius = 20;
    commentView.layer.shadowOpacity = 0.8;
    commentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    commentView.layer.borderWidth = 4.0f;
    commentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:commentView.bounds].CGPath;
    NSLog(@"%f %f",commentView.frame.size.width, commentView.frame.size.height);
    [commentView setFrame:CGRectMake(screenWidth/2-143, /*screenHeight/2-150*/17, commentView.frame.size.width, commentView.frame.size.height)];
    
    // Add the display view controller to the stack
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                    animations:^ { [self.view addSubview:commentView]; }
                    completion:nil];
    
    // Add selector to the UIButton in the UserRegistrationView
    //regUserField = (UITextField*) [commentView viewWithTag:10];
    //commentField = (UITextField*) [commentView viewWithTag:11];
    //regConfirmPassField = (UITextField*) [commentView viewWithTag:12];
    UIButton* submitButton = (UIButton*) [commentView viewWithTag:3];
    UIButton* closeButton = (UIButton*) [commentView viewWithTag:13];
    commentSpinner = [commentView viewWithTag:4];
    //regFailLabel = (UILabel*) [commentView viewWithTag:5];
    
    
    //commentField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //commentField.returnKeyType = UIReturnKeyNext;
    //commentField.delegate = self;
    //commentField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //int rgbValue = 0x3366CC;
    commentField.textColor = [UIColor \
                              colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                              green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                              blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    commentField.autocorrectionType = UITextAutocorrectionTypeNo;
    /*
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
    */
    
    //NSLog(@"%@", regUserField.text);
    /*regUserField.delegate = self;
     regPassField.delegate = self;
     regConfirmPassField.delegate = self;*/
    
    [submitButton addTarget:self 
                     action:@selector(sendRequest)
           forControlEvents:UIControlEventTouchUpInside];
    
    [closeButton addTarget:self action:@selector(dismissNewUserView:) forControlEvents:UIControlEventTouchUpInside];
    [commentField becomeFirstResponder];
    
    //[self.view addSubview:commentView];
    
    //[self.view addSubview:self.UserRegistrationView];
    
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [super viewDidLoad];
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
