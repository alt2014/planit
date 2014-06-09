//
//  ForExTableViewController.m
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "ForExTableViewController.h"
#import "Currency.h"
#import "CurrencyManager.h"
#import "CurrencyCommunicator.h"
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
@property (weak, nonatomic) IBOutlet UITextField *fromAmountField;
@property (weak, nonatomic) IBOutlet UILabel *fromCountryLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *fromPicker;
@property (weak, nonatomic) IBOutlet UILabel *toCountryLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *toPicker;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSArray *currCodes;
@end

Currency *_currencyRates;
CurrencyManager *_manager;

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
    _manager = [[CurrencyManager alloc] init];
    _manager.communicator = [[CurrencyCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    self.countries = @[@"United Arab Emirates Dirham",@"Afghan Afghani",@"Albanian Lek", @"Armenian Dram",@"Netherlands Antillean Guilder",@"Angolan Kwanza",@"Argentine Peso",@"Australian Dollar",@"Aruban Florin", @"Azerbaijani Manat",@"Bosnia-Herzegovina Convertible Mark", @"Barbadian Dollar", @"Bangladeshi Taka", @"Bulgarian Lev", @"Bahraini Dinar", @"Burundian Franc",@"Bermudan Dollar",@"Brunei Dollar", @"Bolivian Boliviano", @"Brazilian Real", @"Bahamian Dollar", @"Bitcoin", @"Bhutanese Ngultrum",@"Botswanan Pula", @"Belarusian Ruble", @"Belize Dollar", @"Canadian Dollar", @"Congolese Franc", @"Swiss Franc", @"Chilean Unit of Account (UF)", @"Chilean Peso", @"Chinese Yuan",@"Colombian Peso", @"Costa Rican Colón", @"Cuban Peso", @"Cape Verdean Escudo", @"Czech Republic Koruna", @"Djiboutian Franc", @"Danish Krone", @"Dominican Peso", @"Algerian Dinar", @"Estonian Kroon", @"Egyptian Pound", @"Eritrean Nakfa", @"Ethiopian Birr", @"Euro", @"Fijian Dollar", @"Falkland Islands Pound", @"British Pound Sterling", @"Georgian Lari", @"Ghanaian Cedi", @"Gibraltar Pound", @"Gambian Dalasi", @"Guinean Franc", @"Guatemalan Quetzal", @"Guyanaese Dollar", @"Hong Kong Dollar", @"Honduran Lempira", @"Croatian Kuna", @"Haitian Gourde", @"Hungarian Forint", @"Indonesian Rupiah", @"Israeli New Sheqel", @"Indian Rupee", @"Iraqi Dinar", @"Iranian Rial", @"Icelandic Króna", @"Jersey Pound", @"Jamaican Dollar", @"Jordanian Dinar", @"Japanese Yen", @"Kenyan Shilling", @"Kyrgystani Som", @"Cambodian Riel", @"Comorian Franc", @"North Korean Won", @"South Korean Won", @"Kuwaiti Dinar", @"Cayman Islands Dollar", @"Kazakhstani Tenge", @"Laotian Kip", @"Lebanese Pound", @"Sri Lankan Rupee", @"Liberian Dollar", @"Lesotho Loti", @"Lithuanian Litas", @"Latvian Lats", @"Libyan Dinar", @"Moroccan Dirham", @"Moldovan Leu", @"Malagasy Ariary", @"Macedonian Denar", @"Myanma Kyat", @"Mongolian Tugrik", @"Macanese Pataca", @"Mauritanian Ouguiya", @"Maltese Lira", @"Mauritian Rupee", @"Maldivian Rufiyaa", @"Malawian Kwacha", @"Mexican Peso", @"Malaysian Ringgit", @"Mozambican Metical", @"Namibian Dollar", @"Nigerian Naira", @"Nicaraguan Córdoba", @"Norwegian Krone", @"Nepalese Rupee", @"New Zealand Dollar", @"Omani Rial", @"Panamanian Balboa", @"Peruvian Nuevo Sol", @"Papua New Guinean Kina", @"Philippine Peso", @"Pakistani Rupee", @"Polish Zloty", @"Paraguayan Guarani", @"Qatari Rial", @"Romanian Leu", @"Serbian Dinar", @"Russian Ruble", @"Rwandan Franc", @"Saudi Riyal", @"Solomon Islands Dollar", @"Seychellois Rupee", @"Sudanese Pound", @"Swedish Krona", @"Singapore Dollar", @"Saint Helena Pound", @"Sierra Leonean Leone", @"Somali Shilling", @"Surinamese Dollar", @"São Tomé and Príncipe Dobra", @"Salvadoran Colón", @"Syrian Pound", @"Swazi Lilangeni", @"Thai Baht", @"Tajikistani Somoni", @"Turkmenistani Manat",@"Tunisian Dinar", @"Tongan Paʻanga", @"Turkish Lira", @"Trinidad and Tobago Dollar", @"New Taiwan Dollar", @"Tanzanian Shilling", @"Ukrainian Hryvnia", @"Ugandan Shilling", @"United States Dollar",@"Uruguayan Peso",@"Uzbekistan Som",@"Venezuelan Bolívar Fuerte",@"Vietnamese Dong",@"Vanuatu Vatu", @"Samoan Tala", @"CFA Franc BEAC", @"Silver (troy ounce)", @"Gold (troy ounce)", @"East Caribbean Dollar", @"Special Drawing Rights", @"CFA Franc BCEAO", @"CFP Franc", @"Yemeni Rial", @"South African Rand", @"Zambian Kwacha (pre-2013)",@"Zambian Kwacha", @"Zimbabwean Dollar"];
    self.currCodes = @[@"AED", @"AFN", @"ALL", @"AMD", @"ANG", @"AOA", @"ARS", @"AUD", @"AWG", @"AZN", @"BAM",  @"BBD",  @"BDT",  @"BGN",  @"BHD",  @"BIF",  @"BMD",  @"BND", @"BOB", @"BRL", @"BSD", @"BTC", @"BTN", @"BWP", @"BYR", @"BZD", @"CAD", @"CDF", @"CHF", @"CLF", @"CLP", @"CNY", @"COP", @"CRC", @"CUP",  @"CVE",  @"CZK",  @"DJF",  @"DKK",  @"DOP",  @"DZD",  @"EEK",  @"EGP",  @"ERN",  @"ETB",  @"EUR",  @"FJD",  @"FKP",  @"GBP",  @"GEL",  @"GHS",  @"GIP",  @"GMD",  @"GNF",  @"GTQ",  @"GYD",  @"HKD",  @"HNL",  @"HRK",  @"HTG",  @"HUF",  @"IDR",  @"ILS",  @"INR",  @"IQD",  @"IRR",  @"ISK",  @"JEP",  @"JMD",  @"JOD",  @"JPY",  @"KES",  @"KGS",  @"KHR",  @"KMF",  @"KPW",  @"KRW",  @"KWD",  @"KYD",  @"KZT",  @"LAK",  @"LBP",  @"LKR",  @"LRD",  @"LSL",  @"LTL",  @"LVL",  @"LYD",  @"MAD",  @"MDL",  @"MGA",  @"MKD",  @"MMK",  @"MNT",  @"MOP",  @"MRO",  @"MTL",  @"MUR",  @"MVR",  @"MWK",  @"MXN",  @"MYR",  @"MZN",  @"NAD",  @"NGN",  @"NIO",  @"NOK",  @"NPR",  @"NZD",  @"OMR",  @"PAB",  @"PEN",  @"PGK",  @"PHP",  @"PKR",  @"PLN",  @"PYG",  @"QAR",  @"RON",  @"RSD",  @"RUB",  @"RWF",  @"SAR",  @"SBD",  @"SCR",  @"SDG",  @"SEK",  @"SGD",  @"SHP",  @"SLL",  @"SOS",  @"SRD",  @"STD",  @"SVC",  @"SYP",  @"SZL",  @"THB",  @"TJS",  @"TMT",  @"TND",  @"TOP",  @"TRY",  @"TTD",  @"TWD",  @"TZS",  @"UAH",  @"UGX",  @"USD",  @"UYU",  @"UZS",  @"VEF",  @"VND",  @"VUV",  @"WST",  @"XAF",  @"XAG",  @"XAU",  @"XCD",  @"XDR",  @"XOF",  @"XPF",  @"YER",  @"ZAR",  @"ZMK",  @"ZMW",  @"ZWL"];
    
    [self hidePickerCell:@"from"];
    [self hidePickerCell:@"to"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CurrencyManagerDelegate
-(void)didReceiveRates:(Currency *)currencyRates
{
    _currencyRates = currencyRates;
}

-(void) fetchingCurrencyFailedWithError:(NSError *)error
{
    NSLog(@"Error: %@; %@", error, [error localizedDescription]);
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
    return [self.countries count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return self.countries[row];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)getConversionString
{
    Currency *currency = [[Currency alloc] init];
    [currency setValue:self.fromCurrLabel.text forKey:@"countryCode1"];
    [currency setValue:self.toCurrLabel.text forKey:@"countryCode2"];
    
    NSDecimalNumber *factor = [NSDecimalNumber decimalNumberWithString:self.fromAmountField.text];
    NSDecimalNumber *rate = [currency.exchangeRate decimalNumberByMultiplyingBy:factor];
    
    NSString *rateStr = [NSString stringWithFormat: @"%@", rate];
    // Truncates so only 3 decimal values remain - i.e. CNY -> GBP = 0.095
    //rateStr = [rateStr substringToIndex: 11];
    return rateStr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSString* selected = self.countries[row];
    if (self.fromPickerIsShowing && pickerView == self.fromPicker){
        self.selectedFrom = selected;
        self.fromCountryLabel.text = selected;
        self.fromCurrLabel.text = self.currCodes[row];
    } else if (self.toPickerIsShowing && pickerView == self.toPicker) {
        self.selectedTo = selected;
        self.toCountryLabel.text = selected;
        self.toCurrLabel.text = self.currCodes[row];
    }
    
    //Currency *currency = [[Currency alloc] init];
    [_currencyRates setValue:self.fromCurrLabel.text forKey:@"countryCode1"];
    [_currencyRates setValue:self.toCurrLabel.text forKey:@"countryCode2"];
    
    [_manager.communicator getCurrentCurrencyRates:_currencyRates callback:^(NSError *err, Currency *trips) {
        NSDecimalNumber *factor = [NSDecimalNumber decimalNumberWithString:self.fromAmountField.text];
        NSDecimalNumber *rate = [trips.exchangeRate decimalNumberByMultiplyingBy:factor];
        
        NSString *rateStr = [NSString stringWithFormat: @"%@", rate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.toAmountField setText:rateStr];
        });
    }];
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
    NSDecimalNumber *factor = [NSDecimalNumber decimalNumberWithString:self.fromAmountField.text];
    NSDecimalNumber *rate = [_currencyRates.exchangeRate decimalNumberByMultiplyingBy:factor];
    
    NSString *rateStr = [NSString stringWithFormat: @"%@", rate];
    [self.toAmountField setText:rateStr];
    //self.toAmountField.text = [self getConversionString];
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
