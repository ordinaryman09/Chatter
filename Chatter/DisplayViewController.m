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
@synthesize theContent;
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setThreadID :(NSString*) threadID setContent:(NSString *)setContent {
    tID = threadID;
    content = setContent;
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
    NSLog(@"Upvote");
    
    NSLog(@"UPVOTE");
    
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/voteThread.php?id=55&vote=UPVOTE"];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];

    
    
}

- (IBAction)downVote {
    
    
    
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

    arrayContent = [[NSMutableArray alloc] init ];
    theContent.textLabel.text = content;
    
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
