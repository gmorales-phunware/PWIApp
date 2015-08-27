//
//  phundevicecheckoutBarcodeScannerViewController.m
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/13/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "phundevicecheckoutBarcodeScannerViewController.h"
#import "phundevicecheckoutManager.h"
@interface phundevicecheckoutBarcodeScannerViewController ()

@end

@implementation phundevicecheckoutBarcodeScannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self showBarcodeScanner];
    [self initCameraView];
    
    if( [UIScreen mainScreen].bounds.size.height <= 480 ) { //adjust according to height
        CGRect frame = sendButton.frame;
        frame.origin.y -= 88;
        sendButton.frame = frame;
        
        frame = cancelButton.frame;
        frame.origin.y -= 88;
        cancelButton.frame = frame;
    }

    
    
}


- (void) showBarcodeScanner {
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) cancelButtonClicked:(id)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)sendButtonClicked:(id)sender {
    if( [sendButton.titleLabel.text isEqualToString:@"Retry"] ) {
        //[self showBarcodeScanner];
        [self showCameraView:YES];
    } else if ( [sendButton.titleLabel.text isEqualToString:@""] ) {
        
    } else {
        [self postToForm];
        sendButton.enabled = NO;
        cancelButton.enabled = NO;
        
        
        UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [iv startAnimating];
        [sendButton addSubview: iv];
    }
}


- (void) showCameraView: (BOOL) show {
    
    if(show) {
        [cameraView start];
        
        [scannerView sendSubviewToBack:cameraView];
        
        [scannerView setHidden:NO];
        
        [sendButton setEnabled:NO];
        sendButton.titleLabel.text = @"";
        
    } else {
        [cameraView stop];
        [scannerView setHidden:YES];
        
        [sendButton setEnabled:YES];
    }
    
//    [cameraView stop];
//    [scannerView setHidden:YES];
//    [self showBarcodeScanner];
    
}

- (void)initCameraView {
    if(cameraView == nil)
    {
        cameraView = [ZBarReaderView new];
        
        cameraView.readerDelegate = self;
        cameraView.tracksSymbols = NO;
        //cameraView.torchMode = AVCaptureTorchModeOff;
        //[cameraView addSubview:cameraOverlayView];
    }
    
    [scannerView addSubview:cameraView];
    scannerView.clipsToBounds = YES;
    
    [self showCameraView:YES];
}


#define ALERT_SUCCESS 23
#define ALERT_FAIL 24

- (void) postToForm {

#ifdef GOOGLEDOC_PRODUCTION
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://docs.google.com/a/phunware.com/forms/d/1bwIOLB8Pjj-zs5YE0hsF_uyFmWeRtAqFA_yOEzeN9D4/formResponse"]];
#else
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://docs.google.com/forms/d/1uEJ4HYUJRBBzxhfiJxmqZpm45vXxrpKIRuCslukZXzs/formResponse"]];
#endif
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPMethod:@"POST"];

    phundevicecheckoutManager *deviceMgr = [phundevicecheckoutManager sharedManager];
    phunDevice *device = [deviceMgr getSelectedDevice];
    
    NSString *action = deviceMgr.isTransactionCheckin ? @"IN" : @"OUT";
    NSString *location = [deviceMgr getSelectedDevice].location;
    NSString *deviceName = [device getDeviceName];//device.barcode;
    NSString *userName = deviceMgr.currentUserName;
    
    
#ifdef GOOGLEDOC_PRODUCTION
    NSString *postParams = [NSString stringWithFormat:@"entry.395502074=%@&entry.149538163=%@&entry.858997898=%@&entry.80421773=%@&entry.2011418295=%@&draftResponse=&pageHistory=0",action,location,deviceName,userName,device.barcode];
#else
    NSString *postParams = [NSString stringWithFormat:@"entry.72013995=%@&entry.912294983=%@&entry.445349597=%@&entry.1590532982=%@&draftResponse=[,,\"8929836201243606926\"]&pageHistory=0&fbzx=-8929836201243606926",action,location,deviceName,userName];
