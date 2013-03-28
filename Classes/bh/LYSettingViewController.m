//
//  LYSettingViewController.m
//  bh
//
//  Created by zhaodali on 13-3-11.
//
//

#import "LYSettingViewController.h"
#import "LYGlobalSettings.h"

@interface LYSettingViewController ()

@end

@implementation LYSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = [LYGlobalSettings GetSettingInt:SETTING_KEY_STYLE];

}

-(void)viewDidAppear:(BOOL)animated
{
    //1.调整登录按钮
    CGRect loFrame = self.m_olblLogout.frame;
    int a =self.m_oCelllogout.contentView.frame.size.width;
 
    int b = self.m_olblLogout.frame.size.width/2;
    loFrame.origin.x =   a/2-b;
    self.m_olblLogout.frame = loFrame;
    
    //2.调整用户名称
    loFrame = self.m_olabelUserName.frame;
    loFrame.origin.x = a - loFrame.size.width - 10;
    self.m_olabelUserName.frame = loFrame;
    self.m_olabelUserName.text = [LYGlobalSettings GetSettingString:SETTING_KEY_USER];
    
     UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
    
    [self.m_olblLogout addGestureRecognizer:tapGestureTel];
    [self.m_oCelllogout addGestureRecognizer:tapGestureTel];


}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    
    [self alertlogout];
}



-(void)doLogoOut
{
    
    //1.将登录状态设置为0
    [LYGlobalSettings SetSettingString:SETTING_KEY_LOGIN apVal:@"0"];
    //2.导航至splash window
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 错误提醒


- (void) alertlogout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认要退出当前账户么"
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 1;
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (nil!=actionSheet && actionSheet.tag== 1)
    {
        if (buttonIndex==1)
        {
            [self doLogoOut];
        }
    }else
    {
        

    }
    
}
#pragma mark - Table view delegate
- (void)dealloc {
    [_m_oSwitch release];
    [_m_oAutoRefreshCell release];
    [_m_olabelUserName release];
    [_m_oCelllogout release];
    [_m_olblLogout release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_oSwitch:nil];
    [self setM_oAutoRefreshCell:nil];
    [self setM_olabelUserName:nil];
    [self setM_oCelllogout:nil];
    [self setM_olblLogout:nil];
    [super viewDidUnload];
}
@end
