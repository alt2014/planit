//
//  TripViewController.m
//  planit
//
//  Created by Anh Truong on 5/11/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "TripViewController.h"
#import "TripAddViewController.h"
#import "TripTableViewCell.h"
#import "ItineraryViewController.h"
#import "DataManager.h"
#import "PITrip+Model.h"
#import "GeoLocation.h"

static NSString *tripCellID = @"TripCell";
static NSString *addTripSegueID = @"addTrip";
static NSString *tripDetailSegueID = @"itineraryDetailView";
const int dPTag = 1;

@interface TripViewController ()
@property (strong, nonatomic) NSMutableArray *trips;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end


@implementation TripViewController

- (NSMutableArray*)trips {
    if (!_trips) {
        _trips = [[NSMutableArray alloc] init];
    }
    return _trips;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDateFormatter];
    
    DataManager *dm = [[DataManager alloc] init];
    
    [dm loadTrips:^(BOOL success, NSArray *trips) {
        if (success) {
            // document created/loaded safely
            self.trips = [NSMutableArray arrayWithArray:trips];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error");
        }
    }];
    
}

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = [self.trips count];
    return numRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripTableViewCell *cell;
    
    static NSString *cellIdentifier = @"TripCell";
    
    PITrip* trip = self.trips[indexPath.row];
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TripTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.tripNameLabel.text = trip.name;
    cell.tripStartLabel.text = [self.dateFormatter stringFromDate:trip.start];
    cell.tripEndLabel.text = [self.dateFormatter stringFromDate:trip.end];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
#pragma mark - delegate methods

- (void)updateTableDataSource {
    DataManager *dm = [[DataManager alloc] init];
    self.trips = [NSMutableArray arrayWithArray:[dm getTrips]];
    [self.tableView reloadData];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:addTripSegueID]){
        
        TripAddViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        
        controller.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:tripDetailSegueID]){
        
        ItineraryViewController *controller = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        PITrip *selectedTrip = [self.trips objectAtIndex:selectedIndexPath.row];
        controller.trip = selectedTrip;
                
        controller.navigationItem.title = selectedTrip.name;
    }
}

@end
