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
    NSLog(@"%f", cell.contentView.frame.size.width);
}
- (void)viewDidLoad
{
    [super viewDidLoad];


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
    self.m_olabelUserName.text = [LYGlobalSettings GetSetting:SETTING_KEY_USER];
    
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
    NSLog(@"logOut");
    //1.将登录状态设置为0
    [LYGlobalSettings SetSetting:SETTING_KEY_LOGIN apVal:@"0"];
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


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

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
