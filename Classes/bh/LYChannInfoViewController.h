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
    NSString * m_pStrGroup;
    NSString * m_pStrCompany;
    NSString * m_pStrFactory;
    NSString * m_pStrChann;
    NSString * m_pStrPlant;
}
@property (retain, nonatomic) NSMutableDictionary * m_pData;
@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrChann;
@property (retain, nonatomic) NSString * m_pStrPlant;
@property (retain, nonatomic) NSString * m_pStrChannUnit;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *m_oNavigateButton;

@property ( nonatomic) float m_fHH;
@property ( nonatomic) float m_fHL;
@property ( nonatomic) float m_fLL;
@property ( nonatomic) float m_fLH;
- (IBAction)onButtonPressed:(UIBarButtonItem *)sender;

@property ( nonatomic) int m_nChannType;
@end
