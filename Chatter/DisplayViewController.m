//
//  DisplayViewController.m
//  Chatter
//
//  Created by Richard Lung on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DisplayViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "AddCommentView.h"
#import <QuartzCore/QuartzCore.h>


@implementation DisplayViewController
//@synthesize theContent;
@synthesize theContent;
@synthesize myTableView;
@synthesize scrollView;
@synthesize mapView;
@synthesize threadTitle;
@synthesize theUserName;
@synthesize theTimeStamp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction) sendRequest {
    
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/makeComment.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request addPostValue:commentField.text forKey:@"content"];
    [request addPostValue:user forKey:@"username"];
    [request addPostValue:tID forKey:@"thread_id"];
    
    NSLog(@"%@", commentField.text);
    NSLog(@"%@", user);
    NSLog(@"%@", tID);
    
    
    [request setCompletionBlock:^{
        
        [self dismissNewUserView: Nil];
        
    }];
        
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





-(void) setThreadID :(NSString*) threadID setContent:(NSString *)setContent setTitle:(NSString *)title setUpVotes:(NSString *)up setDownVotes:(NSString *)down setLat:(NSString *)theLat setLon:(NSString *)theLon setUserName:(NSString *)theUser setTimeStamp:(NSString *)theTime{
    tID = threadID;
    content = setContent;
    titleText = title;
    upVotes = up;
    downVotes = down;
    lat = theLat;
    lon = theLon;
    user = theUser;
    timeStamp = theTime;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Comments";
   
    
}


- (void) testMe {
    NSLog(@"TU");
}


- (void) testYou {
    NSLog(@"TD");
}

