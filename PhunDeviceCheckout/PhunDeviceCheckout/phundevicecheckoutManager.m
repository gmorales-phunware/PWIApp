//
//  phundevicecheckoutManager.m
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/14/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "phundevicecheckoutManager.h"
#import "phunDevice.h"

@implementation phundevicecheckoutManager

@synthesize arrayUsers = _arrayUsers;
@synthesize currentUserName = _currentUserName;
@synthesize dictionaryUsers = _dictionaryUsers;
@synthesize dictionaryDevices = _dictionaryDevices;

#define FILENAME_DEVICE @"devicelist"
#define FILENAME_USERS @"userlist"

+(phundevicecheckoutManager *)sharedManager {
    static dispatch_once_t pred;
    static phundevicecheckoutManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[phundevicecheckoutManager alloc] init];
    });
    return shared;
}

- (id)init {
    if( self = [super init]) {
    
        _arrayUsers = [NSMutableArray arrayWithObjects:@"Brad Chinn", @"Cef Ramirez", @"Chad Difuntorum",nil];
        _dictionaryDevices = [[NSMutableDictionary alloc] init];
        _dictionaryUsers = [[NSMutableDictionary alloc] init];
        
        _currentUserName = @"";
        

        [self initOfflineUsers];
    }
    return self;
}

- (void) initOfflineUsers {
    NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    if ([fetchDefaults objectForKey:@"kOfflineUsers"] != nil) {
        arrayOfflineUsers = [NSMutableArray arrayWithArray:[fetchDefaults objectForKey:@"kOfflineUsers"]];
    } else {
        arrayOfflineUsers = [[NSMutableArray alloc] init];
    }
    
    //Sync! Remove offline users that are already added to online array
    NSMutableArray *toberemoved = [NSMutableArray arrayWithObjects:nil];
    
    for (NSString *user in arrayOfflineUsers) {
        if( [_arrayUsers containsObject:user] ) {
            [toberemoved addObject:user];
        }
    }
    
    for (NSString *user in toberemoved) {
        [arrayOfflineUsers removeObject:user];
    }
    
    [self saveOfflineUsers];
    
    for (NSString *user in arrayOfflineUsers) {
        if( [user length] > 0 ) {
            
            NSString *firstLetter = [[user substringToIndex:1] uppercaseString];
            
            [_dictionaryUsers[firstLetter] addObject:user];
            [_arrayUsers addObject:user];
        }
    }
    
    NSArray *alphabetArray = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                              componentsSeparatedByString:@" "];
    [_arrayUsers sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *s in alphabetArray) {
        
        [_dictionaryUsers[s] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
}

- (void)saveOfflineUsers {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[arrayOfflineUsers copy] forKey:@"kOfflineUsers"];
    [defaults synchronize];
}

- (void)addOfflineUser: (NSString *) newUser {
    
    [arrayOfflineUsers addObject:newUser];
    
    if( [newUser length] > 0 ) {
        
        NSString *firstLetter = [[newUser substringToIndex:1] uppercaseString];
        
        [_dictionaryUsers[firstLetter] addObject:newUser];
        [_dictionaryUsers[firstLetter] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        [_arrayUsers addObject:newUser];
    }
    
    [self saveOfflineUsers];
}

- (void)removeOfflineUser: (NSString *) user {
    [arrayOfflineUsers removeObject:user];
    
    [self saveOfflineUsers];

}

- (void) fetchAllData {
    [self fetchDevicelist];
    [self fetchUserList];
}


- (void) setUserWithIndex:(NSInteger)index {
    _currentUserName = _arrayUsers[index];
}

- (void) fetchUserList {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://docs.google.com/spreadsheet/pub?key=0ArC3-g8AQAohdG50UFI4UE0xT085MjJLRmdFaGFCamc&single=true&gid=0&output=csv"]];

    
    [self processUserList:[self loadDataFromFileName:FILENAME_USERS]];
    [self initOfflineUsers];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [self saveData:data toFileName:FILENAME_USERS];
//        NSLog(@"%@", response);
//        NSLog(@"%@", connectionError);

        //[self processDeviceList:csvData];
        [self processUserList:data];
        [self initOfflineUsers];
        
    }];
    
    
}

