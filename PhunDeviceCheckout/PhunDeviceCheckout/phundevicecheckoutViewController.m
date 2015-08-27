//
//  phundevicecheckoutViewController.m
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/13/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "phundevicecheckoutViewController.h"

#import "phundevicecheckoutManager.h"

@interface phundevicecheckoutViewController ()

@end

@implementation phundevicecheckoutViewController

@synthesize pickerView_officelocation = _pickerView_officelocation;
@synthesize labelUsername = _labelUsername;
@synthesize buttonLogin = _buttonLogin;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    arrayOfficeLocations = @[@"Austin",@"Newport Beach",@"San Diego"];
    
    [_pickerView_officelocation selectRow:1 inComponent:0 animated:NO];//set Newport beach as default;
    
    checkInColor = checkIn.backgroundColor;
    checkOutColor = checkOut.backgroundColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"devicecheckin"]) {
        [[phundevicecheckoutManager sharedManager] setIsTransactionCheckin:YES];
    }
    
    if ([[segue identifier] isEqualToString:@"devicecheckout"]) {
        [[phundevicecheckoutManager sharedManager] setIsTransactionCheckin:NO];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    if( [[phundevicecheckoutManager sharedManager].currentUserName length] == 0 ) {
        _labelUsername.text = @"Tap here to login";
        [_buttonLogin setTitle:@"" forState:UIControlStateNormal];
        
        [checkIn setEnabled:NO];
        [checkIn setBackgroundColor:[UIColor lightGrayColor]];
        [checkOut setEnabled:NO];
        [checkOut setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        _labelUsername.text = [phundevicecheckoutManager sharedManager].currentUserName;
        [_buttonLogin setTitle:@"not you?" forState:UIControlStateNormal];
        
        [checkIn setEnabled:YES];
        [checkIn setBackgroundColor:checkInColor];
        [checkOut setEnabled:YES];
        [checkOut setBackgroundColor:checkOutColor];
    }
    
//    if( [[phundevicecheckoutManager sharedManager].currentUserName length] == 0 ) {
//        [self performSegueWithIdentifier:@"userloginMain" sender:self];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [arrayOfficeLocations count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return arrayOfficeLocations[row];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
