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
@property (strong,nonatomic) NSMutableArray * m_oCompany;
@property (strong,nonatomic) NSMutableArray * m_oFactory;
@property (strong,nonatomic) NSMutableArray * m_oSet;
@property (strong,nonatomic) NSMutableArray * m_oType;

@property (nonatomic) int m_nSelectGroupIndex;
@property (nonatomic) int m_nSelectCompanyIndex;
@property (nonatomic) int m_nSelectFactoryIndex;
@property (nonatomic) int m_nSelectSetIndex;
@property (retain, nonatomic) IBOutlet UILabel *m_olblType;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_oTypeCell;

@end
