//
//  phundevicecheckoutBarcodeScannerViewController.h
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/13/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

@interface phundevicecheckoutBarcodeScannerViewController : UIViewController <ZBarReaderDelegate, ZBarReaderViewDelegate, UIAlertViewDelegate> {
    IBOutlet UITextView *scantextview;
    
    IBOutlet UIButton *sendButton;
    IBOutlet UIButton *cancelButton;
    
    IBOutlet UIView *scannerView;
    
    ZBarReaderView *cameraView;
}


- (IBAction) sendButtonClicked :(id)sender;
- (IBAction) cancelButtonClicked :(id)sender;

- (void) initCameraView;

@end
