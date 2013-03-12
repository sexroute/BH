//
//  LYSettingViewController.h
//  bh
//
//  Created by zhaodali on 13-3-11.
//
//

#import <UIKit/UIKit.h>

@interface LYSettingViewController : UITableViewController
@property (retain, nonatomic) IBOutlet UISwitch *m_oSwitch;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_oAutoRefreshCell;
@property (retain, nonatomic) IBOutlet UILabel *m_olabelUserName;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_oCelllogout;
@property (retain, nonatomic) IBOutlet UILabel *m_olblLogout;

@end
