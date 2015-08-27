//
//  phundevicecheckoutUserTableViewController.m
//  PhunDeviceCheckout
//
//  Created by Paulo Dela Vina on 1/14/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "phundevicecheckoutUserTableViewController.h"

#import "phundevicecheckoutManager.h"
#import "PhunAddUserViewController.h"

static NSString *const kNoUsersMessage = @"Cant find your username? Tap Here";

@interface phundevicecheckoutUserTableViewController ()

@end

@implementation phundevicecheckoutUserTableViewController

@synthesize userTable = _userTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (IBAction)infoPressed:(id)sender {
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"" message:@"User data is fetched from \nhttp://bit.ly/phundeviceusers" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];

    [a show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    UIButton *infobutton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [infobutton addTarget:self action:@selector(infoPressed:) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infobutton];
    
    alphabetArray = [@"{search} A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                     componentsSeparatedByString:@" "];
}

- (void)viewWillAppear:(BOOL)animated {
    [_userTable reloadData];
    
    
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
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [[phundevicecheckoutManager sharedManager].arrayUsers filteredArrayUsingPredicate:resultPredicate];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
        
    } else
        return [alphabetArray count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) return nil;
    else
        return alphabetArray;
}

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
        count = [searchResults count];
        
        if (count == 0)
            count = 1;
    } else {
        count = [([phundevicecheckoutManager sharedManager].dictionaryUsers)[alphabetArray[section]] count];//[[phundevicecheckoutManager sharedManager].arrayUsers count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userCell";
    
    UITableViewCell *cell;
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (searchResults.count == 0)
            cell.textLabel.text = kNoUsersMessage;
        else
            cell.textLabel.text = searchResults[indexPath.row];

    } else {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSString *letter = alphabetArray[indexPath.section];
        cell.textLabel.text = ([phundevicecheckoutManager sharedManager].dictionaryUsers)[letter][indexPath.row];
        
    }
    
    cell.backgroundColor = [UIColor whiteColor];

    
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"create_user"])
    {
        PhunAddUserViewController *controller = segue.destinationViewController;
        controller.username = self.searchDisplayController.searchBar.text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (searchResults.count == 0) {
            [self performSegueWithIdentifier:@"create_user" sender:nil];
            return;
        }
        else
            [[phundevicecheckoutManager sharedManager] setCurrentUserName:searchResults[indexPath.row]];
    } else {
        
        NSString *letter = alphabetArray[indexPath.section];
//        if ([[[phundevicecheckoutManager sharedManager].dictionaryUsers objectForKey:letter] count] == 0) {
//            [self performSegueWithIdentifier:@"create_user" sender:nil];
//            return;
//        }
//        else
            [phundevicecheckoutManager sharedManager].currentUserName = ([phundevicecheckoutManager sharedManager].dictionaryUsers)[letter][indexPath.row];
        
        //[[phundevicecheckoutManager sharedManager] setCurrentUserName: [[phundevicecheckoutManager sharedManager].arrayUsers objectAtIndex:indexPath.row] ];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
