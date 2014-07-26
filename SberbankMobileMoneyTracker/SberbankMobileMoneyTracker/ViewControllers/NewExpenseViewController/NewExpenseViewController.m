//
//  NewExpenseViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "NewExpenseViewController.h"
#import "CategoryTypesViewController.h"

@interface NewExpenseViewController ()<UITextFieldDelegate, CategoryTypesViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UILabel *categoryTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation NewExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.valueTextField.delegate = self;
    
    [self.categoryButton addTarget:self action:@selector(goToCategoryTypesViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton addTarget:self action:@selector(confirmButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goToCategoryTypesViewController{
    CategoryTypesViewController *categoryTypesTVC = [[CategoryTypesViewController alloc] initWithNibName:@"CategoryTypesViewController" bundle:[NSBundle mainBundle]];
    categoryTypesTVC.categoryDelegate = self;
    
    [self presentViewController:categoryTypesTVC animated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self checkInputData];
    return YES;
}

- (void)confirmButtonTouchUpInside{
    //code for processing new expense
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonTouchUpInside{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// user select category on CategoryTypesViewController
- (void)categoryTypesVC:(CategoryTypesViewController *)categoryTypesVC userDidSelectCategory:(NSString *)categoryName{
    self.categoryTypeLabel.text = categoryName;
    
    [self checkInputData];
}

//check if all parameters have selected
- (void)checkInputData{
    BOOL isAccepted = YES;
    isAccepted = isAccepted && ![self.categoryTypeLabel.text isEqualToString:@"Category"];
    isAccepted = isAccepted && ![self.valueTextField.text isEqualToString:@""];
    
    if(isAccepted){
        // change button color
    }
}


@end
