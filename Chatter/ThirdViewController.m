//
//  ThirdViewController.m
//  Chatter
//
//  Created by Richard Lung on 2/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"
#import "UIImage+Scale.h"



@implementation ThirdViewController


//@synthesize theImage;
@synthesize theButton;
@synthesize theTitle;
@synthesize theContent;


-(IBAction) sendRequest {
 
    NSURL *url = [NSURL URLWithString:@"http://www.williamliwu.com/chatter/createThread.php"];
    request = [ASIFormDataRequest requestWithURL:url];
    
    [request addPostValue:theTitle.text forKey:@"title"];
    [request addPostValue:theContent.text forKey:@"content"];
    [request addPostValue:lat forKey:@"lat"];
    [request addPostValue:lon forKey:@"lng"];
    [request addPostValue:@"richardTest" forKey:@"username"];
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@", request.responseString);
        
        NSString *test = request.responseString;
        
        NSDictionary *deserializedData = [test objectFromJSONString];
        NSLog(@"%@", [deserializedData description]);
        
        // Iterate through each post in the array
     //   for (NSDictionary * dataDict in deserializedData) {
            // Extract the Post ID # from this post
       //     NSString * postTitle = [dataDict objectForKey:@"result"];
         //   NSLog(@"%@", postTitle);
            
            // Extract ..... everything else
        //}        
        
    }];
    
    [request setFailedBlock:^{
        
        NSLog(@"%@", request.error);
    }];
    
    [request startAsynchronous];    

}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	lat = @"";
    lon = @"";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    
    lat = [[NSString stringWithFormat: @"%f", loc.latitude] retain];
    lon = [[NSString stringWithFormat: @"%f", loc.longitude] retain];
}


/*

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [picker release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Scale the image
  
        theImage.image = [[info objectForKey:UIImagePickerControllerOriginalImage] scaleToSize:CGSizeMake(150.0f, 200.0f)];
    
    //release picker
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [picker release];
    
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
