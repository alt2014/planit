//
//  ItineraryEditViewController.m
//  planit
//
//  Created by Anh Truong on 5/19/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "ItineraryEditViewController.h"
#import "PIEvent.h"
#import "ItineraryItemTableCell.h"
#import "POIEditViewController.h"
#import "PIDay.h"
#import "PITrip+Model.h"
#import "PIDay+Model.h"
#import "ItineraryHeaderTableCell.h"
#import "TransportationEditViewController.h"
#import "PITransportation.h"
#import "PITransportation+Model.h"
#import "PILodging+Model.h"
#import "PILodging.h"

#define eventCellHeight 82;
#define headerCellHeight 27;

@interface ItineraryEditViewController ()
@end
static NSString *addPOISegueID = @"addPOISegue";
static NSString *editPOISegueID = @"editPOISegue";
static NSString *addTransportationSegueID = @"addTransportationSegue";
static NSString *editTransportationSegueID = @"editTransportationSegue";

@implementation ItineraryEditViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-TableView Data Source

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
    PIDay *day = [[self.trip getDaysArray] objectAtIndex:section];
    return [[day getEventsArray] count] + 1;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        return eventCellHeight;
    }
    else
        return headerCellHeight;
}

#pragma mark-Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - delegateMethods
- (void)updateTableView {
    [self.tableView reloadData];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:addPOISegueID] || [[segue identifier] isEqualToString:addTransportationSegueID]){
        
        POIEditViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.dateFormatter = self.dateFormatter;
        controller.timeFormatter = self.timeFormatter;
        controller.trip = self.trip;
        controller.delegate = self;
    }else if ([[segue identifier] isEqualToString:editPOISegueID] || [[segue identifier] isEqualToString:editTransportationSegueID]){
        
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