- (void) processUserList : (NSData *) data {
    
    if( data == nil ) return;
    
    NSString *csvData = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    NSLog(@"%@",csvData);
    
    [_arrayUsers removeAllObjects];
    
    [_dictionaryUsers removeAllObjects];
    
    NSArray *alphabetArray = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                     componentsSeparatedByString:@" "];
    for (NSString *s in alphabetArray) {

        [_dictionaryUsers setValue:[NSMutableArray arrayWithObjects:nil] forKey:s];
    }
    
    NSArray *userlist = [csvData componentsSeparatedByString:@"\n"];
    
    for (NSString *user in userlist) {

        //INPUT: google group username
        
        if( [user length] > 0 ) {
            
            NSString *firstLetter = [[user substringToIndex:1] uppercaseString];
            
            [_dictionaryUsers[firstLetter] addObject:user];
            [_arrayUsers addObject:user];
        }
        
    }
    
    //Sort alphabetically
    [_arrayUsers sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *s in alphabetArray) {
        
        [_dictionaryUsers[s] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
}



- (void) fetchDevicelist {
#ifdef GOOGLEDOC_PRODUCTION
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://docs.google.com/spreadsheet/pub?key=0AiegtCaoCRV6dEdYMnVtRVYycUMyOWF3U0EzdG5NaEE&single=true&gid=0&output=csv"]];
#else
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://docs.google.com/spreadsheet/pub?key=0AquKuarSkwFpdDk0bjdIc3VGdF94Tmw5QjZvZlREdlE&single=true&gid=0&output=csv"]];
#endif

    [self processDeviceList:[self loadDataFromFileName:FILENAME_DEVICE]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //NSLog(@"%@", response);
        //NSLog(@"%@", connectionError);
        
        [self saveData:data toFileName:FILENAME_DEVICE];
        [self processDeviceList:data];
        
    }];
}

- (void) saveData: (NSData *)data toFileName: (NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *fullfilename = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [data writeToFile:fullfilename atomically:YES];
}

- (NSData *)loadDataFromFileName: (NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *fullfilename = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSData *retVal = [[NSData alloc] initWithContentsOfFile:fullfilename];
    return retVal;
}


#define indexBarcode 2
#define indexManufacturer 0
#define indexModel 1
#define indexFirmware 3
#define indexPlatform 4
#define indexCarrier 5
#define indexSerial 10
#define indexLocation 7

typedef NS_ENUM(NSUInteger, PhunDeviceAttribute) {
    PhunDeviceAttributeManufacturer,
    PhunDeviceAttributeModel,
    PhunDeviceAttributeBarcode,
    PhunDeviceAttributeFirmware,
    PhunDeviceAttributePlatform,
    PhunDeviceAttributeCarrier,
    PhunDeviceAttributePhoneNumber,
    PhunDeviceAttributeLocation,
    PhunDeviceAttributeAssignee,
    PhunDeviceAttributeAcquiredDate,
    PhunDeviceAttributeSerial,
    PhunDeviceAttributeUDID,
    PhunDeviceAttributeAccessories,
    PhunDeviceAttributeDeviceName,
    PhunDeviceAttributeInventoryCheck,
    PhunDeviceAttributeLastUser,
    PhunDeviceAttributeTimestamp,
    PhunDeviceAttributeStatus
};

- (void) processDeviceList : (NSData *) data {
    
    if( data == nil ) return;
    
    NSString *csvData = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    NSLog(@"%@",csvData);
    
    [_dictionaryDevices removeAllObjects];
    
    NSArray *perPhoneData = [csvData componentsSeparatedByString:@"\n"];
    
    for (int i = 1; i < [perPhoneData count]; i++) {
        NSString *phone = perPhoneData[i];
        NSArray *phoneAttributes = [phone componentsSeparatedByString:@","];
        
        if( [phoneAttributes count] < 3 ) {
            continue;
        }
        
        if( ![phoneAttributes[2] isEqualToString:@""] ) {

            phunDevice *d = [[phunDevice alloc] init];
            d.manufacturer = phoneAttributes[PhunDeviceAttributeManufacturer];
            d.model = phoneAttributes[PhunDeviceAttributeModel];
            d.firmware = phoneAttributes[PhunDeviceAttributeFirmware];
            d.platform = phoneAttributes[PhunDeviceAttributePlatform];
            
            d.barcode = phoneAttributes[PhunDeviceAttributeBarcode];
            
            d.carrier = phoneAttributes[PhunDeviceAttributeCarrier];
            d.location = phoneAttributes[PhunDeviceAttributeLocation];

            _dictionaryDevices[d.barcode] = d;
        }
    }
    
}

- (phunDevice *)getSelectedDevice {
    return _dictionaryDevices[selectedDevice];
}

- (phunDevice *)getRandomDevice {
    int randomIndex = arc4random() % [_dictionaryDevices count];
    
    selectedDevice = [_dictionaryDevices allKeys][randomIndex];;
    
    return [_dictionaryDevices allValues][randomIndex];
}

- (BOOL) isBarcodeInDatabase: (NSString *) barcode {
    return [[_dictionaryDevices allKeys] containsObject:barcode];
}

- (phunDevice *)setSelectedDeviceWithBarcode:(NSString *)barcode {
    selectedDevice = barcode;
    
    return [self getSelectedDevice];
}

@end

