//
//  phundevicecheckoutDevicesTableViewController.m
//  PhunDeviceCheckout
//
//  Created by John Bennedict Lorenzo on 4/23/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "phundevicecheckoutDevicesTableViewController.h"
#import "phundevicecheckoutManager.h"

static NSString *const kNoContentMessage = @"No devices found.";

@interface phundevicecheckoutDevicesTableViewController ()
{
    NSArray *_searchResults;
    NSArray *_alphabetArray;

    NSArray *_alphabeticallySortedKeys;
}

@end

@implementation phundevicecheckoutDevicesTableViewController

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

//    _alphabetArray = [@"{search} A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
//                     componentsSeparatedByString:@" "];

    _alphabeticallySortedKeys = [[phundevicecheckoutManager sharedManager].dictionaryDevices keysSortedByValueUsingComparator:^NSComparisonResult(phunDevice *obj1, phunDevice *obj2) {

        return [[obj1 getDeviceName] compare:[obj2 getDeviceName]];

    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];

    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[self.searchDisplayController.searchBar scopeButtonTitles]];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSArray*)scope
{
    // TODO: fix
    NSDictionary *devices = [phundevicecheckoutManager sharedManager].dictionaryDevices;

    _searchResults = [[devices allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.description contains[cd] %@",searchText]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];

    return YES;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return 1;
//
//    }
//
//    return [_alphabetArray count];
//}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//        return nil;
//
//    return _alphabetArray;
//}

static const int NAVBAR_HEIGHT = 64;
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //The index (integer) of the current section that the user is touching
    if( index == 0) {
        [tableView setContentOffset:CGPointMake(0, -NAVBAR_HEIGHT) animated:NO];
        //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        return NSNotFound;
    }
    return index - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;

    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        count = [_searchResults count];

        if (count == 0)
            count = 1;
    } else {
        count =
        //[[[phundevicecheckoutManager sharedManager].dictionaryUsers objectForKey:_alphabetArray [section]] count];
        [_alphabeticallySortedKeys count];
    }

    return count;
}

#pragma mark - Table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";

    UITableViewCell *cell;

    NSDictionary *devices = [phundevicecheckoutManager sharedManager].dictionaryDevices;

    if (tableView == self.searchDisplayController.searchResultsTableView) {

        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (_searchResults.count == 0) {
            cell.textLabel.text = kNoContentMessage;
            cell.detailTextLabel.text = @"";
        } else {
            cell.textLabel.text = [_searchResults[indexPath.row] getDeviceName];
            cell.detailTextLabel.text = [_searchResults[indexPath.row] detail];
        }
    } else {

        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        NSDictionary *devices = [phundevicecheckoutManager sharedManager].dictionaryDevices;
        NSString *barcode = _alphabeticallySortedKeys[indexPath.row];

        cell.textLabel.text = [devices[barcode] getDeviceName];
        cell.detailTextLabel.text = [devices[barcode] detail];
    }

    cell.backgroundColor = [UIColor whiteColor];


    return cell;
    
}


@end
