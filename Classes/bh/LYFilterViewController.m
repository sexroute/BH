//
//  LYFilterViewController.m
//  bh
//
//  Created by zhaodali on 13-3-12.
//
//

#import "LYFilterViewController.h"

@interface LYFilterViewController ()

@end

@implementation LYFilterViewController

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
- (void)navigateToItemSelection:(int) anSectionIndex anRowIndex:(int) anRowIndex
{
    
}


-(void)viewDidAppear:(BOOL)animated
{
//    self.m_oCellGroup.textLabel.text = @"集团:";
//    self.m_oCellCompany.textLabel.text = @"公司";
//    self.m_oCellFactory.textLabel.text = @"分厂";
//    self.m_oCellSet.textLabel.text =@"装置";
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
    [super viewDidUnload];
}
@end
