//
//  SecondViewController.m
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "ForFun.h"


@implementation SecondViewController

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = @"chillin in Sawtelle Curry House..";
    cell.detailTextLabel.text = @"alexw";
    //cell.value
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForFun *promptController = [[ForFun alloc] initWithNibName:@"ForFun" bundle:nil];
    NSLog(@"YEAH");
    //[self.navigationController pushViewController:promptController animated:YES];
    //self.view = promptController.view;
    [self presentModalViewController:promptController animated:YES];
    [promptController release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
