//
//  LYChannInfoViewController.m
//  bh
//
//  Created by zhao on 12-8-3.
//
//

#import "LYChannInfoViewController.h"
#import "LYWaveViewController.h"
#import "LYBHUtility.h"
#import "LYTrendViewController.h"


@implementation LYChannInfoViewController
@synthesize m_pChannInfo;
@synthesize m_pStrGroup;
@synthesize m_pStrCompany;
@synthesize m_pStrFactory;
@synthesize m_pStrChann;
@synthesize m_pStrPlant;
@synthesize m_pStrChannUnit;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.m_fHH = .0;
        self.m_fHL = .0;
        self.m_fLL = .0;
        self.m_fLH = .0;
        self.m_nAlarmJudgeType= E_ALARMCHECK_LOWPASS;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (nil != self.m_pChannInfo)
    {
        self.navigationItem.title = [self.m_pChannInfo objectForKey:@"name"];
    }
    int lnChanntype  = [self GetChanntype];
    lnChanntype = [LYBHUtility GetChannType:lnChanntype];
    switch (lnChanntype)
    {
        case E_TBL_CHANNTYPE_VIB:
        case E_TBL_CHANNTYPE_DYN:
            self.m_oNavigateButton.title = @"波形/频谱";
            break;
        case E_TBL_CHANNTYPE_PROC:
            self.m_oNavigateButton.title = @"历史趋势";
            break;
        default:
            break;
    }
    
    id lpObj = [self.m_pChannInfo objectForKey:@"HH"];
    self.m_fHH = [lpObj floatValue];
    
    lpObj = [self.m_pChannInfo objectForKey:@"HL"];
    self.m_fHL = [lpObj floatValue];
    
    lpObj = [self.m_pChannInfo objectForKey:@"LL"];
    self.m_fLL = [lpObj floatValue];
    
    lpObj = [self.m_pChannInfo objectForKey:@"LH"];
    self.m_fLH = [lpObj floatValue];
    
    lpObj = [self.m_pChannInfo objectForKey:@"unit"];
    self.m_pStrChannUnit = lpObj;
    
    lpObj = [self.m_pChannInfo objectForKey:@"chann_type"];
    self.m_nChannType = [lpObj intValue];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(int)GetChanntype
{
    id lpObj = [self.m_pChannInfo objectForKey:@"chann_type"];
    NSNumber * lpVal = lpObj;
    int lnChanType = [lpVal intValue];
    return  lnChanType;
}

- (void)viewDidUnload
{
    [self setM_oNavigateButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"基本信息", @"Basic Chann Info");
            break;
        case 1:
            title = NSLocalizedString(@"报警信息", @"Alarm Chann Info");
            break;
            
        default:
            break;
    }
    return title;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    int lnReturnValue = 0;
    switch (section) {
        case 0:
            lnReturnValue = 8;
            break;
        case 1:
            lnReturnValue = 6;
            break;
        default:
            break;
    }
    return lnReturnValue;
}

