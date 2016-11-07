//
//  GenresViewController.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/1/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "GenresViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BestsellersViewController.h"
#import "DataModels.h"
#import "WebService.h"
#import "roman_andruseiko_SimpleBooks-Swift.h"

@interface GenresViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GenresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    [self refreshData:nil];
}


- (void)buildUI {
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logOutButtonPressed)];
    self.tabBarController.navigationItem.leftBarButtonItem = leftBarButton;
    self.tabBarController.navigationItem.title = @"SimpleBooks";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
}

- (void)logOutButtonPressed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[FBSDKLoginManager new] logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[CoreDataManager sharedInstance] removeUsers];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refreshData:(UIRefreshControl *)control {
    [[WebService sharedInstance] getGenres:^(NSMutableArray *genres) {
        _dataSource = genres;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [control endRefreshing];
        });
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BestsellersViewController *destinationViewController = [segue destinationViewController];
    destinationViewController.genre = (Genre *)sender;
}

#pragma mark - UITableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    Genre *genre = _dataSource[indexPath.row];
    cell.textLabel.text = genre.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Genre *genre = _dataSource[indexPath.row];
    [self performSegueWithIdentifier:@"bestsellersControllerSegue" sender:genre];
}

@end
