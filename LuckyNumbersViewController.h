//
//  LuckyNumbersViewController.h
//  LuckyNumbers
//
//  Created by Dan Grigsby on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyPlantViewController.h"
#import "LYNVController.h"



@interface LuckyNumbersViewController : UIViewController {
	IBOutlet UILabel *label;
	NSMutableData *responseData;
    NSMutableArray *listOfItems;
    LyPlantViewController * m_pPlantViewController;
    LYNVController *m_pNavViewController;
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *m_oActivityProgressbar;

@property (retain, nonatomic) IBOutlet UITableView *m_oTableView;
@property (retain, nonatomic) IBOutlet LYNVController *m_pNavViewController;
@end