#endif

    
    NSData *postData = [[postParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"response: %@", response);
        NSLog(@"response data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"error: %@", connectionError);
        
        if( connectionError == nil) {
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"" message:[phundevicecheckoutManager sharedManager].isTransactionCheckin ? @"Check In Successful!" : @"Check Out Successful!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            a.tag = ALERT_SUCCESS;
            [a show];
        } else {
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Try Again" message:[phundevicecheckoutManager sharedManager].isTransactionCheckin ? @"Check In Failed." : @"Check Out Failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            a.tag = ALERT_SUCCESS;
            [a show];
        }
    }
     ];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if( alertView.tag == ALERT_SUCCESS )
        [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ZBarReaderViewDelegate
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    [cameraView stop];
    
    ZBarSymbol *symbol = nil;
    for(symbol in symbols)
        // EXAMPLE: just grab the first barcode
        break;
    
    BOOL randomdevice = NO;//paulo: for testing, I don't have no barcodes
    
    NSString *barcode = randomdevice ? [[phundevicecheckoutManager sharedManager] getRandomDevice].barcode : symbol.data;
    

    [self showCameraView:NO];
    
    if ( [[phundevicecheckoutManager sharedManager] isBarcodeInDatabase:barcode] ) {
        
        phunDevice *d = [[phundevicecheckoutManager sharedManager] setSelectedDeviceWithBarcode:barcode];
        scantextview.text = [NSString stringWithFormat:@"Username: %@\n\nDevice: %@ %@\nPlatform/Firmware: %@ %@\n\nCarrier: %@\nLocation: %@", [phundevicecheckoutManager sharedManager].currentUserName , d.manufacturer, d.model, d.platform, d.firmware, d.carrier, d.location ];
        
        if( [phundevicecheckoutManager sharedManager].isTransactionCheckin )
            [sendButton setTitle:@"Check In" forState:UIControlStateNormal];
        else [sendButton setTitle:@"Check Out" forState:UIControlStateNormal];
    } else {
        scantextview.text =  [NSString stringWithFormat:@"%@\n\nThis Barcode is not in the database, tap retry to scan another item", symbol.data];
        
        [sendButton setTitle:@"Retry" forState:UIControlStateNormal];
    }
    
    
}

//old method
//- (void) imagePickerController: (UIImagePickerController*) reader
// didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    // ADD: get the decode results
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        // EXAMPLE: just grab the first barcode
//        break;
//    
//    BOOL randomdevice = NO;//paulo: for testing, I don't have no barcodes
//    
//    NSString *barcode = randomdevice ? [[phundevicecheckoutManager sharedManager] getRandomDevice].barcode : symbol.data;
//    
//    if ( [[phundevicecheckoutManager sharedManager] isBarcodeInDatabase:barcode] ) {
//        
//        phunDevice *d = [[phundevicecheckoutManager sharedManager] setSelectedDeviceWithBarcode:barcode];
//        scantextview.text = [NSString stringWithFormat:@"Username: %@\n\nDevice: %@ %@\nPlatform/Firmware: %@ %@\n\nCarrier: %@\nLocation: %@", [phundevicecheckoutManager sharedManager].currentUserName , d.manufacturer, d.model, d.platform, d.firmware, d.carrier, d.location ];
//        
//        if( [phundevicecheckoutManager sharedManager].isTransactionCheckin )
//            [sendButton setTitle:@"Check In" forState:UIControlStateNormal];
//        else [sendButton setTitle:@"Check Out" forState:UIControlStateNormal];
//    } else {
//        scantextview.text =  [NSString stringWithFormat:@"%@\n\nThis Barcode is not in the database, tap retry to scan another item", symbol.data];
//        
//        [sendButton setTitle:@"Retry" forState:UIControlStateNormal];
//    }
//    
//    // ADD: dismiss the controller (NB dismiss from the *reader*!)
//    [reader dismissViewControllerAnimated:YES completion:nil];
//}

@end
