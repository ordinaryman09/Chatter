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
@synthesize theTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [displayViewController setThreadID:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:0] setContent:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:5] setTitle:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:4] setUpVotes:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:2]  setDownVotes:[[contentArray objectAtIndex:indexPath.row] objectAtIndex:3] ];
    
    // Add the display view controller to the stack
    [self.view addSubview:displayViewController.view];
    
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
    contentArray = [[NSMutableArray alloc] init ];
    
    NSString *myPath = [self saveFilePath];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
    
    if(fileExists) {
        
        [contentArray removeAllObjects];
        NSLog(@"FILE EXIST");
        saveLogin= [[NSMutableArray alloc] initWithContentsOfFile:myPath];
        NSLog(@"%@", [saveLogin objectAtIndex:0]);
        
        
        NSString * theStringURL = [NSString stringWithFormat:@"%@%@%@", @"http://www.williamliwu.com/chatter/getMyPosts.php?user='", [saveLogin objectAtIndex:0], @"'"];
        NSLog(@"%@", theStringURL);
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:theStringURL]];
        
        
        [request setCompletionBlock:^{
            // Clear the data source in case we are refreshing
            //[arrayContent removeAllObjects];
            
           // NSLog(@"%@", request.responseString);
            
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
                
                NSArray *contents = [NSArray arrayWithObjects:iD, user, upVotes, downVotes, title,content, time, nil];
                
                [contentArray addObject:contents];
                
                [self.theTableView reloadData];
                
                
                // Stop the loading animation if pull-to-refresh was used
               // [self stopLoading];
                
            }
            
            // NSLog([titleArray objectAtIndex:0]);
            
            
        }];
        
        [request setFailedBlock:^{
            
            NSLog(@"%@", request.error);
        }];
        
        [request startAsynchronous];
       // [self.myTableView reloadData];
        
    }
    
    else {
        
        NSLog(@"u fail");
       // arrayContent = [[NSMutableArray alloc] init ];
        
           
        
    }

    //NSLog(@"yay%@", arrayContent);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
     //NSLog([titleArray objectAtIndex:indexPath.row]);
    //cell.value
    return cell;
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
