//
//  ThirdViewController.h
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThirdViewController : UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{

    UIImagePickerController *ipc;
    IBOutlet UIImageView *theImage;
    IBOutlet UIButton *theButton;
    
    
}

@property (nonatomic, retain) UIImageView *theImage;

@property (nonatomic, retain) UIButton *theButton;


-(IBAction) buttonClicked;


@end
