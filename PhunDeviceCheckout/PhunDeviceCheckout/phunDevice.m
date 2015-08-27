//
//  phunDevice.m
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/15/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "phunDevice.h"

@implementation phunDevice

@synthesize manufacturer = _manufacturer;
@synthesize model = _model;
@synthesize firmware = _firmware;
@synthesize platform = _platform;
@synthesize carrier = _carrier;
@synthesize serialNumber = _serialNumber;
@synthesize location = _location;

@synthesize barcode = _barcode;

- (NSString *)getDeviceName {
    return [NSString stringWithFormat:@"%@ %@", _manufacturer, _model];
}

- (NSString *)detail {
    return [NSString stringWithFormat:@"%@ %@ at %@", _platform, _firmware, _location];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@; %@;", _barcode, _manufacturer, _model, _platform, _firmware, _location];
}

@end
