//
//  BestsellersViewController.h
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "DataModels.h"

@interface BestsellersViewController : AbstractViewController{
    NSMutableArray *_dataSource;
}

@property (nonatomic, strong) Genre *genre;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)refreshData:(UIRefreshControl *)control;

@end
