//
//  phundevicecheckoutManager.h
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/14/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "phunDevice.h"

#define GOOGLEDOC_PRODUCTION 1

@interface phundevicecheckoutManager : NSObject {

    NSString *selectedDevice;
    
    NSMutableArray *arrayOfflineUsers;
}

@property (nonatomic, strong) NSMutableDictionary *dictionaryUsers;
@property (nonatomic, strong) NSMutableArray *arrayUsers;
@property (nonatomic, strong) NSMutableDictionary *dictionaryDevices;

@property (nonatomic, strong) NSString *currentUserName;
@property (nonatomic) BOOL isTransactionCheckin;

+(phundevicecheckoutManager *)sharedManager;

-(void) setUserWithIndex: (NSInteger) index;

-(phunDevice *) getRandomDevice;
- (phunDevice *) getSelectedDevice;

- (phunDevice *) setSelectedDeviceWithBarcode: (NSString *) barcode;

- (BOOL) isBarcodeInDatabase: (NSString *) barcode;

- (void) fetchAllData;

- (void)addOfflineUser: (NSString *) newUser;

@end
