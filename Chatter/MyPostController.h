//
//  MyPostController.h
//  Chatter
//
//  Created by Richard Lung on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyPostController : UIViewController
<UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *arrayContent;
    
}

- (IBAction)switchViews;

@end
