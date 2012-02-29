//
//  SecondViewController.h
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"

@interface SecondViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray * titleArray;
    IBOutlet UITableView *myTableView;
}

@property (nonatomic, retain) UITableView *myTableView;

@end
