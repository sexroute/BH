//
//  LYFilterViewController.m
//  bh
//
//  Created by zhaodali on 13-3-12.
//
//

#import "LYFilterViewController.h"
#import "LYGlobalSettings.h"
#import "LYUtility.h"
#import "LYSelectItemViewController.h"

@interface LYFilterViewController ()

@end

@implementation LYFilterViewController

@synthesize m_oCompanys;
@synthesize m_oFactorys;
@synthesize m_oSets;
@synthesize m_oPlantTypes;
@synthesize m_oAllItems;

@synthesize m_strSelectedCompany;
@synthesize m_strSelectedFactory;
@synthesize m_strSelectedGroup;
@synthesize m_strSelectedSet;
@synthesize m_strSelectedType;
@synthesize m_StrSelectedInSelectItemViewController;

@synthesize m_oPlantPool;

NSString * G_NO_SELECTED_VALUE_STR = @"";
NSString * G_NO_SELECTED_VALUE_STR_DISPLAY = @"全部";
#pragma mark 初始化
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

-(void) InitData
{
    self.m_strSelectedGroup = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_GROUP];
    self.m_strSelectedCompany = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_COMPANY];
    self.m_strSelectedFactory = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_FACTORY];
    self.m_strSelectedSet = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_SET];
    self.m_strSelectedType = [LYGlobalSettings GetSettingString:SETTING_KEY_SELECTED_PLANT_TYPE];
    
    self.m_oPlantPool = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.m_oGroups = [NSMutableArray arrayWithCapacity:0];
    self.m_oCompanys = [NSMutableArray arrayWithCapacity:0];
    self.m_oFactorys = [NSMutableArray arrayWithCapacity:0];
    self.m_oSets = [NSMutableArray arrayWithCapacity:0];
    self.m_oPlantTypes = [NSMutableArray arrayWithCapacity:0];
}

- (id) init
{
    self = [super init];
    return  self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self InitData];
    [self PrepareData];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)toogleDataForPerSection:(NSMutableArray *)apData  apLabel:(UILabel *)apLabel apSelectedStr:(NSString *)apSelectedStr
{
    if (nil == apLabel)
    {
        return;
    }
    
    if ([LYUtility IsStringEmpty:apSelectedStr])
    {
        apLabel.text = G_NO_SELECTED_VALUE_STR_DISPLAY;
        
    }else
    {
        apLabel.text = apSelectedStr;
    }
}

-(void)toogleCellUI:(UITableViewCell*)apCell  apLabel:(UILabel *)apLabel  apSelectedStr:(NSString *)apSelectedStr
{
    if (nil == apLabel || nil == apCell)
    {
        return;
    }
    
    if ([LYUtility IsStringEmpty:apSelectedStr])
    {
        apCell.selectionStyle = UITableViewCellSelectionStyleNone;
        apCell.userInteractionEnabled = NO;
        [apCell setBackgroundColor:[UIColor colorWithRed:0xc0/255.0 green:0xc0/255.0 blue:0xc0/255.0 alpha:1]];
        apCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        apCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        apCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        apCell.userInteractionEnabled = YES;
        [apCell setBackgroundColor:[UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1]];
    }
}

-(void)toogleData
{
    //group
    [self toogleDataForPerSection:self.m_oGroups apLabel:self.m_olblGroup apSelectedStr:self.m_strSelectedGroup];
    
    //company
    [self toogleCellUI:self.m_oCellCompany apLabel:self.m_olblCompany apSelectedStr:self.m_strSelectedGroup];
    [self toogleDataForPerSection:self.m_oCompanys apLabel:self.m_olblCompany apSelectedStr:self.m_strSelectedCompany];
    
    
    //factory
    [self toogleCellUI:self.m_oCellFactory apLabel:self.m_olblFactory apSelectedStr:self.self.m_strSelectedCompany];
    [self toogleDataForPerSection:self.m_oFactorys apLabel:self.m_olblFactory apSelectedStr:self.m_strSelectedFactory];
    
    //set
    [self toogleCellUI:self.m_oCellSet apLabel:self.m_olblSet apSelectedStr:self.m_strSelectedFactory];
    [self toogleDataForPerSection:self.m_oSets apLabel:self.m_olblSet apSelectedStr:self.m_strSelectedSet];
    
    //type
    [self toogleDataForPerSection:self.m_oPlantTypes apLabel:self.m_olblType apSelectedStr:self.m_strSelectedType];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self toogleData];
}

