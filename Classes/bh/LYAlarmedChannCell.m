//
//  LYAlarmedChannCell.m
//  bh
//
//  Created by zhaodali on 13-3-28.
//
//

#import "LYAlarmedChannCell.h"

@implementation LYAlarmedChannCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    [_m_oLabel release];
    [_m_oStatus release];
    [super dealloc];
}
@end
