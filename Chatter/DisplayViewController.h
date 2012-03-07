//
//  DisplayViewController.h
//  Chatter
//
//  Created by Richard Lung on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f


@interface DisplayViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
{ 
    NSString * tID;
    NSString * content;
    NSString * titleText;
    IBOutlet UILabel *theContent;
    NSMutableArray *arrayContent;
    IBOutlet UITableView *myTableView;
}

-(void) setThreadID:(NSString*)threadID setContent:(NSString*)setContent setTitle:(NSString *)title;


@property (retain, nonatomic) IBOutlet UILabel *theContent;
//@property (nonatomic, retain) UILabel *theContent;
@property (nonatomic, retain) UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UILabel *threadTitle;

- (IBAction)switchViews;
- (IBAction)upVote;
- (IBAction)downVote;
- (void) showAddress: (float)mapLatitude: (float)mapLongitude;

@end
