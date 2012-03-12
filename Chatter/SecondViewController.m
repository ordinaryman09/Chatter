//
//  SecondViewController.m
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "DisplayViewController.h"
#import "ASIFormDataRequest.h"

#import <QuartzCore/QuartzCore.h>


@implementation SecondViewController

@synthesize myTableView, textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner, contentArray;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self addPullToRefreshHeader];
    self.contentArray = [[NSMutableArray alloc] init ];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    shouldLoadNew = NO;
    
    [locationManager startUpdatingLocation];
    
    [super viewDidLoad];
}

- (BOOL) isAuthorized {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *myPath = [self authFilePath];
    
    BOOL fileExists = [fileManager fileExistsAtPath:myPath];
    
    if (!fileExists) {
        // Pop-up notification telling user that invalid entry
        
        // [self.tabBarController setSelectedIndex:3];
        // [self.tabBarController.selectedViewController viewDidLoad];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not logged in" 
                                                        message:@"Please login or register a username." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
        
        
    }
    
    NSMutableArray *myUserName = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
    authUsername = [myUserName objectAtIndex:0];
    
    return YES;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	lat = @"";
    lon = @"";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    
    CLLocationCoordinate2D loc = [newLocation coordinate];
    
    lat = [[NSString stringWithFormat: @"%f", loc.latitude] retain];
    lon = [[NSString stringWithFormat: @"%f", loc.longitude] retain];
    
       
    ASIFormDataRequest *request;
    
    
    // Initialize the URL string
    NSString * theStringURL = @"";
    
    if (shouldLoadNew) {
        // Load the most recent threads
        theStringURL = [NSString stringWithFormat:@"%@%@%@%@", @"http://www.williamliwu.com/chatter/getNearbyThreads.php?new=1&lat=", lat, @"&lng=", lon];
    } else {
        // Load the "hottest" threads
        theStringURL = [NSString stringWithFormat:@"%@%@%@%@", @"http://www.williamliwu.com/chatter/getNearbyThreads.php?new=0&lat=", lat, @"&lng=", lon];
    }
    
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:theStringURL]];
    
    
    [request setCompletionBlock:^{

        // Clear the data source in case we are refreshing
        [self.contentArray removeAllObjects];

        NSDictionary *deserializedData = [request.responseString objectFromJSONString];
       
        for (NSDictionary * dataDict in deserializedData) {
            // Extract the Post ID # from this post
            //  NSString * postTitle = [dataDict objectForKey:@"UPVOTES"];
           
            NSString *iD = [dataDict objectForKey:@"ID"];
            NSString *user = [dataDict objectForKey:@"USER"];
            NSString *upVotes = [dataDict objectForKey:@"UPVOTES"];
            NSString *downVotes = [dataDict objectForKey:@"DOWNVOTES"];
            NSString *title = [dataDict objectForKey:@"TITLE"];
            NSString *content = [dataDict objectForKey:@"CONTENT"];
            NSString *latitude = [dataDict objectForKey:@"LATITUDE"];
            NSString *longitude = [dataDict objectForKey:@"LONGITUDE"];
            NSString *time = [dataDict objectForKey:@"TIMESTAMP"];
            
            
            
            
            NSArray *contents = [NSArray arrayWithObjects:iD, user, upVotes, downVotes, title,
                                content, latitude, longitude, time, nil];
            
            [self.contentArray addObject:contents];
            
            [self.myTableView reloadData];
            
            // Stop the loading animation if pull-to-refresh was used
            [self stopLoading];
            
        }
      

    }];
    
    [request setFailedBlock:^{
        
      
    }];
    
    [request startAsynchronous];
    
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
     
    NSString *text = [NSString stringWithFormat:@"%@",[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:4]];
    
    CGSize constraint = CGSizeMake(width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    if (!userLabel)
        userLabel = (UILabel*)[cell viewWithTag:2];
    
    if (!infoLabel)
        infoLabel = (UILabel*)[cell viewWithTag:3];
    
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, width - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    
    NSString * userLabelText = [NSString stringWithFormat:@"%@",[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    
    [userLabel setText:userLabelText];
    [userLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + label.frame.size.height, width - (CELL_CONTENT_MARGIN * 2), FONT_SIZE-4)];
  
    NSString * infoLabelText = [NSString stringWithFormat:@"%@ up  %@ down", [[contentArray objectAtIndex:indexPath.row] objectAtIndex:2], [[contentArray objectAtIndex:indexPath.row] objectAtIndex:3]];
    [infoLabel setText:infoLabelText];
    [infoLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + label.frame.size.height, width - (CELL_CONTENT_MARGIN * 2), FONT_SIZE-4)];

	// Configure the cell.
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [NSString stringWithFormat:@"%@",[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:4]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2)
    + (FONT_SIZE-4); // For the username at the bottom of each cell
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DisplayViewController *displayViewController = [[DisplayViewController alloc] initWithNibName:@"DisplayView" bundle:nil];

    // Initialize the display thread view controller with the thread ID and content
    [displayViewController setThreadID:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:0]
                            setContent:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:5] 
                              setTitle:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:4] 
                            setUpVotes:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:2]  
                          setDownVotes:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:3] 
                                setLat:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:6] 
                                setLon:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:7] 
                           setUserName:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:1] 
                          setTimeStamp:[[self.contentArray objectAtIndex:indexPath.row] objectAtIndex:8] ];

    // This is a stupid hack to pre-load the view so that the dynamic UI can be set up before the CurlUp transition occurs
    [displayViewController.view isOpaque];
    
    // Add the display view controller to the stack
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:displayViewController.view]; }
                    completion:nil];
    
    // Deselect the row after the new view is already displayed
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentArray count];
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

