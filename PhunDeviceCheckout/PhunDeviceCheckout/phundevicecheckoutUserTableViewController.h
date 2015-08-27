//
//  phundevicecheckoutUserTableViewController.h
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/14/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface phundevicecheckoutUserTableViewController : UITableViewController <UITableViewDataSource, UITableViewDataSource> {
    NSArray *searchResults;
    
    NSArray *alphabetArray;
}

@property (strong, nonatomic) IBOutlet UITableView *userTable;

@end
