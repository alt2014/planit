//
//  ForExTableViewController.h
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForExTableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)fromAmountDidChange:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *toAmountField;

@end
