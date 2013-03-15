//
//  LYTabBarViewController.m
//  bh
//
//  Created by zhaodali on 13-3-11.
//
//

#import "LYTabBarViewController.h"
#import "LyPlantViewController.h"
#import "LYNVController.h"

@interface LYTabBarViewController ()

@end

@implementation LYTabBarViewController

@synthesize m_oListView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) InitUI
{
    
    int lnPlantViewIndex = 0;
    int lnAlarmLogViewIndex = 1;
    int lnSettingViewIndex = 1;
    //1.隐藏系统提供的navigate controller
    [self.navigationController setNavigationBarHidden:YES];
    
    //2.设置设备数据
    
    [[self.tabBar.items objectAtIndex:lnPlantViewIndex] setTitle:@"设备"];
    LYNVController * lplantNavicator = (LYNVController*)[self.viewControllers objectAtIndex:lnPlantViewIndex];
    
    LYPlantViewController *lpPlantTableViewController = nil;
    
    if (NULL!= lplantNavicator)
    {
        UIViewController * lpViewController =   [lplantNavicator topViewController];
        if (nil!= lpViewController && [lpViewController isKindOfClass:[LYPlantViewController class]])
        {
            lpPlantTableViewController = (LYPlantViewController *)lpViewController;
             lpPlantTableViewController.m_oPlantItems = self.m_oListView;
            
             [lpPlantTableViewController PreparePlantsData];
        }
       
    }
    //3.报警日志视图
   
    [[self.tabBar.items objectAtIndex:lnAlarmLogViewIndex] setTitle:@"报警"];

    //4.设置视图
    [[self.tabBar.items objectAtIndex:lnSettingViewIndex] setTitle:@"设置"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self InitUI];
    
	// Do any additional setup after loading the view.
}

-(void)dealloc
{
    
    self.m_oListView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
