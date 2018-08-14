//
//  TestSummaryViewController.m
//  Dr.Prebid
//
//  Created by Punnaghai Puviarasu on 8/13/18.
//  Copyright © 2018 Prebid. All rights reserved.
//

#import "TestSummaryViewController.h"
#import "SectionCell.h"
#import "TestHeaderCell.h"

NSString *__nonnull const kAdServerTestHeader = @"Ad Server Test";
NSString *__nonnull const kKVTargeting = @"KV Targeting sent";
NSString *__nonnull const kAdServerRequestsent = @"Ad Server Request sent";
NSString *__nonnull const kpbmjssent = @"PBM.JS received";

NSString *__nonnull const kRealTimeHeader = @"Real-Time Demand Validation Test";
NSString *__nonnull const kBidRequestSent = @"100 bid requests sent";
NSString *__nonnull const kBidResponseReceived = @"bid response received";
NSString *__nonnull const kCPMReceived = @"bid response received";

NSString *__nonnull const kSectionCellString = @"sCell";
NSString *__nonnull const kHeaderCellString = @"headerCell";

@interface TestSummaryViewController ()

@property NSDictionary *tableViewDictionaryItems;
@property NSArray *sectionTitles;
@property NSArray *adServerTitles;
@property NSArray *demandTitles;

@property NSIndexPath *selectedIndex;

@end

@implementation TestSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test Summary";
    
    self.adServerTitles = @[kKVTargeting, kAdServerRequestsent, kpbmjssent];
    self.demandTitles = @[kBidRequestSent, kBidResponseReceived, kCPMReceived];
    
    self.tableViewDictionaryItems = @{kAdServerTestHeader :self.adServerTitles, kRealTimeHeader:self.demandTitles};
    
    self.sectionTitles = @[kAdServerTestHeader, kRealTimeHeader];
    
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCell" bundle:nil] forCellReuseIdentifier:kSectionCellString];
     [self.tableView registerNib:[UINib nibWithNibName:@"TestHeaderCell" bundle:nil] forCellReuseIdentifier:kHeaderCellString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TestHeaderCell *cell = (TestHeaderCell *)[tableView dequeueReusableCellWithIdentifier:kHeaderCellString];
    
    if(cell == nil)
        return nil;
    
    if(cell != nil){
        NSString *titleText = [self.sectionTitles objectAtIndex:section];
        
        cell.lblHeader1.text = titleText;
        cell.lblHeader2.text = @"Passed";
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath {
    self.selectedIndex = indexPath;
    //[self btnAboutPressed:self];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 61.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return [self configureAdServerSection:self.tableView withIndexPath:indexPath];
    } else if(indexPath.section == 1){
        return [self configureDemandServerSection:self.tableView withIndexPath:indexPath];
    }
    
    return nil;
}

-(UITableViewCell *) configureAdServerSection:(UITableView *) tableView withIndexPath:(NSIndexPath *)indexPath {
    
    SectionCell *cell = (SectionCell *)[self.tableView dequeueReusableCellWithIdentifier:kSectionCellString ];

    if(cell == nil)
        return nil;
    
    if (indexPath.row == 0){

       cell.lblHeader.text = kKVTargeting;
       
    } else if(indexPath.row == 1){
       cell.lblHeader.text = kAdServerRequestsent;
       
    } else if(indexPath.row == 2){
        cell.lblHeader.text = kpbmjssent;
        
    }
    return cell;
}

-(UITableViewCell *) configureDemandServerSection:(UITableView *) tableView withIndexPath:(NSIndexPath *)indexPath {
    SectionCell *cell = (SectionCell *)[tableView dequeueReusableCellWithIdentifier:@"sCell"];
    
   if(cell == nil)
       return nil;
    if (indexPath.row == 0){
        
        cell.lblHeader.text = kBidRequestSent;
        
    } else if(indexPath.row == 1){
        cell.lblHeader.text = kBidResponseReceived;
        
    } else if(indexPath.row == 2){
        cell.lblHeader.text = kCPMReceived;
        
    }
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