- (IBAction)loadNew {
    // Mark the BOOL to load New threads
    shouldLoadNew = YES;
    
    // Refresh the UITableView accordingly
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
}

- (IBAction)loadHot {
    // Mark the BOOL to load Hot threads
    shouldLoadNew = NO;
    
    // Refresh the UITableView accordingly
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}



- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.myTableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.myTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.myTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.myTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.myTableView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.myTableView.contentInset;
    tableContentInset.top = 0.0;
    self.myTableView.contentInset = tableContentInset;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}


- (void)refresh {
    // This is just a demo. Rewrite this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)dealloc
{
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    [super dealloc];
}

- (NSString *) authFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"loginSave1.plist"];
}

- (NSString *) saveFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"testSave1.plist"];
}



- (IBAction) showNewPostView {
    if ([self isAuthorized]) {
    ;
        
        //int rgbValue = 0x3366CC;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        
        //RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterView" bundle:nil];
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"AddPostView" owner:self options:nil];
        addPostView = [subviewArray objectAtIndex:0];
        addPostView.layer.cornerRadius = 15;
        
        addPostView.layer.masksToBounds = NO;
        //self.layer.cornerRadius = 8; // if you like rounded corners
        addPostView.layer.shadowOffset = CGSizeMake(0, 0);
        addPostView.layer.shadowRadius = 20;
        addPostView.layer.shadowOpacity = 0.8;
        addPostView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        addPostView.layer.borderWidth = 4.0f;
        addPostView.layer.shadowPath = [UIBezierPath bezierPathWithRect:addPostView.bounds].CGPath;
       
        [addPostView setFrame:CGRectMake(screenWidth/2-143, /*screenHeight/2-150*/17, addPostView.frame.size.width, addPostView.frame.size.height)];
        
        // Add the display view controller to the stack
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionAutoreverse //change to whatever animation you like
                        animations:^ { [self.view addSubview:addPostView]; }
                        completion:nil];
        
        // Add selector to the UIButton in the UserRegistrationView
        newTitleField = (UITextField*) [addPostView viewWithTag:10];
        newContentField = (UITextField*) [addPostView viewWithTag:11];
        UIButton* submitButton = (UIButton*) [addPostView viewWithTag:3];
        UIButton* closeButton = (UIButton*) [addPostView viewWithTag:13];
        newSubmitSpinner = [addPostView viewWithTag:4];
        
        newTitleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        newTitleField.returnKeyType = UIReturnKeyNext;
        newTitleField.delegate = self;
        [newContentField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
        [newContentField.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [newContentField.layer setBorderWidth: 1.0];
        [newContentField.layer setCornerRadius:8.0f];
        [newContentField.layer setMasksToBounds:YES];
        
        [newContentField setClipsToBounds: YES];
        newContentField.returnKeyType = UIReturnKeyDefault;
        newContentField.delegate = self;
      
        
        [submitButton addTarget:self 
                         action:@selector(submitPost:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [closeButton addTarget:self action:@selector(dismissNewPostView:) forControlEvents:UIControlEventTouchUpInside];
        [newTitleField becomeFirstResponder];
        
        //[self.view addSubview:userRegView];
        
        //[self.view addSubview:self.UserRegistrationView];
    }
    
}

- (void) dismissNewPostView:(id)sender {
    // Close the view
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionAutoreverse //change to whatever animation you like
                    animations:^ { [addPostView removeFromSuperview]; }
                    completion:nil];
}

-(void) submitPost:(id)sender {
    
    [newSubmitSpinner startAnimating];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/createThread.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request addPostValue:newTitleField.text forKey:@"title"];
    [request addPostValue:newContentField.text forKey:@"content"];
    [request addPostValue:lat forKey:@"lat"];
    [request addPostValue:lon forKey:@"lng"];
    [request addPostValue:authUsername forKey:@"username"];
    
    
    [request setCompletionBlock:^{
        
        [self dismissNewPostView:nil];
        [self refresh]; 
        
    }];
    
    [request setFailedBlock:^{
        
       
    }];
    
    [request startAsynchronous];    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //if (textField != regUserField && textField == regPassField && textField != regConfirmPassField) {
    
    //}
    
    if (textField == newTitleField) {
        [textField resignFirstResponder];
        [newContentField becomeFirstResponder];
    } else {
        
    }
    
    return YES;// return NO;
}

@end
