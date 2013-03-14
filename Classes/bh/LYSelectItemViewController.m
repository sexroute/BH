//
//  LYSelectItemViewController.m
//  bh
//
//  Created by zhaodali on 13-3-13.
//
//

#import "LYSelectItemViewController.h"
#import "LYFilterViewController.h"

@interface LYSelectItemViewController ()

@end


@implementation LYSelectItemViewController

@synthesize m_oItems;


#pragma mark 初始化
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int lnRowCount = 0;
    if (nil!=self.m_oItems)
    {
        lnRowCount = self.m_oItems.count;
    }
    return lnRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    cell.textLabel.text = [self.m_oItems objectAtIndex: indexPath.row];
    
    if (indexPath.row == self.m_nSelectedIndex)
    {
         cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

    return cell;
}
//处理选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.更新选中状态
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
    self.m_nSelectedIndex = indexPath.row;
    if (cellView.accessoryType == UITableViewCellAccessoryNone)
    {
        cellView.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cellView.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    [self.tableView beginUpdates];
    NSArray *paths = [self.tableView indexPathsForVisibleRows];
    [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    //2.存储选中数据
    LYFilterViewController * lpVal = (LYFilterViewController *)self.m_pParent;
    
    if (nil!= lpVal && [lpVal isKindOfClass:[LYFilterViewController class]])
    {
        lpVal.m_StrSelectedInSelectItemViewController = cellView.textLabel.text;
        [lpVal SaveSelectedItem];
    }
}


#pragma mark - Table view delegate





@end
