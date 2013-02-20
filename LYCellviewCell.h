//
//  LYCellviewCell.h
//  bh
//
//  Created by Li Yan on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYCellviewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *m_plblOrg;

@property (retain, nonatomic) IBOutlet UILabel *m_plblRpm;
@property (retain, nonatomic) IBOutlet UIImageView *m_pImgStatus;
@property (retain, nonatomic) IBOutlet UILabel *m_lblPlantid;
@end