-(void)infoButtonPressed:(id)sender 
{
    // here you can access the object which triggered the method
    // for example you can check the tag value
    
    NSLog(@"the tag value is: %d", [sender tag]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    UILabel *label = nil;
    UILabel *userLabel = nil;
    UILabel *infoLabel = nil;
    float width = 300;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        label.backgroundColor = [UIColor clearColor];
        
        userLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [userLabel setLineBreakMode:UILineBreakModeWordWrap];
        [userLabel setMinimumFontSize:FONT_SIZE-4];
        [userLabel setNumberOfLines:0];
        [userLabel setFont:[UIFont systemFontOfSize:FONT_SIZE-4]];
        [userLabel setTag:2];
        userLabel.backgroundColor = [UIColor clearColor];
        userLabel.textColor = [UIColor lightGrayColor];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [infoLabel setLineBreakMode:UILineBreakModeWordWrap];
        [infoLabel setMinimumFontSize:FONT_SIZE-4];
        [infoLabel setNumberOfLines:0];
        [infoLabel setFont:[UIFont systemFontOfSize:FONT_SIZE-4]];
        [infoLabel setTag:3];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor lightGrayColor];
        infoLabel.textAlignment = UITextAlignmentRight;
        
        [[cell contentView] addSubview:label];
        [[cell contentView] addSubview:userLabel];
        [[cell contentView] addSubview:infoLabel];
        
    }
    
    NSString *text = [NSString stringWithFormat:@"%@",[[arrayContent objectAtIndex:indexPath.row] objectAtIndex:2]];
    
    CGSize constraint = CGSizeMake(width - (CELL_CONTENT_MARGIN * 2) - 30, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    if (!userLabel)
        userLabel = (UILabel*)[cell viewWithTag:2];
    
    if (!infoLabel)
        infoLabel = (UILabel*)[cell viewWithTag:3];
    
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, width - (CELL_CONTENT_MARGIN * 2) - 30, MAX(size.height, 44.0f))];
    
    NSString * userLabelText = [NSString stringWithFormat:@"%@",[[arrayContent objectAtIndex:indexPath.row] objectAtIndex:1]];

    [userLabel setText:userLabelText];
    [userLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + label.frame.size.height, width - (CELL_CONTENT_MARGIN * 2), FONT_SIZE-4)];

    NSString * infoLabelText = [NSString stringWithFormat:@"%@ up  %@ down", [[arrayContent objectAtIndex:indexPath.row] objectAtIndex:3], [[arrayContent objectAtIndex:indexPath.row] objectAtIndex:4]];
    [infoLabel setText:infoLabelText];
    [infoLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + label.frame.size.height, width - (CELL_CONTENT_MARGIN * 2), FONT_SIZE-4)];

    
    float halfHeight = ((CELL_CONTENT_MARGIN * 2) + MAX(size.height, 44.0f) + (FONT_SIZE - 4))/2;
    
    UIImage *tuImage;
    UIButton * tuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tuImage = [UIImage imageNamed:@"tu.png"];
    [tuButton setBackgroundImage:tuImage forState:UIControlStateNormal];
    // buyButton.frame = CGRectMake(220, 35, 96, 34);
    tuButton.frame = CGRectMake(245, halfHeight-8, 16, 16);
    [tuButton setTag:indexPath.row];
    [tuButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:tuButton];
    
    
    UIImage *tdImage;
    UIButton * tdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tdImage = [UIImage imageNamed:@"td.png"];
    [tdButton setBackgroundImage:tdImage forState:UIControlStateNormal];
    // buyButton.frame = CGRectMake(220, 35, 96, 34);
    tdButton.frame = CGRectMake(275, halfHeight-8, 16, 16);
    [tdButton setTag:indexPath.row];
    [tdButton addTarget:self action:@selector(downVote) forControlEvents:UIControlEventTouchDown];
    [cell.contentView addSubview:tdButton];
    
    /*UILabel *upLabel = [[[UILabel alloc] initWithFrame:CGRectMake( 224, halfHeight-8, 20.0, 10.0 )] autorelease];
    
    
    [upLabel setText:upVotes];
    [upLabel setMinimumFontSize:FONT_SIZE-4];
    [upLabel setNumberOfLines:0];
    [upLabel setFont:[UIFont systemFontOfSize:FONT_SIZE-4]];
    upLabel.backgroundColor = [UIColor clearColor];
    upLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview: upLabel];
    
    UILabel *downLabel = [[[UILabel alloc] initWithFrame:CGRectMake( 260, halfHeight-8, 20.0, 10.0 )] autorelease];
    
    [downLabel setText:downVotes];
    NSLog(downVotes);
    [downLabel setMinimumFontSize:FONT_SIZE-4];
    [downLabel setNumberOfLines:0];
    [downLabel setFont:[UIFont systemFontOfSize:FONT_SIZE-4]];
    /*downLabel.backgroundColor = [UIColor clearColor];
    downLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview: downLabel];*/
    
    return cell;
    
    
    
    ////// TEMPORARILY COMMENTED OUT
    
    /*static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    UIImage *tuImage;
    UIButton * tuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tuImage = [UIImage imageNamed:@"tu.png"];
    [tuButton setBackgroundImage:tuImage forState:UIControlStateNormal];
    // buyButton.frame = CGRectMake(220, 35, 96, 34);
    tuButton.frame = CGRectMake(239, 12, 16, 16);
    [tuButton setTag:indexPath.row];
    [tuButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:tuButton];
    
   
    UIImage *tdImage;
    UIButton * tdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tdImage = [UIImage imageNamed:@"td.png"];
    [tdButton setBackgroundImage:tdImage forState:UIControlStateNormal];
    // buyButton.frame = CGRectMake(220, 35, 96, 34);
    tdButton.frame = CGRectMake(275, 18, 16, 16);
    [tdButton setTag:indexPath.row];
    [tdButton addTarget:self action:@selector(downVote) forControlEvents:UIControlEventTouchDown];
    [cell.contentView addSubview:tdButton];
    
    UILabel *upLabel = [[[UILabel alloc] initWithFrame:CGRectMake( 224, 17, 10.0, 10.0 )] autorelease];

    
    [upLabel setText:upVotes];
    [cell.contentView addSubview: upLabel];
    
    UILabel *downLabel = [[[UILabel alloc] initWithFrame:CGRectMake( 260, 17, 10.0, 10.0 )] autorelease];
    
    [downLabel setText:downVotes];
    [cell.contentView addSubview: downLabel];*/
     
    
   // cell.textLabel.text = [NSString stringWithFormat:@"%@",[[arrayContent objectAtIndex:indexPath.row] objectAtIndex:2]];
    
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [NSString stringWithFormat:@"%@",[[arrayContent objectAtIndex:indexPath.row] objectAtIndex:2]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - 30, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2)
            + (FONT_SIZE-4); // For the username at the bottom of each cell
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [arrayContent count];
}



