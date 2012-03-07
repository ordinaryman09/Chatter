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

@implementation DisplayViewController
//@synthesize theContent;
@synthesize theContent;
@synthesize myTableView;
@synthesize scrollView;
@synthesize mapView;
@synthesize threadTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setThreadID :(NSString*) threadID setContent:(NSString *)setContent setTitle:(NSString *)title {
    tID = threadID;
    content = setContent;
    titleText = title;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Comments";
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[arrayContent objectAtIndex:indexPath.row] objectAtIndex:2]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[arrayContent objectAtIndex:indexPath.row] objectAtIndex:1]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [arrayContent count];
}



- (IBAction)switchViews {
    [self.view removeFromSuperview];
    
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

- (void)viewDidLoad
{

    arrayContent = [[NSMutableArray alloc] init ];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // Dynamically resize the UILabel to fit the thread CONTENT
    [theContent setLineBreakMode:UILineBreakModeWordWrap];
    [theContent setMinimumFontSize:FONT_SIZE];
    [theContent setNumberOfLines:0];
    [theContent setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [theContent setTag:1];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    [theContent setText:content];
    
    // Set the UILabel frame's width and height
    [theContent setFrame:CGRectMake(theContent.frame.origin.x,theContent.frame.origin.y+10,size.width,size.height)];
    
    [myTableView setFrame:CGRectMake(myTableView.frame.origin.x, theContent.frame.origin.y+theContent.frame.size.height+5,[myTableView contentSize].width, MAX([myTableView contentSize].height+75,(screenHeight-(theContent.frame.origin.y+theContent.frame.size.height+5))))];
    
    self.scrollView.contentSize=CGSizeMake(screenWidth,myTableView.frame.origin.y+myTableView.frame.size.height);
    
    // Add a UI border to the MKMapView
    mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mapView.layer.borderWidth = 1.0f;
    
    
    // Show a hardcoded address on the map for now
    [self showAddress: 37.785834:-122.40641];

    
    // Finished UI setup, continue processing
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
        [myTableView setFrame:CGRectMake(myTableView.frame.origin.x, theContent.frame.origin.y+theContent.frame.size.height+5,[myTableView contentSize].width, MAX([myTableView contentSize].height+75,(screenHeight-(theContent.frame.origin.y+theContent.frame.size.height+5))))];
        
        // Finally, set the size of the scrollView so that it contains all UI items
        self.scrollView.contentSize=CGSizeMake(screenWidth,myTableView.frame.origin.y+myTableView.frame.size.height);
            
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
