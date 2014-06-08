//
//  ItineraryViewController.m
//  planit
//
//  Created by Anh Truong on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "ItineraryItemTableCell.h"
#import "ItineraryViewController.h"
#import "SWRevealViewController.h"
#import "Event.h"
#import "Day.h"
#import "ItineraryEditViewController.h"

@interface ItineraryViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableArray *itineraryEvents;

@end

@implementation ItineraryViewController
static NSString *itineraryEditSegueID = @"itineraryEditSegue";

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
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    [self createDateFormatter];
    [self initTripDetails];
    sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - helper functions

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0){
        Event *cellData = [[self.itineraryEvents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        //hardcoded, change to adapt to more events
        NSString *CellIdentifier = [cellData valueForKey:@"POI"];
        ItineraryItemTableCell *cell = (ItineraryItemTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ItineraryItemTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.AddressLabel.text = cellData.addr.asString;
        //insert time formatter
        NSString *startTime = [self.dateFormatter stringFromDate:cellData.start];
        NSString *endTime = [self.dateFormatter stringFromDate:cellData.end];
        NSMutableString *timeStr = [NSMutableString new];
        [timeStr appendString:startTime];
        [timeStr appendString:@" - "];
        [timeStr appendString:endTime];
        
        cell.TimeLabel.text = timeStr;
        cell.NameLabel.text = cellData.name;
        return cell;
    }
    
    static NSString *CellIdentifier = @"HeaderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.itineraryEvents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections based on how many days there are
    return [self.itineraryEvents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([expandedSections containsIndex:section]) {
        return [[self.itineraryEvents objectAtIndex:section] count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        return 58.0f;
    }
    else
        return 27.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        {
            [tableView deleteRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
            
        }
        else
        {
            [tableView insertRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
            
        }
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:itineraryEditSegueID]){
        
        ItineraryEditViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.itineraryEvents = self.itineraryEvents;
        controller.delegate = self;
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