//GE_ALLPROC          = 0,        /*!所有过程量测点*/
//GE_VIBCHANN         = 1,        /*!径向振动测点.*/
//GE_AXIALCHANN       = 2,        /*!轴向振动测点.axial displacement*/
//GE_PRESSCHANN       = 3,        /*!压力测点.*/
//GE_TEMPCHANN        = 4,        /*!温度测点.*/
//GE_FLUXCHANN        = 5,        /*!流量测点.*/
//GE_OTHERCHANN       = 6,        /*!其它.*/
//GE_IMPACTCHANN      = 7,        ///撞击通道
//GE_CURRENTCHANN     = 8,        ///电流测点
//GE_DYNPRESSCHANN    = 11,       ///动态压力信号
//GE_RODSINKCHANN     = 12,       ///活塞杆下沉量信号
//GE_DYNSTRESSCHANN   = 13,       /* !动态应力测点*/
//GE_AXISLOCATIONCHANN= 100       /*!轴心位置*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
    id lpObj = nil;
    id loAlarmJudgeType = nil;
    NSString * lpTitle = nil;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row)
        {
            case 0:
            {
                
                lpObj = [self.m_pChannInfo objectForKey:@"name"];
                lpTitle = @"测 点 名";
                self.m_pStrChann = lpObj;}
                break;
            case 1:
            {    lpObj = [self.m_pChannInfo objectForKey:@"alias_name"];
                lpTitle = @"测点别名";}
                break;
            case 2:
                
            {    lpObj = [self.m_pChannInfo objectForKey:@"chann_type"];
                NSNumber * lpVal = lpObj;
                int lnChanType = [lpVal intValue];
                self.m_nChannType = lnChanType;
                switch (lnChanType) {
                    case GE_ALLPROC:
                    {    lpObj = @"过程量测点";}
                        break;
                    case GE_VIBCHANN:
                    {   lpObj = @"径向振动测点";}
                        break;
                    case GE_AXIALCHANN:
                    {    lpObj = @"轴向振动测点";}
                        break;
                    case GE_PRESSCHANN:
                    {   lpObj = @"压力测点";}
                        break;
                    case GE_TEMPCHANN:
                    {   lpObj = @"温度测点";}
                        break;
                    case GE_OTHERCHANN:
                    {   lpObj = @"其它类型测点";}
                        break;
                    case GE_FLUXCHANN:
                    {   lpObj = @"流量测点";}
                        break;
                    case GE_IMPACTCHANN:
                    {   lpObj = @"撞击测点";}
                        break;
                    case GE_CURRENTCHANN:
                    {   lpObj = @"电流测点";}
                        break;
                    case GE_DYNPRESSCHANN:
                    {   lpObj = @"动态压力信号";}
                        break;
                    case GE_RODSINKCHANN:
                    {   lpObj = @"活塞杆下沉量信号";}
                        break;
                    case GE_DYNSTRESSCHANN:
                    {   lpObj = @"动态应力测点";}
                        break;
                    case GE_AXISLOCATIONCHANN:
                    {   lpObj = @"轴心位置";}
                        break;
                    default:
                        break;
                }
                lpTitle = @"测点别名";}
                break;
            case 3:
            {
                
                lpTitle = @"更新时间";
                lpObj = [self.m_pChannInfo objectForKey:@"datetime"];
                
            }
                break;
            case 4:
            { lpTitle = @"转   速";
                lpObj = [self.m_pChannInfo objectForKey:@"rev"];
                
            }
                break;
            case 5:
            { lpTitle = @"当前值 ";
                lpObj = [self.m_pChannInfo objectForKey:@"val"];
            }
                break;
            case 6:
            {
                lpTitle = @"单   位";
                lpObj = [self.m_pChannInfo objectForKey:@"unit"];
            }
                break;
            case 7:
            {
                lpTitle = @"报警状态";
                lpObj = [self.m_pChannInfo objectForKey:@"alarm_status"];
                int lnAlarmStatus = [(NSNumber *)lpObj intValue];
                loAlarmJudgeType = [self.m_pChannInfo objectForKey:@"alarmJudgeType"];
                self.m_nAlarmJudgeType = [loAlarmJudgeType intValue];
                switch (lnAlarmStatus) {
                    case 0:
                    {   lpObj = @"正常";}
                        break;
                    case 1:
                    {  lpObj = @"报警";
                        cell.backgroundColor =[ [[UIColor alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:1.0]autorelease];
                    }
                        break;
                    case 2:
                    {  lpObj = @"危险";
                        cell.backgroundColor =[ [[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]autorelease];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
            break;
        case 1:
            switch (indexPath.row) {
                case 2:
                    lpTitle = @"高高报线";
                    lpObj = [self.m_pChannInfo objectForKey:@"HL"];
                    break;
                case 3:
                    lpTitle = @"高低报线";
                    lpObj = [self.m_pChannInfo objectForKey:@"HL"];
                    
                    break;
                case 4:
                    lpTitle = @"低低报线";
                    lpObj = [self.m_pChannInfo objectForKey:@"LL"];
                    
                    break;
                case 5:
                    lpTitle = @"低高报线";
                    lpObj = [self.m_pChannInfo objectForKey:@"LH"];
                    
                    break;
                case 0:
                    lpTitle = @"当 前 值";
                    lpObj = [self.m_pChannInfo objectForKey:@"val"];
                    break;
                case 1:
                    lpTitle = @"报警状态";
                    lpObj = [self.m_pChannInfo objectForKey:@"alarm_status"];
                    int lnAlarmStatus = [(NSNumber *)lpObj intValue];
                    switch (lnAlarmStatus) {
                        case 0:
                            lpObj = @"正常";
                            break;
                        case 1:
                            lpObj = @"报警";
                            break;
                        case 2:
                            lpObj = @"危险";
                            break;
                        default:
                            break;
                    }
                default:
                    break;
            }
        default:
            break;
    }
    
    if (nil!= lpObj)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",lpTitle,lpObj ];
        
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    return;
    
}


- (void)dealloc {
    [_m_oNavigateButton release];
    [super dealloc];
}
- (IBAction)onButtonPressed:(UIBarButtonItem *)sender {
    
    LYWaveViewController * lpChannView = nil;
    LYTrendViewController * lpTrendView = nil;
    
    UIStoryboard *mainStoryboard = nil;
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                               bundle: nil];
#ifdef DEBUG
    NSLog(@"%@",lpChannView.m_pStrGroup);
#endif
    int lnChanntype  = [self GetChanntype];
    lnChanntype = [LYBHUtility GetChannType:lnChanntype];
    switch (lnChanntype)
    {
        case E_TBL_CHANNTYPE_VIB:
        case E_TBL_CHANNTYPE_DYN:
            lpChannView =(LYWaveViewController *)[mainStoryboard
                                                  instantiateViewControllerWithIdentifier: @"LYWaveViewController"];;
            lpChannView.m_pStrGroup = self.m_pStrGroup;
            lpChannView.m_pStrCompany = self.m_pStrCompany;
            lpChannView.m_pStrFactory = self.m_pStrFactory;
            lpChannView.m_pStrChann = self.m_pStrChann;
            lpChannView.m_pStrPlant = self.m_pStrPlant;
            lpChannView.m_nChannType = self.m_nChannType;
            lpChannView.m_pStrChannUnit = self.m_pStrChannUnit;
            lpChannView.m_fHH = self.m_fHH;
            lpChannView.m_fHL = self.m_fHL;
            lpChannView.m_fLL = self.m_fLL;
            lpChannView.m_fLH = self.m_fLH;
            lpChannView.m_nAlarmJudgetType = self.m_nAlarmJudgeType;
            lpChannView.m_pChannInfo = self.m_pChannInfo;
            lpChannView.m_nPlantType = self.m_nPlantType;
            [self.navigationController pushViewController:lpChannView animated:YES];
            break;
        case E_TBL_CHANNTYPE_PROC:
            
            
            lpTrendView =(LYTrendViewController *)[mainStoryboard
                                                   instantiateViewControllerWithIdentifier: @"LYTrendViewController"];
            lpTrendView.m_pStrGroup = self.m_pStrGroup;
            lpTrendView.m_pStrCompany = self.m_pStrCompany;
            lpTrendView.m_pStrFactory = self.m_pStrFactory;
            lpTrendView.m_pStrChann = self.m_pStrChann;
            lpTrendView.m_pStrPlant = self.m_pStrPlant;
            lpTrendView.m_nChannType = self.m_nChannType;
            lpTrendView.m_pStrChannUnit = self.m_pStrChannUnit;
            lpTrendView.m_fHH = self.m_fHH;
            lpTrendView.m_fHL = self.m_fHL;
            lpTrendView.m_fLL = self.m_fLL;
            lpTrendView.m_fLH = self.m_fLH;
            lpChannView.m_nPlantType = self.m_nPlantType;
            lpTrendView.m_pChannInfo = self.m_pChannInfo;
            lpTrendView.m_nAlarmJudgetType = self.m_nAlarmJudgeType;
            [self.navigationController pushViewController:lpTrendView animated:YES];
            
            break;
        default:
            break;
    }
    
    
}
@end
