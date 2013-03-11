//
//  LYSegmentMsgMap.h
//  bh
//
//  Created by zhaodali on 13-3-11.
//
//

#import <Foundation/Foundation.h>

@interface LYSegmentMsgMap : NSObject
{
    SEL m_pSegmentMsgHandle;
    NSNumber * m_pSegmentMsgIndex;
    NSString * m_pSegmentTitle;    
}
@property (retain, nonatomic) NSString * m_pSegmentTitle;
@property (retain, nonatomic) NSNumber * m_pSegmentMsgIndex;
@property SEL m_pSegmentMsgHandle;

@end
