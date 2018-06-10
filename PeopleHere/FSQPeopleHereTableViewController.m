//
//  FSQPeopleHereTableViewController.m
//  ios-interview
//
//  Created by Samuel Grossberg on 3/17/16.
//  Copyright © 2016 Foursquare. All rights reserved.
//

#import "FSQPeopleHereTableViewController.h"
#import "VisitorViewModel.h"
#import "Keys.h"



@interface FSQPeopleHereTableViewController ()

@property (nonatomic, strong) VisitorViewModel *visitorVM;

@end



@implementation FSQPeopleHereTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.visitorVM fetchVisitorsFromJsonFile: kJsonVenueVisitors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// MARK: - # getter

-(VisitorViewModel *)visitorVM
{
    if (!_visitorVM)
    {
        weakify(self);
        _visitorVM = [[VisitorViewModel alloc] initWithUpdateBlock: ^{
            strongify(self);
            [self.tableView reloadData];
        }
                                                        errorBlock: ^(NSError * _Nonnull error) {
                                                            // TODO: handle error
                                                        }];
    }
    
    return _visitorVM;
}


// MARK: - # Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.visitorVM.numberOfVisitors;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"VisitorTableViewCell"
                                                            forIndexPath: indexPath];
    
    NSInteger index = indexPath.row;
    NSString *arriveTime = [self.visitorVM visitorArriveTimeAtIndex: index];
    NSString *leaveTime  = [self.visitorVM visitorLeaveTimeAtIndex: index];
    
    cell.textLabel.text       = [self.visitorVM visitorNameAtIndex: index];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ - %@", arriveTime, leaveTime];
    
    if ([self.visitorVM visitorIDAtIndex: index] == nil)
    {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

-(void)         tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath
                             animated: YES];
}

@end
