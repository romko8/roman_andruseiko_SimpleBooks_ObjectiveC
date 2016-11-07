//
//  FavoritesViewController.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/6/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "FavoritesViewController.h"
#import "BestsellerCustomCell.h"
#import "DataModels.h"
#import "BookDetailsViewController.h"
#import "roman_andruseiko_SimpleBooks-Swift.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshData:nil];
}

- (void)buildUI {
}

- (void)refreshData:(UIRefreshControl *)control {
    _dataSource = [[NSMutableArray alloc] initWithArray:[[CoreDataManager sharedInstance] getAllBooks]];
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate and datasource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BestsellerCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BestsellerCustomCell" forIndexPath:indexPath];
    Book *book = _dataSource[indexPath.row];
    cell.bookNameLabel.text = book.name;
    cell.authorLabel.text = book.author;
    if (book.image) {
        cell.coverImageView.image = [UIImage imageWithData:book.image];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BookDetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bookDetailsViewController"];
    viewController.bestseller = [[Bestseller alloc] initWithBook:_dataSource[indexPath.row]];

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
