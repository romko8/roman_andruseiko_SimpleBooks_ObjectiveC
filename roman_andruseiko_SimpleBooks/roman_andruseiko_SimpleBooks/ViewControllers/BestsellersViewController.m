//
//  BestsellersViewController.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "BestsellersViewController.h"
#import "WebService.h"
#import "BestsellerCustomCell.h"
#import "BookDetailsViewController.h"
#import "UIImageView+ImageDownloading.h"

@interface BestsellersViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSMutableArray *_filteredDataSource;
    BOOL _searchActive;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation BestsellersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_tableView registerNib:[UINib nibWithNibName:@"BestsellerCustomCell" bundle:nil] forCellReuseIdentifier:@"BestsellerCustomCell"];
    
    [self buildUI];
    [self refreshData:nil];
}

- (void)buildUI {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [_tableView addSubview:refreshControl];
}

- (void)refreshData:(UIRefreshControl *)control {
    [[WebService sharedInstance] getBestsellersForGenre:_genre.encodedName withCompletion:^(NSMutableArray *bestsellers) {
        _dataSource = bestsellers;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [control endRefreshing];
        });
    }];
}

#pragma mark - UITableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchActive) {
        return [_filteredDataSource count];
    }
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BestsellerCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BestsellerCustomCell" forIndexPath:indexPath];
    Bestseller *bestseller;
    if (_searchActive) {
        bestseller = _filteredDataSource[indexPath.row];
    } else {
        bestseller = _dataSource[indexPath.row];
    }
    cell.bookNameLabel.text = bestseller.name;
    cell.authorLabel.text = bestseller.authorName;
    [cell.coverImageView setImageDownloadedFrom:[[WebService sharedInstance] getCoverImagePath:bestseller.isbnCode]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BookDetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bookDetailsViewController"];
    if (_searchActive) {
        viewController.bestseller = _filteredDataSource[indexPath.row];
    } else {
        viewController.bestseller = _dataSource[indexPath.row];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}

#pragma mark - UISearchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _searchActive = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    _searchActive = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchActive = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchActive = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.name contains[cd] %@) OR (SELF.authorName contains[cd] %@)", searchText, searchText];
    _filteredDataSource = [[_dataSource filteredArrayUsingPredicate:predicate] mutableCopy];
    _searchActive = _filteredDataSource.count != 0;
    
    [_tableView reloadData];
}

@end
