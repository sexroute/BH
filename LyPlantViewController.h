//
//  LyPlantViewController.h
//  LuckyNumbers
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface LyPlantViewController : UITableViewController
{
    @public
     NSMutableArray *listOfItems;
     NSMutableData *responseData;
}
@property (retain, nonatomic) IBOutlet UITableView *m_oTableView;

@end

