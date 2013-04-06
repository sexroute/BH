//
//  DetailViewController.h
//  bh
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYDetailViewController : UITableViewController
{
    NSMutableDictionary * m_pPlantInfoData;
}

@property (retain, nonatomic) NSMutableDictionary * m_pPlantInfoData;
@end
