//
//  LYFilterViewController.h
//  bh
//
//  Created by zhaodali on 13-3-12.
//
//

#import <UIKit/UIKit.h>

@interface LYFilterViewController : UITableViewController
{
    
}
@property (retain, nonatomic) IBOutlet UILabel *m_olblGroup;

@property (retain, nonatomic) IBOutlet UITableViewCell *m_oCellGroup;
@property (retain, nonatomic) IBOutlet UILabel *m_olblCompany;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_oCellCompany;
@property (retain, nonatomic) IBOutlet UILabel *m_olblFactory;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_oCellFactory;
@property (retain, nonatomic) IBOutlet UILabel *m_olblSet;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_oCellSet;
@property (strong,nonatomic) NSMutableArray * m_oGroups;

@end
