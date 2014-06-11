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
#import "PITransportation.h"
#import "PILodging.h"
#import "PIDay.h"
#import "POIViewController.h"
#import "POIEditViewController.h"
#import "TransportationViewController.h"
#import "TransportationEditViewController.h"
#import "LodgingViewController.h"
#import "DataManager.h"
#import "PITrip+Model.h"
#import "PITrip.h"
#import "PIDay+Model.h"
#import "PILodging.h"
#import "PITransportation+Model.h"
#import "PILodging+Model.h"
#import "DTCustomColoredAccessory.h"

#define eventCellHeight 82;
#define headerCellHeight 30;

@interface ItineraryViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ItineraryViewController
static NSString *itineraryEditSegueID = @"itineraryEditSegue";
static NSString *poiDetailSegueID = @"pOIDetailSegue";
static NSString *transportationDetailSegueID = @"transportationDetailSegue";
static NSString *lodgingDetailSegueID = @"lodgingDetailSegue";
static NSString *addPOISegueID = @"addPOISegue";
static NSString *editPOISegueID = @"editPOISegue";
static NSString *addTransportationSegueID = @"addTransportSegue";
static NSString *editTransportationSegueID = @"editTransportationSegue";
static NSString *addLodgingSegueID = @"addLodgingSegue";
static NSString *editLodgingSegueID = @"editLodgingSegue";

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
    if (!expandedSections) {//alloc expanded sections
        expandedSections = [[NSMutableIndexSet alloc] init];
        int i = [self isCurrentDay];
        if (i != -1) {
            [expandedSections addIndex:i];
        }
    }
    [self createDateFormatter];
    
    // [self initTripDetails];
    
    // set the side bar button action and gesture recognizer
    if (sidebarButton) {
        sidebarButton.target = self.revealViewController;
        sidebarButton.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    } else {
        self.title = [NSString stringWithFormat:@"Edit Trip: %@", self.trip.name];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)isCurrentDay
{
    NSInteger numDays = [[self.trip getDaysArray] count];
    for (NSInteger i = 0; i < numDays; i++) {
        NSDate *date = ((PIDay*)[[self.trip getDaysArray] objectAtIndex:i]).date;
        NSDate *now = [NSDate date];
        if ([self timelessCompare:date date2:now]== NSOrderedSame) {
            return i;
            
        }
    }
    return -1;
}

#pragma mark - date comparison
- (NSComparisonResult)timelessCompare:(NSDate *)date1 date2:(NSDate *)date2
{
    NSDate *dt1 = [self dateByZeroingOutTimeComponents:date1];
    NSDate *dt2 = [self dateByZeroingOutTimeComponents:date2];
    return [dt1 compare:dt2];
}

- (NSDate *)dateByZeroingOutTimeComponents:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:date];
    [self zeroOutTimeComponents:&components];
    return [calendar dateFromComponents:components];
}

- (void)zeroOutTimeComponents:(NSDateComponents **)components
{
    [*components setHour:0];
    [*components setMinute:0];
    [*components setSecond:0];
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
        NSString *CellIdentifier;
        PIEvent * selectedEvent = [[[[self.trip getDaysArray] objectAtIndex:indexPath.section] getEventsArray] objectAtIndex:indexPath.row - 1];
        if ([selectedEvent isKindOfClass:[PITransportation class]]) {
            CellIdentifier = @"Transport";
        } else if ([selectedEvent isKindOfClass:[PILodging class]]){
            CellIdentifier = @"Lodging";
        } else {
            CellIdentifier = @"POI";
        }
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
    if ([cellData isKindOfClass:[PITransportation class]]) {
        cell.AddressTextField.text = @"";
    } else {
        cell.AddressTextField.text = cellData.addr;
    }
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *date = [dateFormatter stringFromDate:headerDate];
    cell.DateLabel.text = date;
    if ([expandedSections containsIndex:section])
    {
        cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
    }
    else
    {
        cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
    }
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
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (currentlyExpanded) {
            [tableView deleteRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
            cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
        } else {
            [tableView insertRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
            cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];

        }
    }
}

-(void) updateTableView {
    [self.tableView reloadData];
}
#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:itineraryEditSegueID]){
        
        ItineraryViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.trip = self.trip;
        controller.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:poiDetailSegueID]) {
        POIViewController *controller = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PIEvent *selectedEvent = [[[[self.trip getDaysArray] objectAtIndex:indexPath.section] getEventsArray] objectAtIndex:indexPath.row - 1];;
        controller.event = selectedEvent;
        controller.timeFormatter = self.timeFormatter;
        controller.dateFormatter = self.dateFormatter;
        //add an event to the controller
    }
    
    if ([[segue identifier] isEqualToString:transportationDetailSegueID]) {
        TransportationViewController *controller = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PITransportation *selectedEvent = [[[[self.trip getDaysArray] objectAtIndex:indexPath.section] getEventsArray] objectAtIndex:indexPath.row - 1];;
        controller.event = selectedEvent;
        
        //add an event to the controller
    }
    
    if ([[segue identifier] isEqualToString:lodgingDetailSegueID]) {
        LodgingViewController *controller = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PILodging *selectedEvent = [[[[self.trip getDaysArray] objectAtIndex:indexPath.section] getEventsArray] objectAtIndex:indexPath.row - 1];;
        controller.event = selectedEvent;
        
        //add an event to the controller
    }
    
    if ([[segue identifier] isEqualToString:addPOISegueID] || [[segue identifier] isEqualToString:addTransportationSegueID] || [[segue identifier] isEqualToString:addLodgingSegueID]){
        
        POIEditViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.dateFormatter = self.dateFormatter;
        controller.timeFormatter = self.timeFormatter;
        controller.trip = self.trip;
        controller.delegate = self;
    }else if ([[segue identifier] isEqualToString:editPOISegueID] || [[segue identifier] isEqualToString:editTransportationSegueID] || [[segue identifier] isEqualToString:editLodgingSegueID]){
        
        POIEditViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.dateFormatter = self.dateFormatter;
        controller.timeFormatter = self.timeFormatter;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        PIEvent *selectedEvent = [[[[self.trip getDaysArray] objectAtIndex:selectedIndexPath.section] getEventsArray] objectAtIndex:selectedIndexPath.row - 1];
        controller.event = selectedEvent;
        controller.trip = self.trip;
        controller.delegate = self;
    }

}

- (IBAction)doneClicked:(UIBarButtonItem *)sender {
    [self.delegate updateTableView];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
