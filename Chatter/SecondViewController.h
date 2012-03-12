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
#define REFRESH_HEADER_HEIGHT 80.0f

@interface SecondViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    //NSMutableArray * contentArray;
    IBOutlet UITableView *myTableView;
    NSString * lon;
    NSString * lat;
    CLLocationManager *locationManager;
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    BOOL shouldLoadNew;
    
    UITextField * newTitleField;
    UITextView * newContentField;
    UIView * addPostView;
    UIActivityIndicatorView * newSubmitSpinner;
    NSString * userName;
    NSString * authUsername;

}

@property (nonatomic, retain) UITableView *myTableView;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (retain) NSMutableArray *contentArray;

//- (IBAction)switchViews;
- (IBAction)loadNew;
- (IBAction)loadHot;
- (IBAction)showNewPostView;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
//- (void) showNewUserView:(id)sender;
- (void) dismissNewPostView:(id)sender;
- (void) submitPost:(id)sender;
- (NSString *) saveFilePath;
- (NSString *) authFilePath;

@end
