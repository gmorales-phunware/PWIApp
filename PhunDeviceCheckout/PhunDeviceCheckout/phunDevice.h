//
//  phunDevice.h
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/15/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface phunDevice : NSObject

@property (nonatomic,strong) NSString *manufacturer;
@property (nonatomic,strong) NSString *model;
@property (nonatomic,strong) NSString *firmware;

@property (nonatomic,strong) NSString *platform;
@property (nonatomic,strong) NSString *carrier;

@property (nonatomic,strong) NSString *serialNumber;
@property (nonatomic,strong) NSString *location;

@property (nonatomic, strong) NSString *barcode;

- (NSString *) getDeviceName;
- (NSString *) detail;

@end
