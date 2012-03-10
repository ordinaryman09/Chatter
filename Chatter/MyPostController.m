//
//  MyPostController.m
//  Chatter
//
//  Created by Richard Lung on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MyPostController.h"
#import "DisplayViewController.h"


@implementation MyPostController
@synthesize theTableView, textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}


- (NSString *) saveFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"loginSave1.plist"];
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DisplayViewController *displayViewController = [[DisplayViewController alloc] initWithNibName:@"DisplayView" bundle:nil];
    
    // Initialize the display thread view controller with the thread ID and content
     [displayViewController setThreadID:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:0] setContent:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:5] setTitle:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:4] setUpVotes:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:2]  setDownVotes:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:3] setLat:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:6] setLon:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:7] setUserName:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:1] setTimeStamp:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:8] ];
    
    // Add the display view controller to the stack
    //[self.view addSubview:displayViewController.view];
    
    // This is a stupid hack to pre-load the view so that the dynamic UI can be set up before the CurlUp transition occurs
    [displayViewController.view isOpaque];
    
    // Add the display view controller to the stack
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:displayViewController.view]; }
                    completion:nil];
    
    // Deselect the row after the new view is already displayed
    [self.theTableView deselectRowAtIndexPath:[self.theTableView indexPathForSelectedRow] animated:YES];

    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d", [contentArray count]);
    return [contentArray count];
}

- (IBAction)switchViews {
       [self.view removeFromSuperview];
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) loadTableData {
    
    NSString *myPath = [self saveFilePath];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
    
    if(fileExists) {
        
        NSLog(@"FILE EXIST");
        saveLogin= [[NSMutableArray alloc] initWithContentsOfFile:myPath];
        NSLog(@"%@", [saveLogin objectAtIndex:0]);
        
        
        NSString * theStringURL = [NSString stringWithFormat:@"%@%@%@", @"http://www.williamliwu.com/chatter/getMyPosts.php?user='", [saveLogin objectAtIndex:0], @"'"];
        NSLog(@"%@", theStringURL);
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:theStringURL]];
        
        
        [request setCompletionBlock:^{
            // Clear the data source in case we are refreshing
            [contentArray removeAllObjects];
            
            // NSLog(@"%@", request.responseString);
            NSLog(@"Entering completion block");
            NSDictionary *deserializedData = [request.responseString objectFromJSONString];
            
            for (NSDictionary * dataDict in deserializedData) {
                // Extract the Post ID # from this post
                //  NSString * postTitle = [dataDict objectForKey:@"UPVOTES"];
                //NSLog(@"%@", postTitle);
                NSString *iD = [dataDict objectForKey:@"ID"];
                NSString *user = [dataDict objectForKey:@"USER"];
                NSString *upVotes = [dataDict objectForKey:@"UPVOTES"];
                NSString *downVotes = [dataDict objectForKey:@"DOWNVOTES"];
                NSString *title = [dataDict objectForKey:@"TITLE"];
                NSString *content = [dataDict objectForKey:@"CONTENT"];
                NSString *latitude = [dataDict objectForKey:@"LATITUDE"];
                NSString *longitude = [dataDict objectForKey:@"LONGITUDE"];
                NSString *time = [dataDict objectForKey:@"TIMESTAMP"];
                
                
                   NSLog(@"%@", @"KGO");
                
                NSArray *contents = [NSArray arrayWithObjects:iD, user, upVotes, downVotes, title,
                                     content, latitude, longitude, time, nil];
                
                [contentArray addObject:contents];
                
                [self.theTableView reloadData];
                
                
                
            }
            // Stop the loading animation if pull-to-refresh was used
            [self stopLoading];
            NSLog(@"%@", @"DONE LOADING");
            
            
            
            
            
            // NSLog([titleArray objectAtIndex:0]);
            
            
        }];
        
        [request setFailedBlock:^{
            
            NSLog(@"%@", request.error);
        }];
        
        NSLog(@"Starting asynchronous");
        [request startAsynchronous];
        // [self.myTableView reloadData];
        
    }
    
    else {
        
        NSLog(@"u fail");
        // arrayContent = [[NSMutableArray alloc] init ];
        
        
        
    }
}
- (void)viewDidAppear:(BOOL)animated {
    // Check to see if the user is logged in
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *myPath = [self saveFilePath];
    
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
        
        
    }
    
    [self refresh];
}
- (void)viewDidLoad
{
    contentArray = [[NSMutableArray alloc] init ];
    [self addPullToRefreshHeader];
    
    
    
    
    //[self loadTableData];

    //NSLog(@"yay%@", arrayContent);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    NSString *text = [NSString stringWithFormat:@"%@",[[contentArray objectAtIndex:indexPath.row] objectAtIndex:4]];
    //NSLog(@"%@", text);
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
    
    NSString * userLabelText = [NSString stringWithFormat:@"%@",[[contentArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    
    [userLabel setText:userLabelText];
    [userLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + label.frame.size.height, width - (CELL_CONTENT_MARGIN * 2), FONT_SIZE-4)];
    
    NSString * infoLabelText = @"";
    [infoLabel setText:infoLabelText];
    [infoLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + label.frame.size.height, width - (CELL_CONTENT_MARGIN * 2), FONT_SIZE-4)];
    
	// Configure the cell.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // NSLog([titleArray objectAtIndex:indexPath.row]);
    //cell.value
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [NSString stringWithFormat:@"%@",[[contentArray objectAtIndex:indexPath.row] objectAtIndex:4]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2)
    + (FONT_SIZE-4); // For the username at the bottom of each cell
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
    [self.theTableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.theTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.theTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
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
    self.theTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
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
    self.theTableView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.theTableView.contentInset;
    tableContentInset.top = 0.0;
    self.theTableView.contentInset = tableContentInset;
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
    NSLog(@"Reloading table data");
    [self loadTableData];
    
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}


@end
