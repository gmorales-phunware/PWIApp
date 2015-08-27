//
//  phundevicecheckoutViewController.h
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/13/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface phundevicecheckoutViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {

    NSArray *arrayOfficeLocations;
    
    IBOutlet UIButton *checkIn;
    IBOutlet UIButton *checkOut;
    
    UIColor *checkInColor;
    UIColor *checkOutColor;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView_officelocation;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

@end
