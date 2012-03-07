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
#import "RecentPostController.h"

#import <QuartzCore/QuartzCore.h>
#define REFRESH_HEADER_HEIGHT 52.0f

@implementation SecondViewController

@synthesize myTableView, textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self addPullToRefreshHeader];
    contentArray = [[NSMutableArray alloc] init ];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    shouldLoadNew = NO;
    
    [locationManager startUpdatingLocation];
    
   
    
    // Dummy data that will be retrieved from the webserver
    NSString *jsonString = @"[{\"postId\": 1, \"title\": \"think i found something cool\", \"timestamp\": 318791347981, \"numUpvotes\": 23, \"numDownvotes\": 4, \"numComments\": 49}, {\"postId\": 2, \"title\":\"check this out UCLA!\", \"timestamp\": 318791323411, \"numUpvotes\": 19, \"numDownvotes\": 2, \"numComments\": 31}]";
    
    // Parse the JSON String into an NSDictionary object
   /* NSDictionary *deserializedData = [jsonString objectFromJSONString];
    
    // Log the results
    NSLog(@"%@", [deserializedData description]);
    
    // Iterate through each post in the array
    for (NSDictionary * dataDict in deserializedData) {
        // Extract the Post ID # from this post
        NSString * postTitle = [dataDict objectForKey:@"title"];
        NSLog(@"%@", postTitle);
        
        // Extract ..... everything else
    }
    // For each post in the array, add the post to the UI view (including the title, num upvotes, etc.)
    // Refresh the view? (don't know if this is necessary)
    */
 
    
    [super viewDidLoad];
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
    
    NSLog(@"%@", lat);
    
    // Initialize the URL string
    NSString * theStringURL = @"";
    
    if (shouldLoadNew) {
        // Load the most recent threads
        theStringURL = [NSString stringWithFormat:@"%@%@%@%@", @"http://www.williamliwu.com/chatter/getNearbyThreads.php?new=1&lat=", lat, @"&lng=", lon];
    } else {
        // Load the "hottest" threads
        theStringURL = [NSString stringWithFormat:@"%@%@%@%@", @"http://www.williamliwu.com/chatter/getNearbyThreads.php?new=0&lat=", lat, @"&lng=", lon];
    }
    
    NSLog(@"HAHA%@", theStringURL);
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:theStringURL]];
    
    
    [request setCompletionBlock:^{
        // Clear the data source in case we are refreshing
        [contentArray removeAllObjects];

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
            NSString *time = [dataDict objectForKey:@"TIMESTAMP"];
            //   NSLog(@"%@", testMe);
            
            NSArray *contents = [NSArray arrayWithObjects:iD, user, upVotes, downVotes, title,
                                content, time, nil];
            
            [contentArray addObject:contents];
            
            [self.myTableView reloadData];
            
            // Stop the loading animation if pull-to-refresh was used
            [self stopLoading];
            
        }
        // NSLog([titleArray objectAtIndex:0]);
        
        
    }];
    
    [request setFailedBlock:^{
        
        NSLog(@"%@", request.error);
    }];
    
    [request startAsynchronous];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [NSString stringWithFormat:@"%@",[[contentArray objectAtIndex:indexPath.row] objectAtIndex:4]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[contentArray objectAtIndex:indexPath.row] objectAtIndex:1]];
   // NSLog([titleArray objectAtIndex:indexPath.row]);
    //cell.value
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DisplayViewController *displayViewController = [[DisplayViewController alloc] initWithNibName:@"DisplayView" bundle:nil];
    
    // Initialize the display thread view controller with the thread ID and content
    [displayViewController setThreadID:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:0] setContent:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:5]];

    // Add the display view controller to the stack
    [self.view addSubview:displayViewController.view];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contentArray count];
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

// This function is not needed anymore, can be deleted
- (IBAction)switchViews {
    
    RecentPostController *recentPostController = [[RecentPostController alloc] initWithNibName:@"RecentPost" bundle:nil];
    
    [self.view addSubview:recentPostController.view];
    
    // [registerViewController release];
    
    
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

@end
