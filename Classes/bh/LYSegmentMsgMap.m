//
//  LYSegmentMsgMap.m
//  bh
//
//  Created by zhaodali on 13-3-11.
//
//

#import "LYSegmentMsgMap.h"

@implementation LYSegmentMsgMap
@synthesize m_pSegmentTitle;
@synthesize m_pSegmentMsgIndex;
@synthesize m_pSegmentMsgHandle;
-(id) init
{
    self = [super init];
    self.m_pSegmentTitle = nil;
    self.m_pSegmentMsgIndex = [NSNumber numberWithInt:0];
    self.m_pSegmentMsgHandle = nil;
    return self;
}

- (void)dealloc
{
    self.m_pSegmentTitle = nil;
    self.m_pSegmentMsgIndex =nil;
    self.m_pSegmentMsgHandle = nil;

    [super dealloc];
    
}
@end