#pragma mark 页面出口-导航到筛选列表

-(NSMutableArray *) GetCurrentPoolItems:(int) anType
{
    
    NSMutableArray * lpTemp = [NSMutableArray arrayWithCapacity:0];
    [lpTemp addObject:G_NO_SELECTED_VALUE_STR_DISPLAY];
    NSMutableDictionary * lpTempCompanys = nil;
    NSMutableDictionary * lpTempFactorys = nil;
    NSMutableDictionary * lpTempSets = nil;
    
    switch (anType)
    {
        case 0:
            
            [lpTemp addObjectsFromArray: self.m_oPlantPool.allKeys];
            break;
            
        case 1:
            lpTempCompanys = [self.m_oPlantPool objectForKey:self.m_strSelectedGroup];
            if (nil != lpTempCompanys)
            {
                [lpTemp addObjectsFromArray: lpTempCompanys.allKeys];
            }
            break;
            
            
        case 2:
            lpTempCompanys = [self.m_oPlantPool objectForKey:self.m_strSelectedGroup];
            if (nil != lpTempCompanys)
            {
                lpTempFactorys = [lpTempCompanys objectForKey:self.m_strSelectedCompany];
                if (nil!=lpTempFactorys)
                {
                    [lpTemp addObjectsFromArray: lpTempFactorys.allKeys];
                }
            }
            break;
            
        case 3:
            lpTempCompanys = [self.m_oPlantPool objectForKey:self.m_strSelectedGroup];
            if (nil != lpTempCompanys)
            {
                lpTempFactorys = [lpTempCompanys objectForKey:self.m_strSelectedCompany];
                if (nil!=lpTempFactorys)
                {
                    lpTempSets = [lpTempFactorys objectForKey:self.m_strSelectedFactory];
                    if (nil!= lpTempSets)
                    {
                        
                        [lpTemp addObjectsFromArray: lpTempSets.allKeys];
                    }
                }
            }
            break;
            
        case 4:
            [lpTemp addObject:@"往复"];
            [lpTemp addObject:@"旋转"];
            [lpTemp addObject:@"机泵"];
            [lpTemp addObject:@"风电"];
       
            break;
        default:
            break;
    }
    
    return lpTemp;
}

-(void) UpdatePlantpoolSelectionResult
{
    self.m_oGroups = [self GetCurrentPoolItems:0];
    self.m_oCompanys = [self GetCurrentPoolItems:1];
    self.m_oFactorys = [self GetCurrentPoolItems:2];
    self.m_oSets = [self GetCurrentPoolItems:3];
    self.m_oPlantTypes = [self GetCurrentPoolItems:4];
    
}


- (void)PrepareNavigateToItemSelect:(int) anSectionIndex anRowIndex:(int) anRowIndex
{
    self.m_nFilterType = anSectionIndex;
    [self UpdatePlantpoolSelectionResult];
    
    switch (anSectionIndex)
    {
        case 0:
            [self NavigateToSelectedPage:self.m_oGroups apstrSeletedItem:self.m_strSelectedGroup  apstrTitle:@"选择集团"];
            break;
        case 1:
            
            [self NavigateToSelectedPage:self.m_oCompanys apstrSeletedItem:self.m_strSelectedCompany apstrTitle:@"选择公司"];
            break;
        case 2:
            
            [self NavigateToSelectedPage:self.m_oFactorys apstrSeletedItem:self.m_strSelectedFactory apstrTitle:@"选择分厂"];
            break;
        case 3:
            [self NavigateToSelectedPage:self.m_oSets apstrSeletedItem:self.m_strSelectedSet apstrTitle:@"选择装置"];
            break;
        case 4:
            [self NavigateToSelectedPage:self.m_oPlantTypes apstrSeletedItem:self.m_strSelectedType apstrTitle:@"选择设备类型"];
            break;
        default:
            break;
    }
}

