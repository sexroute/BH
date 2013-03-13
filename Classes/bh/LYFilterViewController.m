//
//  LYFilterViewController.m
//  bh
//
//  Created by zhaodali on 13-3-12.
//
//

#import "LYFilterViewController.h"
#import "LYGlobalSettings.h"

@interface LYFilterViewController ()

@end

@implementation LYFilterViewController

@synthesize m_oGroups;
@synthesize m_oCompany;
@synthesize m_oFactory;
@synthesize m_oSet;
@synthesize m_oType;

const int G_NO_SELECTED_VALUE = 0;
 NSString * G_NO_SELECTED_VALUE_STR = @"全部";
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
    self.m_nSelectGroupIndex= [LYGlobalSettings GetSettingInt:SETTING_KEY_SELECTED_GROUP anDefault:G_NO_SELECTED_VALUE];
    self.m_nSelectFactoryIndex =[LYGlobalSettings GetSettingInt:SETTING_KEY_SELECTED_COMPANY anDefault:G_NO_SELECTED_VALUE] ;
    self.m_nSelectCompanyIndex =[LYGlobalSettings GetSettingInt:SETTING_KEY_SELECTED_FACTORY anDefault:G_NO_SELECTED_VALUE];
    self.m_nSelectSetIndex = [LYGlobalSettings GetSettingInt:SETTING_KEY_SELECTED_SET anDefault:G_NO_SELECTED_VALUE];
    
    self.m_oGroups = [NSMutableArray arrayWithCapacity:0];
    self.m_oCompany = [NSMutableArray arrayWithCapacity:0];
    self.m_oFactory = [NSMutableArray arrayWithCapacity:0];
    self.m_oSet = [NSMutableArray arrayWithCapacity:0];
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
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)toogleDataForPerSection:(NSMutableArray *)apData  apLabel:(UILabel *)apLabel anSelectedIndex:(int)anSelectedIndex
{
    if (nil == apLabel)
    {
        return;
    }
   
    if (G_NO_SELECTED_VALUE == anSelectedIndex || apData == nil || anSelectedIndex <0 || anSelectedIndex >= [apData count])
    {
        apLabel.text = G_NO_SELECTED_VALUE_STR;
    }else
    {
        apLabel.text = [apData objectAtIndex:anSelectedIndex];
    }
}

-(void)toogleCellUI:(UITableViewCell*)apCell  apLabel:(UILabel *)apLabel  anSelectedIndex:(int)anSelectedIndex
{
    if (nil == apLabel || nil == apCell)
    {
        return;
    }
    
    if (anSelectedIndex == G_NO_SELECTED_VALUE)
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
    }
}

-(void)toogleData
{
    //group
    [self toogleDataForPerSection:self.m_oGroups apLabel:self.m_olblGroup anSelectedIndex:self.m_nSelectGroupIndex];
    
    //company
    [self toogleCellUI:self.m_oCellCompany apLabel:self.m_olblCompany anSelectedIndex:self.m_nSelectGroupIndex];
    [self toogleDataForPerSection:self.m_oCompany apLabel:self.m_olblCompany anSelectedIndex:self.m_nSelectCompanyIndex];
    

    //factory
    [self toogleCellUI:self.m_oCellFactory apLabel:self.m_olblFactory anSelectedIndex:self.m_nSelectCompanyIndex];
    [self toogleDataForPerSection:self.m_oFactory apLabel:self.m_olblFactory anSelectedIndex:self.m_nSelectFactoryIndex];
    
    //set
    [self toogleCellUI:self.m_oCellSet apLabel:self.m_olblSet anSelectedIndex:self.m_nSelectFactoryIndex];
    [self toogleDataForPerSection:self.m_oSet apLabel:self.m_olblSet anSelectedIndex:self.m_nSelectSetIndex];
    
 }

-(void)viewDidAppear:(BOOL)animated
{
    [self toogleData];
}

#pragma mark 页面出口-导航到筛选列表

- (void)navigateToItemSelection:(int) anSectionIndex anRowIndex:(int) anRowIndex
{
    switch (anSectionIndex) {
        case 0:
            [self NavigateToSelectedPage:self.m_oGroups anSelectedIndex:self.m_nSelectGroupIndex];
            break;
        case 1:
           [self NavigateToSelectedPage:self.m_oCompany anSelectedIndex:self.m_nSelectCompanyIndex];
            break;
        case 2:
            [self NavigateToSelectedPage:self.m_oFactory anSelectedIndex:self.m_nSelectFactoryIndex];
            break;
        case 3:
            [self NavigateToSelectedPage:self.m_oSet anSelectedIndex:self.m_nSelectSetIndex];
            break;
        default:
            break;
    }
}

-(void)NavigateToSelectedPage:(NSMutableArray *)apData anSelectedIndex:(int) anSelectedIndex
{
    if (nil == apData )
    {
        return;
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self navigateToItemSelection:indexPath.section anRowIndex:indexPath.row];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self navigateToItemSelection:indexPath.section anRowIndex:indexPath.row];

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
    [_m_oTypeCell release];
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
    [self setM_oTypeCell:nil];
    [self setM_olblType:nil];
    
    self.m_oGroups = nil;
    self.m_oCompany = nil;
    self.m_oFactory = nil;
    self.m_oSet = nil;
    self.m_oType = nil;
    
    [super viewDidUnload];
}
@end
