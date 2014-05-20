//
//  ItineraryViewController.m
//  planit
//
//  Created by Anh Truong on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "ItineraryItemTableCell.h"
#import "ItineraryViewController.h"

@interface ItineraryViewController ()

@end

@implementation ItineraryViewController

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
    NSDictionary *item1 = @{@"type" : @"POI",
                            @"title" : @"Child1"};
    NSDictionary *item2 = @{@"type" : @"Transport",
                            @"title" : @"Child2"};
    NSDictionary *item3 = @{@"type" : @"Lodging",
                            @"title" : @"Child3"};
    NSDictionary *item4 = @{@"type" : @"POI",
                            @"title" : @"Child4"};


    dummyData = @[@[@"header", item1, item2, item3], @[@"header2", item4]];
    [self.navigationItem setTitle:@"View Test"];
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0){
        NSDictionary *cellData = [[dummyData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString *CellIdentifier = [cellData valueForKey:@"type"];
        ItineraryItemTableCell *cell = (ItineraryItemTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[ItineraryItemTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.AddressLabel.text = @"1766 Santa Cruz Ave, Palo Alto, CA 94304";
        cell.TimeLabel.text = @"11:00PM - 12:00PM";
        cell.NameLabel.text = [cellData valueForKey:@"title"];
        return cell;
    }
    
    static NSString *CellIdentifier = @"HeaderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[dummyData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections based on how many days there are
    return [dummyData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([expandedSections containsIndex:section]) {
        return [[dummyData objectAtIndex:section] count];
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
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
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

@end
