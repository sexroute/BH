//
//  LYLoginCell.m
//  bh
//
//  Created by zhaodali on 13-2-28.
//
//

#import "LYLoginCell.h"

@implementation LYLoginCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    self.textLabel.bounds = CGRectMake(0, 0, 0, 0);

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
