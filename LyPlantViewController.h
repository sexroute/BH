//
//  LyPlantViewController.h
//  LuckyNumbers
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface LyPlantViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    @public
     NSMutableArray *listOfItems;
     NSMutableData *responseData;

}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@property (retain, nonatomic) IBOutlet UITableView *m_oTableView;


@end

