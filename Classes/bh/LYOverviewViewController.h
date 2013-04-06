//
//  LYOverviewViewController.h
//  bh
//
//  Created by zhao on 13-4-6.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
@interface LYOverviewViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (retain,nonatomic) UIImageView *m_oImageView;
@property (retain,nonatomic) NSString * m_strRemoteUrl;
@property (retain, nonatomic) NSMutableData * m_pResponseData;
@end
