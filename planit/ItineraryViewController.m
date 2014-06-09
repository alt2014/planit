//
//  ItineraryViewController.m
//  planit
//
//  Created by Anh Truong on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "ItineraryItemTableCell.h"
#import "ItineraryHeaderTableCell.h"
#import "ItineraryViewController.h"
#import "SWRevealViewController.h"
#import "PIEvent.h"
#import "PIDay.h"
#import "ItineraryEditViewController.h"
#import "POIViewController.h"
#import "TransportationViewController.h"
#import "DataManager.h"
#import "PITransportation.h"
#import "PITrip+Model.h"
#import "PITrip.h"
#import "PIDay+Model.h"

#define eventCellHeight 82;
#define headerCellHeight 27;

@interface ItineraryViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *itineraryEvents;

@end

@implementation ItineraryViewController
static NSString *itineraryEditSegueID = @"itineraryEditSegue";
static NSString *poiDetailSegueID = @"pOIDetailSegue";
static NSString *transportationDetailSegueID = @"transportationDetailSegue";

//should pass in the trip name when the edit button is clicked
//pass in the event when the event is clicked

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
    if (!expandedSections) //alloc expanded sections
        expandedSections = [[NSMutableIndexSet alloc] init];
    [self createDateFormatter];
    
   // [self initTripDetails];
    
    // set the side bar button action and gesture recognizer
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper functions

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    
    [self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [self.timeFormatter setDateStyle:NSDateFormatterNoStyle];
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0){
        
        //hardcoded, change to adapt to more events
        NSString *CellIdentifier = @"POI";
        return [self eventCellForIndexPath:indexPath cellIdentifier:CellIdentifier];
        
    }
    return [self headerCellForSection:indexPath.section];
}

- (UITableViewCell *)eventCellForIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString *)cellIdentifier
{
    PIEvent *cellData = [[[[self.trip getDaysArray] objectAtIndex:indexPath.section] getEventsArray] objectAtIndex:indexPath.row - 1];
    
    ItineraryItemTableCell *cell = (ItineraryItemTableCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ItineraryItemTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.AddressTextField.text = cellData.addr;
    //insert time formatter
    NSString *startTime = [self.timeFormatter stringFromDate:cellData.start];
    NSString *endTime = [self.timeFormatter stringFromDate:cellData.end];
    NSMutableString *timeStr = [NSMutableString new];
    [timeStr appendString:startTime];
    [timeStr appendString:@" - "];
    [timeStr appendString:endTime];
    
    cell.TimeLabel.text = timeStr;
    cell.NameLabel.text = cellData.name;
    return cell;
    
}

- (UITableViewCell *)headerCellForSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"HeaderCell";
    ItineraryHeaderTableCell *cell = (ItineraryHeaderTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ItineraryHeaderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDate *headerDate = [[[self.trip getDaysArray] objectAtIndex:section] date];
    cell.DateLabel.text = [self.dateFormatter stringFromDate: headerDate];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.trip getDaysArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([expandedSections containsIndex:section]) {
        PIDay *day = [[self.trip getDaysArray] objectAtIndex:section];
        return [[day getEventsArray] count] + 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        return eventCellHeight;
    }
    else
        return headerCellHeight;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row)
    {
        // only first row toggles exapand/collapse
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSInteger section = indexPath.section;
        BOOL currentlyExpanded = [expandedSections containsIndex:section];
        NSInteger rows;
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        if (currentlyExpanded)
        {
            rows = [self tableView:tableView numberOfRowsInSection:section];
            [expandedSections removeIndex:section];
        }
        else
        {
            [expandedSections addIndex:section];
            rows = [self tableView:tableView numberOfRowsInSection:section];
        }
        
        for (int i=1; i<rows; i++)
        {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                           inSection:section];
            [tmpArray addObject:tmpIndexPath];
        }
                
        if (currentlyExpanded)
            [tableView deleteRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
        
        else
            [tableView insertRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void) updateTableView {
    [self.tableView reloadData];
}
#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:itineraryEditSegueID]){
        
        ItineraryEditViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.trip = self.trip;
        controller.dateFormatter = self.dateFormatter;
        controller.timeFormatter = self.timeFormatter;
        controller.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:poiDetailSegueID]) {
        POIViewController *controller = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        PIEvent *selectedEvent = [[[[self.trip getDaysArray] objectAtIndex:selectedIndexPath.section] getEventsArray] objectAtIndex:selectedIndexPath.row - 1];
        controller.event = selectedEvent;
        controller.timeFormatter = self.timeFormatter;
        controller.dateFormatter = self.dateFormatter;
        //add an event to the controller
    }
    if ([[segue identifier] isEqualToString:transportationDetailSegueID]) {
        TransportationViewController *controller = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        PITransportation *selectedEvent = [[[[self.trip getDaysArray] objectAtIndex:selectedIndexPath.section] getEventsArray] objectAtIndex:selectedIndexPath.row - 1];
        controller.event = selectedEvent;
    }
    /*
    if ([[segue identifier] isEqualToString:tripDetailSegueID]){
        
        ItineraryViewController *controller = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Trip *selectedTrip = [self.trips objectAtIndex:selectedIndexPath.row];
        controller.daysInTrip = [selectedTrip getDays];
        
        controller.navigationItem.title = selectedTrip.name;
    }
     */
}

@end
