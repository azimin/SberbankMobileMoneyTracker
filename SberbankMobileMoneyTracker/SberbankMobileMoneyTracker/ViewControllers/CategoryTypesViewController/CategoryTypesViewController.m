//
//  CategoryTypesTableViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "CategoryTypesViewController.h"
#import "CategoryTypesTableViewCell.h"

@interface CategoryTypesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *categoryNames;
@property (strong, nonatomic) NSArray *categorySmallIcons;

@end

@implementation CategoryTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.categoryNames = @[@"Home", @"Health", @"Fun", @"Food"];
    self.categorySmallIcons = @[];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoryNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTypesTableViewCell *cell = (CategoryTypesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"categoryTypesCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryTypesTableViewCell" owner:self options:nil] firstObject];
    }
    
    cell.categoryNameLabel.text = self.categoryNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.categoryDelegate categoryTypesVC:self userDidSelectCategory:self.categoryNames[indexPath.row]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
