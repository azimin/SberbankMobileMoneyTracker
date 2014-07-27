//
//  NewExpenseViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "NewExpenseViewController.h"
#import "CategoryTypesTableViewCell.h"
#import "Circle.h"

#import "MoneyTrackerServerManager.h"
#import "CoreDataManager.h"

#import <MBProgressHUD.h>

@interface NewExpenseViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UILabel *categoryTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) Circle *categoryCircle;

@property (nonatomic) NSInteger selectedIndex;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *categoryNames;

@property (nonatomic) Circle *circleButton;

@end

@implementation NewExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.categoryButton addTarget:self action:@selector(goToCategoryTypesViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    imgView.frame = [UIScreen mainScreen].bounds;
    imgView.alpha = 0.4;
    [self.view insertSubview:imgView atIndex:0];
    
    UIView *vi = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    vi.backgroundColor = [UIColor whiteColor];
    vi.alpha = 0.5;
    [self.view insertSubview:vi aboveSubview:imgView];
    
    [self.valueTextField becomeFirstResponder];
    
    self.categoryCircle = [[Circle alloc] initWithRadius:10 andCenter:CGPointMake(31, 89)];
    self.categoryCircle.color = [UIColor redColor];
    [self.contentView addSubview:self.categoryCircle];
    
    self.categoryNames = [NSArray categoriesArray];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    
    [self.tableView reloadData];
    
    self.circleButton = [[Circle alloc] initWithRadius:45 andCenter:CGPointMake(320/2, 289)];
    self.circleButton.color = [UIColor mainGreyColor];
    imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_creation_create"]];
    imgView.frame = self.circleButton.bounds;
    [self.circleButton addSubview:imgView];
    [self.circleButton addTarget:self action:@selector(createEntity)];
    
    [self.contentView addSubview:self.circleButton];
    
    self.selectedIndex = 2;
    
}

- (void)createEntity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.valueTextField resignFirstResponder];
    [[CoreDataManager sharedInstance] addExpense:[self.valueTextField.text doubleValue] toCategory:self.categoryTypeLabel.text withDescription:@"cash" atDate:[NSDate date]];
    
    NSDictionary *expenseDic = @{@"category": self.categoryTypeLabel.text,
                                 @"description": @"cash",
                                 @"value": self.valueTextField.text,
                                 @"date": [NSDate date]};
    
    [[MoneyTrackerServerManager sharedInstance] sendNewExpense:expenseDic withSuccess:^{
        [[CoreDataManager sharedInstance] fetchExpensesStatistic];
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Server not respond" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Custom View

- (UIView*)tableViewHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    seperator.backgroundColor = [UIColor mainGreyColor];
    [view addSubview:seperator];
    
    return view;
}

- (void)goToCategoryTypesViewController{
    [self.valueTextField resignFirstResponder];
    [self tableViewCategoriesShouldShow:TRUE];
}

#pragma mark - Setter

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    self.categoryCircle.color = [UIColor circleColors][selectedIndex];
    NSArray *categoriesArray = [NSArray categoriesArray];
    self.categoryTypeLabel.text = categoriesArray[selectedIndex];
    self.circleButton.color = [UIColor circleColors][selectedIndex];
}

#pragma mark - IB Buttons

- (void)cancelButtonTouchUpInside{
    [self.valueTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma marl - Table View Delegat

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoryNames count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTypesTableViewCell *cell = (CategoryTypesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"categoryTypesCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryTypesTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.categoryCircle.color = (UIColor*)[UIColor circleColors][indexPath.row];
    
    cell.categoryNameLabel.text = self.categoryNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tableViewCategoriesShouldShow:FALSE];
    self.selectedIndex = indexPath.row;
}

#pragma mark - Navigation

- (void)tableViewCategoriesShouldShow:(BOOL)shouldShow
{
    CGFloat delta = self.view.frame.size.height;
    
    [UIView animateWithDuration:0.4 animations:^{
        if (shouldShow) {
            self.contentView.center = CGPointMake(self.contentView.center.x, delta / 2 - delta);
            self.tableView.center = CGPointMake(self.contentView.center.x, delta / 2);
        } else {
            self.tableView.center = CGPointMake(self.contentView.center.x, delta / 2 + delta);
            self.contentView.center = CGPointMake(self.contentView.center.x, delta / 2);
        }
    }];
}



@end
