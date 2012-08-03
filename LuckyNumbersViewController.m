//
//  LuckyNumbersViewController.m
//  LuckyNumbers
//
//  Created by Dan Grigsby on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "LuckyNumbersViewController.h"
#import "JSON/JSON.h"





@implementation LuckyNumbersViewController
@synthesize m_oActivityProgressbar;
@synthesize m_oTableView;
@synthesize m_pNavViewController;

- (void)viewDidLoad {	
	[super viewDidLoad];

	responseData = [[NSMutableData data] retain];		
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bhxz808.3322.org:8090/xapi/alarm/gethierarchy/?MIDDLE_WARE_IP=222.199.224.145&MIDDLE_WARE_PORT=7005&SERVER_TYPE=1&companyid=%E5%A4%A7%E5%BA%86%E7%9F%B3%E5%8C%96&factoryid=%E5%8C%96%E5%B7%A5%E4%B8%80%E5%8E%82&setid=&plantid=EC1301&pointname=2H&confirmtype=1&password="]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];			
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
	//NSLog(@"%s",[responseString2 cString] );
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
	self->listOfItems = [json objectWithString:responseString error:&error];
	[responseString release];	
    
    for (int i=0;i<[listOfItems count];i++) 
    {
        id logroupid = [[listOfItems objectAtIndex:i] objectForKey:@"groupid"];
        id locompanyid = [[listOfItems objectAtIndex:i] objectForKey:@"companyid"]; 
        id lofactoryid = [[listOfItems objectAtIndex:i] objectForKey:@"factoryid"];
        id loplantid = [[listOfItems objectAtIndex:i] objectForKey:@"plantid"]; 
        NSMutableString *lpStrGroupNo = [NSMutableString stringWithString:@" "];;
        [lpStrGroupNo appendFormat:@"%@-%@-%@",logroupid,locompanyid,lofactoryid];
        NSString * lpResult = [lpStrGroupNo substringFromIndex:0];  
        lpResult  = [[lpResult
                  stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",lpResult);
    }
	
	if (listOfItems == nil)
	{
        
        label.text = [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
    }
	else
    {
		

        
        self.m_oActivityProgressbar.hidesWhenStopped = TRUE;
        label.text = @"";
        [self.m_oActivityProgressbar stopAnimating];
        

        
        //2. load view
        if (nil == self->m_pPlantViewController) 
        {
            
            self->m_pPlantViewController = [[[LyPlantViewController alloc] init]autorelease];            
            self.m_pNavViewController = [[[LYNVController alloc]init] autorelease];
            self->m_pPlantViewController->listOfItems = self->listOfItems;
            [self->m_pPlantViewController->listOfItems retain];
            [self presentViewController:self.m_pNavViewController animated:YES completion:nil];
            [self.m_pNavViewController pushViewController:self->m_pPlantViewController animated:YES];
             
        }

	}
}



- (void)dealloc {
    [m_oTableView release];
    [m_oActivityProgressbar release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setM_oTableView:nil];
    [self setM_oActivityProgressbar:nil];
    [super viewDidUnload];
}
@end
