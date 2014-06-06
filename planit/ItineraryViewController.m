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
#import "Event.h"
#import "Day.h"
#import "ItineraryEditViewController.h"
#import "POIViewController.h"

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

- (void)initTripDetails {
    if (!self.itineraryEvents) {
        self.itineraryEvents = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.daysInTrip count]; i++) {
            NSMutableArray *dayDataArr = [[NSMutableArray alloc] init];
            Day *currDay = self.daysInTrip[i];
            [dayDataArr addObject:[self.dateFormatter stringFromDate:currDay.date]];
            NSArray *dayEvents = [currDay getEvents];
            for (int e = 0; e < [dayEvents count]; e++) {
                Event *currEvent = dayEvents[e];
                [dayDataArr addObject:currEvent];
            }
            //this can get real messy, real fast, have to save back to this
            [self.itineraryEvents addObject:dayDataArr];
        }
        
    }
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
    Event *cellData = [[[self.daysInTrip objectAtIndex:indexPath.section] getEvents] objectAtIndex:indexPath.row];
    ItineraryItemTableCell *cell = (ItineraryItemTableCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ItineraryItemTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.AddressTextField.text = cellData.addr.asString;
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
    NSDate *headerDate = [[self.daysInTrip objectAtIndex:section] date];
    cell.DateLabel.text = [self.dateFormatter stringFromDate: headerDate];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.daysInTrip count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([expandedSections containsIndex:section]) {
        return [[self.daysInTrip[section] getEvents] count] + 1;
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

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:itineraryEditSegueID]){
        
        ItineraryEditViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.itineraryEvents = self.itineraryEvents;
        controller.listOfDays = self.daysInTrip;
        controller.dateFormatter = self.dateFormatter;
        controller.timeFormatter = self.timeFormatter;
    }
    
    if ([[segue identifier] isEqualToString:poiDetailSegueID]) {
        POIViewController *controller = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Event *selectedEvent = [[self.itineraryEvents objectAtIndex:selectedIndexPath.section] objectAtIndex:selectedIndexPath.row];
        controller.event = selectedEvent;
        controller.timeFormatter = self.timeFormatter;
        controller.dateFormatter = self.dateFormatter;
        //add an event to the controller
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
