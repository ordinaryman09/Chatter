//
//  MyPostController.h
//  Chatter
//
//  Created by Richard Lung on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface MyPostController : UIViewController
<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *theTableView;
    NSMutableArray *saveLogin;
    NSMutableArray *contentArray;
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
}

- (IBAction)switchViews;
@property (nonatomic, retain) UITableView *theTableView;

@end
