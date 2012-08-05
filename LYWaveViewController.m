//
//  LYWaveViewController.m
//  bh
//
//  Created by zhao on 12-8-5.
//
//

#import "LYWaveViewController.h"

@interface LYWaveViewController ()

@end

@implementation LYWaveViewController
@synthesize hostView;
@synthesize m_pChartViewParent;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - Chart behavior
-(void)initPlot {
    
    self.hostView = [[LYChartView alloc] init];
    
    //self.hostView.bounds = self.m_pChartViewParent.bounds;
    self.hostView.m_pParent = self.view;
    [self.hostView initGraph];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initPlot];
}

- (void)viewDidUnload
{
    [self setHostView:nil];
    [self setM_pChartViewParent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {

    [hostView release];
    [m_pChartViewParent release];
    [super dealloc];
}
@end
