//
//  DisplayViewController.h
//  Chatter
//
//  Created by Richard Lung on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DisplayViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>{
 
    NSString * tID;
    NSString * content;
    IBOutlet UITableViewCell *theContent;
    NSMutableArray *arrayContent;
    IBOutlet UITableView *myTableView;
}

-(void) setThreadID :(NSString*) threadID setContent:(NSString*)setContent;


@property (nonatomic, retain) UITableViewCell *theContent;
@property (nonatomic, retain) UITableView *myTableView;

- (IBAction)switchViews;

@end
