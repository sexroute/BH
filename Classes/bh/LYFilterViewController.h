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
@property (strong,nonatomic) NSMutableArray * m_oCompanys;
@property (strong,nonatomic) NSMutableArray * m_oFactorys;
@property (strong,nonatomic) NSMutableArray * m_oSets;
@property (strong,nonatomic) NSMutableArray * m_oPlantTypes;
@property (strong,nonatomic) NSMutableArray * m_oAllItems;



@property (retain, nonatomic) IBOutlet UILabel *m_olblType;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_oCellType;

@property (retain, nonatomic) NSString * m_strSelectedGroup;
@property (retain, nonatomic) NSString * m_strSelectedCompany;
@property (retain, nonatomic) NSString * m_strSelectedFactory;
@property (retain, nonatomic) NSString * m_strSelectedSet;
@property (retain, nonatomic) NSString * m_strSelectedType;

@property (strong,nonatomic) NSString * m_StrSelectedInSelectItemViewController;
@property (nonatomic) int m_nFilterType;
-(void) SaveSelectedItem;
@end
