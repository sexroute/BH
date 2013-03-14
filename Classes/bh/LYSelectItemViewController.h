//
//  LYSelectItemViewController.h
//  bh
//
//  Created by zhaodali on 13-3-13.
//
//

#import <UIKit/UIKit.h>

@interface LYSelectItemViewController : UITableViewController
{
}
@property (strong,nonatomic) NSMutableArray * m_oItems;
@property (nonatomic) int m_nSelectedIndex;
@property (assign,nonatomic) id m_pParent;
@end