- (IBAction)switchViews {
   // [self.view removeFromSuperview];
    
    [UIView transitionWithView:self.view.superview duration:0.5
                       options:UIViewAnimationOptionTransitionCurlDown //change to whatever animation you like
                    animations:^ { [self.view removeFromSuperview]; }
                    completion:nil];
    
    // [registerViewController release];
    
    
}


- (IBAction) upVote {
    NSLog(@"%@", tID);
    
    //[self theContent]
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.williamliwu.com/chatter/voteThread.php?id=%@&vote=UPVOTE", tID]];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (IBAction)downVote {
    NSLog(@"%@", tID);
    
    //[self theContent]
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.williamliwu.com/chatter/voteThread.php?id=%@&vote=DOWNVOTE", tID]];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)dealloc
{
    [theContent release];
    [scrollView release];
    [mapView release];
    [threadTitle release];
    [headerView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) viewWillAppear:(BOOL)animated {

   

}

- (void) showAddress: (float)mapLatitude: (float)mapLongitude {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
     
    span.latitudeDelta=0.01;
    span.longitudeDelta=0.01;
    
    CLLocationCoordinate2D location;
    location.latitude = mapLatitude;
    location.longitude = mapLongitude;
    
    region.span=span;
    region.center=location;
   /* if(addAnnotation != nil) {
        [mapView removeAnnotation:addAnnotation];
        [addAnnotation release];
        addAnnotation = nil;
    }
    addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location]; 
    [mapView addAnnotation:addAnnotation]; */

    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
}

- (void) dismissNewUserView:(id)sender {
    // Close the view
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                    animations:^ { [commentView removeFromSuperview]; }
                    completion:nil];
}


- (void)viewDidLoad
{

    theUserName.text = user;
    
    arrayContent = [[NSMutableArray alloc] init ];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // Dynamically resize the UILabels to fit the thread title and content
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);

    [theContent setLineBreakMode:UILineBreakModeWordWrap];
    [theContent setMinimumFontSize:FONT_SIZE];
    [theContent setNumberOfLines:0];
    [theContent setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [theContent setTag:1];
    CGSize sizeContent = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    [theContent setText:content];
    [theContent setFrame:CGRectMake(theContent.frame.origin.x,theContent.frame.origin.y+10,sizeContent.width,sizeContent.height)];
    
    NSString *tempTitle = [@"\"" stringByAppendingString:[titleText stringByAppendingString:@"\""]];
    [self.threadTitle setLineBreakMode:UILineBreakModeWordWrap];
    [self.threadTitle setMinimumFontSize:FONT_SIZE+1];
    [self.threadTitle setNumberOfLines:0];
    [self.threadTitle setFont:[UIFont boldSystemFontOfSize:FONT_SIZE+1]];
    [self.threadTitle setTag:1];
    CGSize sizeTitle = [tempTitle sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE+1] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    [self.threadTitle setText:tempTitle];
    [self.threadTitle setFrame:CGRectMake(self.threadTitle.frame.origin.x,
                                          self.threadTitle.frame.origin.y+10,
                                          sizeTitle.width,
                                          sizeTitle.height)];
    
    // First reposition the Map and user/lifetime info
    [headerView setFrame:CGRectMake(headerView.frame.origin.x, 
                                    headerView.frame.origin.y + self.threadTitle.frame.size.height - 10, 
                                    screenWidth, 
                                    headerView.frame.size.height)];
    
    // Position the comments with respect to the dynamically sized layout
    [myTableView setFrame:CGRectMake(myTableView.frame.origin.x,
                                     headerView.frame.origin.y + headerView.frame.size.height + theContent.frame.size.height,
                                     [myTableView contentSize].width,
                                     MAX([myTableView contentSize].height+75,
                                         (screenHeight-(headerView.frame.origin.y + headerView.frame.size.height + theContent.frame.size.height))))];
    
    self.scrollView.contentSize = CGSizeMake(screenWidth, myTableView.frame.origin.y + myTableView.frame.size.height);
    
    // Add a UI border to the MKMapView
    mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mapView.layer.borderWidth = 1.0f;
    
    // Show a hardcoded address on the map for now
    [self showAddress: [lat floatValue]:[lon floatValue]];
    
    // Finished UI setup, continue processing
    float currentTime = [[NSDate date] timeIntervalSince1970];
    float postTime = [timeStamp floatValue];
    
    float timeDifference = currentTime - postTime;
    
    NSTimeInterval theTimeInterval = timeDifference;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1]; 
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
   // NSLog(@"Conversion: %dmonths %ddays %dhours",/*[conversionInfo minute],*/ [conversionInfo month], [conversionInfo day], [conversionInfo hour]);
    
    [date1 release];
    [date2 release];
    
    theTimeStamp.text = [NSString stringWithFormat:@"Posted %d days %d hours ago", [conversionInfo day], [conversionInfo hour]];
    
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/viewCommentsByThread.php"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request addPostValue:tID forKey:@"tid"];
    
    [request setCompletionBlock:^{
        
       NSLog(@"%@", request.responseString);
        
        NSDictionary *deserializedData = [request.responseString objectFromJSONString];
        
        for (NSDictionary * dataDict in deserializedData) {
            // Extract the Post ID # from this post
            //  NSString * postTitle = [dataDict objectForKey:@"UPVOTES"];
            //NSLog(@"%@", postTitle);
            NSString *iD = [dataDict objectForKey:@"ID"];
            NSString *user = [dataDict objectForKey:@"USER"];
            NSString *comment = [dataDict objectForKey:@"CONTENT"];
            NSString *upVotes = [dataDict objectForKey:@"UPVOTES"];
            NSString *downVotes = [dataDict objectForKey:@"DOWNVOTES"];
            NSString *time = [dataDict objectForKey:@"TIMESTAMP"];
          
            NSLog(@"%@", iD);
            
            NSArray *contents = [NSArray arrayWithObjects:iD, user, comment ,upVotes, downVotes,
                                 time, nil];
            
            [arrayContent addObject:contents];
            
            [self.myTableView reloadData];
        }
        
        // Finish setting up the UI
        // Will's Note: This code has to be here, because the friggin' contentSize of the UITableView isn't set correctly until
        //              the HTTP request is finished and the comments have been loaded into the dataStore. This seems obvious but
        //              it took two hours of debugging to figure it out.
        
        // Set the position of the UITableView
        [myTableView layoutIfNeeded];
        [myTableView setFrame:CGRectMake(myTableView.frame.origin.x,
                                         headerView.frame.origin.y + headerView.frame.size.height + theContent.frame.size.height,
                                         [myTableView contentSize].width,
                                         MAX([myTableView contentSize].height+75,
                                             (screenHeight-(headerView.frame.origin.y+headerView.frame.size.height + theContent.frame.size.height))))];
        
        self.scrollView.contentSize = CGSizeMake(screenWidth, myTableView.frame.origin.y+myTableView.frame.size.height);
        
    }];
        
        [request setFailedBlock:^{
            
            NSLog(@"%@", request.error);
        }];
        
        [request startAsynchronous];  
    
    [self.myTableView reloadData];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTheContent:nil];
    [self setScrollView:nil];
    [self setMapView:nil];
    [self setThreadTitle:nil];
    [headerView release];
    headerView = nil;
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
