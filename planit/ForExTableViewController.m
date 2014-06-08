//
//  ForExTableViewController.m
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "ForExTableViewController.h"
#define numSections 2
#define fromCountryRow 1
#define fromPickerRow 2
#define toCountryRow 3
#define toPickerRow 4
#define firstSectionNumRows 5
#define secondSectionNumRows 1
#define pickerCellHeight 163
#define fromCellHeight 44
#define converterCellHeight 93
#define firstSectionCellHeight 68

@interface ForExTableViewController ()
@property (assign) BOOL fromPickerIsShowing;
@property (assign) BOOL toPickerIsShowing;
@property (strong, nonatomic) NSString *selectedFrom;
@property (strong, nonatomic) NSString *selectedTo;
@property (weak, nonatomic) IBOutlet UILabel *toCurrLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromCurrLabel;
@property (weak, nonatomic) IBOutlet UITextField *toAmountField;
@property (weak, nonatomic) IBOutlet UITextField *fromAmountField;
@property (weak, nonatomic) IBOutlet UILabel *fromCountryLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *fromPicker;
@property (weak, nonatomic) IBOutlet UILabel *toCountryLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *toPicker;

@end

@implementation ForExTableViewController

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
    [self hidePickerCell:@"from"];
    [self hidePickerCell:@"to"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    //return [self.countries count]
    return 5;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    //TO DO: return the associated country name
    //return self.countries[row];
    return @"dummy";
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    /*NSString* selected = self.countries[row];
    if (self.fromPickerIsShowing){
        NSString *selected = @"";
        self.selectedFrom = selected;
        self.fromCountryLabel.text = selected;
        self.fromCurrLabel.text = //get the currency from the country name
        self.toAmountField.text = //get new conversion
    } else if (self.toPickerIsShowing) {
        self.selectedTo = selected;
        self.toCountryLabel.text = selected;
        self.toCurrLabel.text = //get the currency name for country
        self.toAmountField.text = //get the new conversion
    }
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return firstSectionNumRows;
    return secondSectionNumRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == toCountryRow)
            return firstSectionCellHeight;
        if (indexPath.row == fromPickerRow)
            return self.fromPickerIsShowing ? pickerCellHeight : 0.0f;
        if(indexPath.row == toPickerRow)
            return self.toPickerIsShowing ? pickerCellHeight : 0.0f;
        if (indexPath.row == fromCountryRow)
            return  fromCellHeight;
    }
    return converterCellHeight;
}

- (IBAction)fromAmountDidChange:(UITextField *)sender {
    //get a new conversion and change the text of the to box
    self.toAmountField.text = sender.text;
}

#pragma mark - Table view delegate and helpers
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == fromPickerRow - 1) {
            [self countryLabelSelectHandler:self.fromPickerIsShowing pickerName:@"from"];
        } else if (indexPath.row == toPickerRow - 1) {
            [self countryLabelSelectHandler:self.toPickerIsShowing pickerName:@"to"];
        }
    }
    
}

-(void)countryLabelSelectHandler:(BOOL)pickerIsShowing pickerName:(NSString *)pickerName {
    if (pickerIsShowing) {
        [self hidePickerCell:pickerName];
    } else {
        [self showPickerCell:pickerName];
    }
}

- (void)showPickerCell:(NSString *)which {
    if ([which isEqualToString:@"from"]) {
        self.fromPickerIsShowing = YES;
    } else
        self.toPickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    if ([which isEqualToString:@"from"]) {
        self.fromPicker.hidden = NO;
        self.fromPicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            self.fromPicker.alpha = 1.0f;
        }];
    } else if ([which isEqualToString:@"to"]){
        self.toPicker.hidden = NO;
        self.toPicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            self.toPicker.alpha = 1.0f;
        }];
    }
}

- (void)hidePickerCell:(NSString *)which {
    if ([which isEqualToString:@"from"])
        self.fromPickerIsShowing = NO;
    else if ([which isEqualToString:@"to"])
        self.toPickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    if ([which isEqualToString:@"from"])
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.fromPicker.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.fromPicker.hidden = YES;
                         }];
    else if([which isEqualToString:@"to"])
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.toPicker.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.toPicker.hidden = YES;
                         }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