-(void)NavigateToSelectedPage:(NSMutableArray *)apData apstrSeletedItem:(NSString *)apstrSeletedItem  apstrTitle:(NSString*)apstrTitle
{
    if (nil == apData )
    {
        return;
    }
    apstrSeletedItem = [LYUtility StringTrim:apstrSeletedItem];
    UIStoryboard *mainStoryboard = self.storyboard;
    LYSelectItemViewController * lpViewController = (LYSelectItemViewController*)[mainStoryboard
                                                                                  instantiateViewControllerWithIdentifier: @"LYSelectItemViewController"];
    self.navigationItem.backBarButtonItem.title = @"确认";
    
    lpViewController.title = apstrTitle;
    lpViewController.m_oItems = apData;
    
    lpViewController.m_nSelectedIndex = 0;
    lpViewController.m_pParent = self;
    for (int i=0; i<apData.count; i++)
    {
        NSString * lpItem = [apData objectAtIndex:i];
        lpItem = [LYUtility StringTrim:lpItem];
        if ([apstrSeletedItem compare:lpItem options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            lpViewController.m_nSelectedIndex = i;
            
            break;
        }
    }
    
    [self.navigationController pushViewController:lpViewController animated:YES];
    
}

- (void)PrepareData
{
    if (nil!= self.m_oAllItems)
    {
        
        
        for (int i =0; i<self.m_oAllItems.count ; i++)
        {
            id logroupid = [[self.m_oAllItems objectAtIndex:i] objectForKey:@"groupid"];
            id locompanyid = [[self.m_oAllItems objectAtIndex:i] objectForKey:@"companyid"];
            id lofactoryid = [[self.m_oAllItems objectAtIndex:i] objectForKey:@"factoryid"];
            id losetid = [[self.m_oAllItems objectAtIndex:i] objectForKey:@"setid"];
            
            if (nil == logroupid || !([logroupid isKindOfClass:[NSString class]]))
            {
                continue;
            }
            
            if (nil == locompanyid || !([locompanyid isKindOfClass:[NSString class]]))
            {
                continue;
            }
            
            if (nil == lofactoryid || !([lofactoryid isKindOfClass:[NSString class]]))
            {
                continue;
            }
            
            if (nil == losetid || !([losetid isKindOfClass:[NSString class]]))
            {
                continue;
            }
            
            logroupid = [((NSString*) logroupid) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            locompanyid = [((NSString*) locompanyid) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            lofactoryid = [((NSString*) lofactoryid) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            losetid = [((NSString*) losetid) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary * lpCompany = [self.m_oPlantPool objectForKey:logroupid];
            NSMutableDictionary * lpFactory = nil;
            NSMutableDictionary * lpSet     = nil;
            NSMutableDictionary * lpPlant     = nil;
            
            if (nil == lpCompany)
            {
                lpCompany = [NSMutableDictionary dictionaryWithCapacity:0];
                [self.m_oPlantPool setObject:lpCompany forKey:logroupid];
                
            }else
            {
                lpFactory = [lpCompany objectForKey:locompanyid];
                if (nil == lpFactory)
                {
                    lpFactory = [NSMutableDictionary dictionaryWithCapacity:0];
                    [lpCompany setObject:lpFactory forKey:locompanyid];
                }
                
                lpSet =  [lpFactory objectForKey:lofactoryid];
                
                if (nil == lpSet)
                {
                    lpSet = [NSMutableDictionary dictionaryWithCapacity:0];
                    [lpFactory setObject:lpSet forKey:lofactoryid];
                }
                
                lpPlant =  [lpSet objectForKey:losetid];
                
                if (nil == lpPlant)
                {
                    lpPlant = [NSMutableDictionary dictionaryWithCapacity:0];
                    [lpSet setObject:lpPlant forKey:losetid];
                }
                
            }
            
        }
        [self.m_oGroups removeAllObjects];
        [self.m_oCompanys removeAllObjects];
        [self.m_oFactorys removeAllObjects];
        [self.m_oSets removeAllObjects];
        [self.m_oPlantTypes removeAllObjects];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SaveSelectedItem
{
    switch (self.m_nFilterType)
    {
        case 0:
            if ([self.m_StrSelectedInSelectItemViewController compare:G_NO_SELECTED_VALUE_STR_DISPLAY] == NSOrderedSame)
            {
                self.m_StrSelectedInSelectItemViewController = @"";
            }
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_GROUP apVal:self.m_StrSelectedInSelectItemViewController];
            self.m_strSelectedGroup = self.m_StrSelectedInSelectItemViewController;
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_GROUP apVal:self.m_strSelectedGroup];
            
            self.m_strSelectedCompany = G_NO_SELECTED_VALUE_STR;
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_FACTORY apVal:self.m_strSelectedCompany];
            
            self.m_strSelectedFactory = G_NO_SELECTED_VALUE_STR;
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_FACTORY apVal:self.m_strSelectedFactory];
            
            self.m_strSelectedSet = G_NO_SELECTED_VALUE_STR;
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_FACTORY apVal:self.m_strSelectedSet];
            
            
            break;
        case 1:
            if ([self.m_StrSelectedInSelectItemViewController compare:G_NO_SELECTED_VALUE_STR_DISPLAY] == NSOrderedSame)
            {
                self.m_StrSelectedInSelectItemViewController = @"";
            }
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_COMPANY apVal:self.m_StrSelectedInSelectItemViewController];
            self.m_strSelectedCompany = self.m_StrSelectedInSelectItemViewController;
           
            self.m_strSelectedFactory = G_NO_SELECTED_VALUE_STR;
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_FACTORY apVal:self.m_strSelectedFactory];
            
            self.m_strSelectedSet = G_NO_SELECTED_VALUE_STR;
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_FACTORY apVal:self.m_strSelectedSet];
            
            break;
        case 2:
            if ([self.m_StrSelectedInSelectItemViewController compare:G_NO_SELECTED_VALUE_STR_DISPLAY] == NSOrderedSame)
            {
                self.m_StrSelectedInSelectItemViewController = @"";
            }
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_FACTORY apVal:self.m_StrSelectedInSelectItemViewController];
            self.m_strSelectedFactory = self.m_StrSelectedInSelectItemViewController;
            
            self.m_strSelectedSet = G_NO_SELECTED_VALUE_STR;
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_FACTORY apVal:self.m_strSelectedSet];
            
            break;
        case 3:
            if ([self.m_StrSelectedInSelectItemViewController compare:G_NO_SELECTED_VALUE_STR_DISPLAY] == NSOrderedSame)
            {
                self.m_StrSelectedInSelectItemViewController = @"";
            }
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_SET apVal:self.m_StrSelectedInSelectItemViewController];
            self.m_strSelectedSet = self.m_StrSelectedInSelectItemViewController;
            
            break;
        case 4:
            if ([self.m_StrSelectedInSelectItemViewController compare:G_NO_SELECTED_VALUE_STR_DISPLAY] == NSOrderedSame)
            {
                self.m_StrSelectedInSelectItemViewController = @"";
            }
            [LYGlobalSettings SetSettingString:SETTING_KEY_SELECTED_PLANT_TYPE apVal:self.m_StrSelectedInSelectItemViewController];
            self.m_strSelectedType = self.m_StrSelectedInSelectItemViewController;
            
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source



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
    [self PrepareNavigateToItemSelect:indexPath.section anRowIndex:indexPath.row];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self PrepareNavigateToItemSelect:indexPath.section anRowIndex:indexPath.row];
    
}

#pragma mark - 析构

- (void)dealloc {
    [_m_olblGroup release];
    [_m_oCellGroup release];
    [_m_olblCompany release];
    [_m_oCellCompany release];
    [_m_olblFactory release];
    [_m_oCellFactory release];
    [_m_olblSet release];
    [_m_oCellSet release];
    [_m_oCellType release];
    [_m_olblType release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_olblGroup:nil];
    [self setM_oCellGroup:nil];
    [self setM_olblCompany:nil];
    [self setM_oCellCompany:nil];
    [self setM_olblFactory:nil];
    [self setM_oCellFactory:nil];
    [self setM_olblSet:nil];
    [self setM_oCellSet:nil];
    [self setM_oCellType:nil];
    [self setM_olblType:nil];
    
    self.m_oGroups = nil;
    self.m_oCompanys = nil;
    self.m_oFactorys = nil;
    self.m_oSets = nil;
    self.m_oPlantTypes = nil;
    
    self.m_strSelectedGroup = nil;
    self.m_strSelectedCompany = nil;
    self.m_strSelectedFactory = nil;
    self.m_strSelectedSet = nil;
    self.m_strSelectedType = nil;
    
    self.m_oAllItems = nil;
    
    [super viewDidUnload];
}
@end
