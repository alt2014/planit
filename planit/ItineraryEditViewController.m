//
//  ItineraryEditViewController.m
//  planit
//
//  Created by Anh Truong on 5/19/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "ItineraryEditViewController.h"
#import "Event.h"
#import "ItineraryItemTableCell.h"
#import "POIEditViewController.h"
#import "Day.h"
#import "ItineraryHeaderTableCell.h"

#define eventCellHeight 82;
#define headerCellHeight 27;

@interface ItineraryEditViewController ()
@end
static NSString *addPOISegueID = @"addPOISegue";
static NSString *editPOISegueID = @"editPOISegue";

NSMutableIndexSet *expandedSections;
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
        
        //hardcoded, change to adapt to more events
        NSString *CellIdentifier = @"POI";
        return [self eventCellForIndexPath:indexPath cellIdentifier:CellIdentifier];
        
    }
    return [self headerCellForSection:indexPath.section];
}

- (UITableViewCell *)eventCellForIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString *)cellIdentifier
{
    Event *cellData = [[[self.listOfDays objectAtIndex:indexPath.section] getEvents] objectAtIndex:indexPath.row];
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
    NSDate *headerDate = [[self.listOfDays objectAtIndex:section] date];
    cell.DateLabel.text = [self.dateFormatter stringFromDate: headerDate];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.listOfDays count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listOfDays[section] getEvents] count] + 1;
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
- (void)saveEventDetails:(Event *)event isNewEvent:(BOOL)isNewEvent {
    if (isNewEvent) {
        for(int i = 0; i < [self.listOfDays count];  i++)
        {
            Day *day = self.listOfDays[i];
            NSDate *ddate = day.date;
            NSDate *eDate = event.when;
            NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:ddate];
            NSDateComponents *eventComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:eDate];
            
            if ([dayComponents month] == [eventComponents month] && [dayComponents day] == [eventComponents day] && [dayComponents year] == [eventComponents year]) {
                [day addEvent:event];
                //[self.itineraryEvents[i] addObject:event];
                NSArray *indexPaths = @[[NSIndexPath indexPathForRow:[[self.listOfDays[i] getEvents] count] inSection:i]];
                [self.tableView insertRowsAtIndexPaths:indexPaths
                      withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } else
        [self.tableView reloadData];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:addPOISegueID]){
        
        POIEditViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.dateFormatter = self.dateFormatter;
        controller.timeFormatter = self.timeFormatter;
        controller.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:editPOISegueID]){
        
        POIEditViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.dateFormatter = self.dateFormatter;
        controller.timeFormatter = self.timeFormatter;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Event *selectedEvent = [[self.itineraryEvents objectAtIndex:selectedIndexPath.section] objectAtIndex:selectedIndexPath.row];
        controller.event = selectedEvent;
        controller.delegate = self;
    }
}


- (IBAction)doneClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
