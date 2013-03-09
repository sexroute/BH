//
//  LYCellviewCell.m
//  bh
//
//  Created by Li Yan on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LYCellviewCell.h"

@implementation LYCellviewCell
@synthesize m_plblOrg;
@synthesize m_plblRpm;
@synthesize m_pImgStatus;
@synthesize m_lblPlantid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [m_lblPlantid release];
    [m_pImgStatus release];
    [m_plblRpm release];
    [m_plblOrg release];
    [super dealloc];
}
@end
