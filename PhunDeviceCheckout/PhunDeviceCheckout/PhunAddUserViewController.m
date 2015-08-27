//
//  PhunAddUserViewController.m
//  PhunDeviceCheckout
//
//  Created by John Bennedict Lorenzo on 1/28/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PhunAddUserViewController.h"
#import "phundevicecheckoutManager.h"
static NSString *const kAddUserURL = @"https://docs.google.com/forms/d/14IvghWAPQYkq6_5yv4qRex6l95wkbyuRg_bSrpi9SaM/formResponse";

@interface PhunAddUserViewController ()
{
    IBOutlet UITextField *_firstNameField;
    IBOutlet UITextField *_lastNameField;
    IBOutlet UITextField *_emailField;
}
@end

@implementation PhunAddUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _emailField.text = self.username;
}

#pragma mark - IBOutlet

- (IBAction)submit:(id)sender
{
    if( [_lastNameField.text length] <= 0 ||
       [_firstNameField.text length] <= 0 ||
       [_emailField.text length] <= 0
       ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"All fields are required"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    
        return;
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAddUserURL]];
    [request setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[self composePostBody] dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSLog(@"%@", response);
        NSLog(@"%@", connectionError);
        
        NSString *message = @"Successfully added a new user";
        
        BOOL failure = !data || connectionError;
        
        if (failure) {
            message = @"Failed to add user";
        } else {
            [[phundevicecheckoutManager sharedManager] addOfflineUser:_emailField.text];
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add User"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (NSString *)email
{
    return _emailField.text;//stringByAppendingString:@"@phunware.com"];
}

#pragma mark - Private

- (NSString *)composePostBody
{
    return [[NSString stringWithFormat:@""
            "entry.239238482=%@&"
            "entry.1798917776=%@&"
            "entry.1668396708=%@&"
            "draftResponse=&"
            "pageHistory=0",
            _firstNameField.text,
            _lastNameField.text,
            self.email] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
