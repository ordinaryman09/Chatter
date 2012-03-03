//
//  SecondViewController.h
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONKit.h"

@interface SecondViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    NSMutableArray * titleArray;
    IBOutlet UITableView *myTableView;
    NSString * lon;
    NSString * lat;
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) UITableView *myTableView;

@end
