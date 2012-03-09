//
//  SettingsViewController.m
//  Chatter
//
//  Created by William Wu on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Account Setup";
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel *startDtLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
        startDtLbl.font = [UIFont boldSystemFontOfSize:16];
        if (indexPath.row == 0)
            startDtLbl.text = @"Username";
        else {
            startDtLbl.text = @"Password";
        }
        
        startDtLbl.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:startDtLbl];
        
        if (indexPath.row == 0) {
            userField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
            userField.delegate = self;
            userField.clearButtonMode = UITextFieldViewModeWhileEditing;
            userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            [userField addTarget:self 
                          action:@selector(methodToFire:)
                forControlEvents:UIControlEventEditingDidEndOnExit];
            
            int rgbValue = 0x3366CC;
            userField.textColor = [UIColor \
                                   colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                   green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                   blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
            userField.autocorrectionType = UITextAutocorrectionTypeNo;
            userField.tag = 0;
            [cell.contentView addSubview:userField];
        } else {
            passField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 20)];
            passField.delegate = self;
            passField.clearButtonMode = UITextFieldViewModeWhileEditing;
            passField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            [passField addTarget:self 
                          action:@selector(methodToFire:)
                forControlEvents:UIControlEventEditingDidEndOnExit];
            
            int rgbValue = 0x3366CC;
            passField.textColor = [UIColor \
                                   colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                   green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                   blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
            passField.secureTextEntry = YES;
            passField.tag = 1;
            passField.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:passField];
            
        }
        
        /*if (indexPath.row == 0)
            passwordTF.tag = 0;
        else {
            passwordTF.tag = 1;
            passwordTF.secureTextEntry = YES;
        }*/
        
        
    }
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    // If the user has just entered in a password
    if (textField.tag == 1) {
        // Check to make sure they have also entered in a username
        if ([userField.text length] > 0) {
            NSLog(@"YEP");
        } else {
            // Pop-up notification telling user that invalid entry
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No username provided" 
                                                            message:@"You must enter a valid username." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    //do stuff
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
