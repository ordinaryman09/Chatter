//
//  RecentPostController.m
//  Chatter
//
//  Created by Richard Lung on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentPostController.h"
#import "DisplayViewController.h"
#import "ASIFormDataRequest.h"



@implementation RecentPostController

@synthesize myTableView;




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    contentArray = [[NSMutableArray alloc] init ];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
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

- (IBAction)switchViews {
    [self.view removeFromSuperview];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    
    CLLocationCoordinate2D loc = [newLocation coordinate];
    
    lat = [[NSString stringWithFormat: @"%f", loc.latitude] retain];
    lon = [[NSString stringWithFormat: @"%f", loc.longitude] retain];
    
    
    ASIFormDataRequest *request;
    
    NSLog(@"%@", lat);
    
    NSString * theStringURL = [NSString stringWithFormat:@"%@%@%@%@", @"http://www.williamliwu.com/chatter/getNearbyThreads.php?new=1&lat=", lat, @"&lng=", lon, @"&new=1"];
    
    NSLog(@"HAHA%@", theStringURL);
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:theStringURL]];
    
    
    [request setCompletionBlock:^{
        
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
    
    [displayViewController setThreadID:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:0]setContent:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:5]];
    
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


- (void) viewWillAppear:(BOOL)animated {
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
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
