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
#import "SWRevealViewController.h"

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
    if (self.revealViewController) {
        _sideBarButton.target = self.revealViewController;
        _sideBarButton.action = @selector(revealToggle:);
    } else {
        _sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.0f];

    }
    
    
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
    self.trips = [NSMutableArray arrayWithArray:[dm getTrips]];
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
