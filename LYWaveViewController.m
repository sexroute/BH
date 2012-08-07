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

@synthesize m_pStrGroup;
@synthesize m_pStrCompany;
@synthesize m_pStrFactory;
@synthesize m_pStrChann;
@synthesize m_pStrPlant;

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
    
    self.hostView = [[[LYChartView alloc] init]autorelease];
    NSLog(@"%d",hostView.retainCount);

    //self.hostView.bounds = self.m_pChartViewParent.bounds;
    self.hostView.m_pStrCompany = self.m_pStrCompany;
    self.hostView.m_pStrFactory = self.m_pStrFactory;
    self.hostView.m_pStrPlant = self.m_pStrPlant;
    self.hostView.m_pStrChann = [self.m_pStrChann stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.hostView.m_pParent = self.view;
    [self.hostView initGraph];
    NSLog(@"%d",hostView.retainCount);

    
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

    NSLog(@"%d",hostView.retainCount);
    [hostView release];
    [m_pChartViewParent release];
    [super dealloc];
}
@end
