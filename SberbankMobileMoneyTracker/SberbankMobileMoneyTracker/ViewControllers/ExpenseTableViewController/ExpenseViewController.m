//
//  ExpenseViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 27/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "ExpenseViewController.h"
#import "CategoryTypesTableViewCell.h"

@interface ExpenseViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:self.bgImage];
    bgImageView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:bgImageView atIndex:0];
    
    self.tableView.tableHeaderView = [self tableViewHeaderView];
    // Do any additional setup after loading the view from its nib.
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
    return 0;
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
    
   // cell.categoryNameLabel.text = self.categoryNames[indexPath.row];
    
    return cell;
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
