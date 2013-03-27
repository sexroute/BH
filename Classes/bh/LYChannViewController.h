//
//  LYChannViewController.h
//  bh
//
//  Created by zhao on 12-8-3.
//
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "ChannInfo.h"

@interface LYChannViewController : UITableViewController
{
    NSString * m_pStrGroup;
    NSString * m_pStrCompany;
    NSString * m_pStrFactory;
    NSString * m_pStrSet;
    NSString * m_pStrPlant;
    NSMutableData *responseData;
    NSMutableArray *listOfItems;
    NSMutableArray *VibChanns;
    NSMutableArray *DynChanns;
    NSMutableArray *ProcChanns;
    
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *m_pProgressBar;
@property (retain, nonatomic) NSString * m_pStrGroup;
@property (retain, nonatomic) NSString * m_pStrCompany;
@property (retain, nonatomic) NSString * m_pStrFactory;
@property (retain, nonatomic) NSString * m_pStrSet;
@property (retain, nonatomic) NSString * m_pStrPlant;
@property (retain, nonatomic) NSMutableArray * VibChanns;
@property (retain, nonatomic) NSMutableArray * DynChanns;
@property (retain, nonatomic) NSMutableArray * ProcChanns;
@property (nonatomic) int m_nPlantType;
@property (retain, nonatomic) NSString * m_pStrTimeStart;
@property (retain, nonatomic) NSString * m_strChannDiaged;

@end
