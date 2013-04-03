//
//  DetailViewController.m
//  bh
//
//  Created by Li Yan on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LYDetailViewController.h"
#import "LYChannViewController.h"
#import "LYBHUtility.h"

@interface LYDetailViewController ()

@end



@implementation LYDetailViewController


@synthesize m_pData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
    //1.组织结构信息
    //2.设备状态
    //3.设备信息
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"组织结构信息", @"Orgnization Info");
            break;
        case 1:
            title = NSLocalizedString(@"设备状态", @"Plant Status");
            break;
        case 2:
            title = NSLocalizedString(@"设备信息", @"Plant Info");
            break;
        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        
    }
    
    id lpText = nil;
    
    NSString * lpTitle = nil;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    lpText = [ self.m_pData objectForKey:@"plantid"];
                    lpTitle =@"设备:";
                    break;
                case 1:
                    lpText = [ self.m_pData objectForKey:@"setid"];
                    lpTitle =@"装置:";
                    break;
                case 2:
                    lpText = [ self.m_pData objectForKey:@"factoryid"];
                    lpTitle =@"分厂:";
                    break;
                case 3:
                    lpText = [ self.m_pData objectForKey:@"companyid"];
                    lpTitle =@"公司:";
                    break;
                case 4:
                    lpText = [ self.m_pData objectForKey:@"groupid"];
                    lpTitle =@"集团:";
                    break;
                default:
                    
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    lpText = [ self.m_pData objectForKey:@"rev"];
                    int lnRev = [lpText intValue];
                    if (lnRev<0)
                    {
                        lpText = @"0";
                    }
                    lpTitle =@"转速:";
                    break;
                case 1:
                    lpText = [ self.m_pData objectForKey:@"alarm_status"];
                    int lnNetOffStatus =[ [ self.m_pData objectForKey:@"netoff_status"]intValue];
                    int lnStopStatus = [ [ self.m_pData objectForKey:@"stop_status"]intValue];
                    
                    lpTitle =@"设备状态:";
                    
                    if (lnNetOffStatus>0)
                    {
                        lpText = @"断网";
                    }else if(lnStopStatus>0)
                    {
                        lpText = @"停车";
                    }else
                    {
                        NSString * lpData = [lpText description];
                        if( [lpData isEqualToString: @"2"])
                        {
                            lpText = @"危险";
                            cell.textLabel.textColor = [UIColor redColor];
                            
                        }else if([lpData isEqualToString: @"1"])
                        {
                            lpText = @"报警";
                            cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.6 blue:0 alpha:1];
                            
                        }else if([lpData isEqualToString: @"0"])
                        {
                            lpText = @"正常";
                        }
                    }
                    
                    break;
                case 2:
                    lpText = [ self.m_pData objectForKey:@"smpfreq"];
                    lpTitle =@"采样频率:";
                    break;
                case 3:
                    lpText = [ self.m_pData objectForKey:@"smpnum"];
                    lpTitle =@"采样点:";
                    break;
                    
                default:
                    
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    lpText = [ self.m_pData objectForKey:@"manufacturer"];
                    lpTitle =@"制造商:";
                }
                    break;
                case 1:
                {
                    lpText = [ self.m_pData objectForKey:@"machine_type"];
                    NSString * lpData = [lpText description];
                    if (nil!= lpData)
                    {
                        int lnMachineType = [lpData intValue];
                        
                        NSString * lpPlantType = [LYBHUtility GetPlantTypeName:lnMachineType];
                        
                        lpText = [NSString stringWithFormat:@"%@设备",lpPlantType];
                    }
                    
                    lpTitle =@"设备类型:"; }
                    break;
                case 2:
                {
                    
                    lpText = [ self.m_pData objectForKey:@"smpfreq"];
                    lpTitle =@"采样点:";
                }
                    break;
                    
                case 3:
                {
                    lpText = [ self.m_pData objectForKey:@"smpnum"];
                    lpTitle =@"采样点:";
                }
                    
                    break;
                    
                default:
                    
                    break;
            }
            break;
        default:
            
            break;
    }
    
    NSMutableString *lpStrGroupNo = [NSMutableString stringWithString:@" "];;
    [lpStrGroupNo appendFormat:@"%@ %@",lpTitle,lpText];
    NSString * lpResult = [lpStrGroupNo substringFromIndex:0];
    lpResult  = [[lpResult
                  stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    cell.textLabel.text = lpResult;
    
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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    /*
     DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc {
    
    
    [super dealloc];
}
//Segue begin
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //    NSString *Title;
#ifdef DEBUG
    NSLog(@"%@",[segue identifier]);
#endif
    if ([[segue identifier] isEqualToString:@"SegueToChann"])
    {
        
        LYChannViewController * lpChannView = [segue destinationViewController];
        lpChannView.m_pStrGroup = [NSString stringWithString: [ self.m_pData objectForKey:@"groupid"]];
        lpChannView.m_pStrCompany = [NSString stringWithString: [ self.m_pData objectForKey:@"companyid"]];
        lpChannView.m_pStrFactory = [NSString stringWithString: [ self.m_pData objectForKey:@"factoryid"]];
        lpChannView.m_pStrSet = [NSString stringWithString: [ self.m_pData objectForKey:@"setid"]];
        lpChannView.m_pStrPlant = [NSString stringWithString: [ self.m_pData objectForKey:@"plantid"]];
        NSString * lpMachinetype =[ self.m_pData objectForKey:@"machine_type"];
        
        lpChannView.m_nPlantType = [[ self.m_pData objectForKey:@"machine_type"]intValue];
        
        
    }
    
}
@end
