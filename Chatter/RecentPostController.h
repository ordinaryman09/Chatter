//
//  RecentPostController.h
//  Chatter
//
//  Created by Richard Lung on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONKit.h"

@interface RecentPostController : UIViewController 
<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    NSMutableArray * contentArray;
    IBOutlet UITableView *myTableView;
    NSString * lon;
    NSString * lat;
    CLLocationManager *locationManager;
}

- (IBAction)switchViews;

@property (nonatomic, retain) UITableView *myTableView;
@end
