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
    NSString * upVotes;
    NSString * downVotes;
    NSString * lat;
    NSString * lon;
    NSString * user;
    NSString * timeStamp;
    IBOutlet UILabel *theContent;
    NSMutableArray *arrayContent;
    //IBOutlet UITableView *myTableView;
    //IBOutlet UILabel *theUserName;
    //IBOutlet UILabel *theTimeStamp;
    //IBOutlet UILabel *threadTitle;
    UIView *commentView;
    UIActivityIndicatorView *commentSpinner;
    UIImagePickerController *ipc;
    IBOutlet UITextView *commentField;
    
    NSString * authUsername;


}

-(void) setThreadID:(NSString*)threadID setContent:(NSString*)setContent setTitle:(NSString *)title setUpVotes:(NSString *) up setDownVotes:(NSString *) down setLat:(NSString*) theLat
             setLon:(NSString *) theLon setUserName:(NSString *)theUser setTimeStamp:(NSString*)
                theTime;


@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *theContent;
//@property (nonatomic, retain) UILabel *theContent;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
//@property (nonatomic, retain) UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UILabel *threadTitle;
@property (retain, nonatomic) IBOutlet UILabel *theUserName;
@property (retain, nonatomic) IBOutlet UILabel *theTimeStamp;
//@property (retain, nonatomic) IBOutlet UILabel *theTitle;

- (IBAction)switchViews;
- (IBAction)addComment;
- (IBAction)upVote;
- (IBAction)downVote;
- (IBAction) showNewCommentView;
- (void) sendRequest :(NSString*) threadID setUserName:(NSString *)theUser;
-(void) refresh;

- (void) showAddress: (float)mapLatitude: (float)mapLongitude;

@end
