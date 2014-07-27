//
//  ExpenseViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 27/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "ExpenseViewController.h"
#import "ExpenseInfoCell.h"

@interface ExpenseViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *expenses;
@property (nonatomic) UILabel *pullToCloseLabel;

@end

@implementation ExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:self.bgImage];
    bgImageView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:bgImageView atIndex:0];
    
    self.tableView.tableHeaderView = [self tableViewHeaderView];
    // Do any additional setup after loading the view from its nib.
    
    self.expenses = [NSMutableArray array];
    [self.expenses addObject:@{@"value":@"100", @"name": @"Swag"}];
    [self.expenses addObject:@{@"value":@"1000", @"name": @"McDonalds"}];
    [self.expenses addObject:@{@"value":@"500", @"name": @"Car rent"}];
    
    self.pullToCloseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, 320, 40)];
    self.pullToCloseLabel.text = @"Pull to close";
    self.pullToCloseLabel.textAlignment = NSTextAlignmentCenter;
    self.pullToCloseLabel.textColor = [UIColor whiteColor];
    [self.tableView addSubview:self.pullToCloseLabel];
}

#pragma mark - Custom View

- (UIView*)tableViewHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [but setImage:[[UIImage imageNamed:@"btn_creation_cancel"] imageWithOverlayColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 63, 320, 1)];
    seperator.backgroundColor = [UIColor mainGreyColor];
    [view addSubview:seperator];
    
    return view;
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expenses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpenseInfoCell *cell = (ExpenseInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpenseInfoCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpenseInfoCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.nameLabel.text = self.expenses[indexPath.row][@"name"];
    cell.valueLabel.text = self.expenses[indexPath.row][@"value"];
    
   // cell.categoryNameLabel.text = self.categoryNames[indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -100) {
        self.pullToCloseLabel.text = @"Release your finger to close";
    } else {
        self.pullToCloseLabel.text = @"Pull to close";
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
