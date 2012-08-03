//
//  LYChannInfoViewController.h
//  bh
//
//  Created by zhao on 12-8-3.
//
//

#import <UIKit/UIKit.h>
#import "ChannInfo.h"
@interface LYChannInfoViewController : UITableViewController
{
    NSMutableDictionary * m_pData;
}
@property (retain, nonatomic) NSMutableDictionary * m_pData;
@end
