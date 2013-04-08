//
//  Chart.m
//  https://github.com/zhiyu/chartee/
//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 zhiyu. All rights reserved.
//

#import "Chart.h"

#define MIN_INTERVAL  3

@implementation Chart

@synthesize enableSelection;
@synthesize isInitialized;
@synthesize isSectionInitialized;
@synthesize borderColor;
@synthesize borderWidth;
@synthesize plotWidth;
@synthesize plotPadding;
@synthesize plotCount;
@synthesize paddingLeft;
@synthesize paddingRight;
@synthesize paddingTop;
@synthesize paddingBottom;
@synthesize padding;
@synthesize selectedIndex;
@synthesize touchFlag;
@synthesize touchFlagTwo;
@synthesize rangeFrom;
@synthesize rangeTo;
@synthesize range;
@synthesize series;
@synthesize sections;
@synthesize ratios;
@synthesize models;
@synthesize title;
@synthesize m_pStrFontName;
@synthesize m_bInMove;

@synthesize rangeFrom_original;
@synthesize rangeTo_original;

-(float)getLocalY:(float)val withSection:(int)sectionIndex withAxis:(int)yAxisIndex
{
	Section *sec = [[self sections] objectAtIndex:sectionIndex];
	YAxis *yaxis = [sec.yAxises objectAtIndex:yAxisIndex];
	CGRect fra = sec.frame;
	float  max = yaxis.max;
	float  min = yaxis.min;
    return fra.size.height - (fra.size.height-sec.paddingTop)* (val-min)/(max-min)+fra.origin.y;
}

-(float)GetDistance:(CGPoint )apPoint Section:(Section *)apSection anXIndex:(int)anIndex afYvalue:(float)afval withSection:(int)sectionIndex withAxis:(int)yAxisIndex
{
     float ix  = apSection.frame.origin.x+apSection.paddingLeft+(anIndex-self.rangeFrom)*self.plotWidth;
     float iy  = [self getLocalY:afval withSection:sectionIndex withAxis:yAxisIndex];
    NSLog(@"Point tested:Pressed(%f,%f) test(%f,%f) ",apPoint.x,apPoint.y,ix,iy);
    float lfDistance =  pow((ix-apPoint.x),2)+pow((iy-apPoint.y),2);
    return lfDistance;
}

- (void)initChart
{
	if(!self.isInitialized)
    {
		self.plotPadding = 1.f;
		if(self.padding != nil)
        {
			self.paddingTop    = [[self.padding objectAtIndex:0] floatValue];
			self.paddingRight  = [[self.padding objectAtIndex:1] floatValue];
			self.paddingBottom = [[self.padding objectAtIndex:2] floatValue];
			self.paddingLeft   = [[self.padding objectAtIndex:3] floatValue];
		}
		
		if(self.series!=nil)
        {
			self.rangeTo = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
			if(rangeTo-range >= 0)
            {
				self.rangeFrom = rangeTo-range;
			}else
            {
			    self.rangeFrom = 0;
			}
		}
        else
        {
			self.rangeTo   = 0;
			self.rangeFrom = 0;
		}
		self.selectedIndex = self.rangeTo-1;
		self.isInitialized = YES;
        
        self.rangeTo_original = self.rangeTo;
        self.rangeFrom_original = self.rangeFrom;
	}
    
	if(self.series!=nil)
    {
		self.plotCount = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
	}
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
    CGContextFillRect (context, CGRectMake (0, 0, self.bounds.size.width,self.bounds.size.height));
}

-(void)reset{
	self.isInitialized = NO;
}

- (void)initXAxis{
    
}

- (void)initYAxis
{
	for(int secIndex=0;secIndex<[self.sections count];secIndex++)
    {
		Section *sec = [self.sections objectAtIndex:secIndex];
		for(int sIndex=0;sIndex<[sec.yAxises count];sIndex++)
        {
			YAxis *yaxis = [sec.yAxises objectAtIndex:sIndex];
			yaxis.isUsed = NO;
		}
	}
	
	for(int secIndex=0;secIndex<[self.sections count];secIndex++)
    {
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.paging)
        {
            if (sec.selectedIndex >= [sec series].count)
            {
                continue;
                
            }
			NSObject *serie = [[sec series] objectAtIndex:sec.selectedIndex];
			if([serie isKindOfClass:[NSArray class]])
            {
				for(int i=0;i<[serie count];i++)
                {
					[self setValuesForYAxis:[serie objectAtIndex:i]];
				}
			}else
            {
				[self setValuesForYAxis:serie];
			}
		}else
        {
			for(int sIndex=0;sIndex<[sec.series count];sIndex++)
            {
				NSObject *serie = [[sec series] objectAtIndex:sIndex];
				if([serie isKindOfClass:[NSArray class]])
                {
					for(int i=0;i<[serie count];i++)
                    {
						[self setValuesForYAxis:[serie objectAtIndex:i]];
					}
				}else
                {
					[self setValuesForYAxis:serie];
				}
			}
		}
		
		for(int i = 0;i<sec.yAxises.count;i++)
        {
			YAxis *yaxis = [sec.yAxises objectAtIndex:i];
			yaxis.max += (yaxis.max-yaxis.min)*yaxis.ext;
			yaxis.min -= (yaxis.max-yaxis.min)*yaxis.ext;
			
			if(!yaxis.baseValueSticky)
            {
				if(yaxis.max >= 0 && yaxis.min >= 0)
                {
					yaxis.baseValue = yaxis.min;
				}else if(yaxis.max < 0 && yaxis.min < 0)
                {
					yaxis.baseValue = yaxis.max;
				}else
                {
					yaxis.baseValue = 0;
				}
			}else
            {
				if(yaxis.baseValue < yaxis.min)
                {
					yaxis.min = yaxis.baseValue;
				}
				
				if(yaxis.baseValue > yaxis.max)
                {
					yaxis.max = yaxis.baseValue;
				}
			}
			
			if(yaxis.symmetrical == YES)
            {
				if(yaxis.baseValue > yaxis.max)
                {
					yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
				}else if(yaxis.baseValue < yaxis.min)
                {
					yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
				}else
                {
					if((yaxis.max-yaxis.baseValue) > (yaxis.baseValue-yaxis.min))
                    {
						yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
					}else
                    {
						yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
					}
				}
			}
		}
	}
}

-(void)setValuesForYAxis:(NSDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model setValuesForYAxis:self serie:serie];
}

-(void)drawChart{
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
		    continue;
		}
		plotWidth = (sec.frame.size.width-sec.paddingLeft)/(self.rangeTo-self.rangeFrom);
		for(int sIndex=0;sIndex<sec.series.count;sIndex++){
			NSObject *serie = [sec.series objectAtIndex:sIndex];
			
			if(sec.hidden){
				continue;
			}
			
			if(sec.paging){
				if (sec.selectedIndex == sIndex) {
					if([serie isKindOfClass:[NSArray class]]){
						for(int i=0;i<[serie count];i++){
							[self drawSerie:[serie objectAtIndex:i]];
						}
					}else{
						[self drawSerie:serie];
					}
					break;
				}
			}else{
				if([serie isKindOfClass:[NSArray class]]){
					for(int i=0;i<[serie count];i++){
						[self drawSerie:[serie objectAtIndex:i]];
					}
				}else{
					[self drawSerie:serie];
				}
			}
		}
	}
	[self drawLabels];
}

-(void)drawLabels
{
	for(int i=0;i<self.sections.count;i++){
		Section *sec = [self.sections objectAtIndex:i];
		if(sec.hidden){
		    continue;
		}
		
		float w = 0;
		for(int s=0;s<sec.series.count;s++){
			NSMutableArray *label =[[NSMutableArray alloc] init];
		    NSObject *serie = [sec.series objectAtIndex:s];
			
			if(sec.paging)
            {
				if (sec.selectedIndex == s)
                {
					if([serie isKindOfClass:[NSArray class]])
                    {
						for(int i=0;i<[serie count];i++)
                        {
							[self setLabel:label forSerie:[serie objectAtIndex:i]];
						}
					}else
                    {
						[self setLabel:label forSerie:serie];
					}
				}
			}else
            {
				if([serie isKindOfClass:[NSArray class]])
                {
					for(int i=0;i<[serie count];i++)
                    {
						[self setLabel:label forSerie:[serie objectAtIndex:i]];
					}
				}else
                {
					[self setLabel:label forSerie:serie];
				}
			}
			for(int j=0;j<label.count;j++)
            {
				NSMutableDictionary *lbl = [label objectAtIndex:j];
				NSString *text  = [lbl objectForKey:KEY_TEXT];
				NSString *color = [lbl objectForKey:KEY_COLOR];
                int lnFontSize =  [[lbl objectForKey:KEY_FONT_SIZE]intValue];
                if (0 == lnFontSize)
                {
                    lnFontSize = self.m_nLabelFontSize;
                }
                int lnPaddingleft =  [[lbl objectForKey:KEY_PADDING_LEFT]intValue];
                if (0 == lnPaddingleft)
                {
                    //lnPaddingleft = sec.paddingLeft;
                }
                
                int lnPaddingtop = [[lbl objectForKey:KEY_PADDING_TOP]intValue];
                if (0 == lnPaddingtop)
                {
                    lnPaddingtop = 0;
                }
                
                NSString * lpFontName = [lbl objectForKey:KEY_FONT_NAME];
                if (nil == lpFontName)
                {
                    lpFontName = self.m_pStrFontName;
                }
                
                int lnLabelType =[[lbl objectForKey:KEY_LABEL_TYPE]intValue];
                
                int lnSkipWidth = [[lbl objectForKey:KEY_SKIP_WIDTH]intValue];
                
                
				NSArray *colors = [color componentsSeparatedByString:@","];
                
				CGContextRef context = UIGraphicsGetCurrentContext();
				CGContextSetShouldAntialias(context, YES);
				CGContextSetRGBFillColor(context, [[colors objectAtIndex:0] floatValue], [[colors objectAtIndex:1] floatValue], [[colors objectAtIndex:2] floatValue], 1.0);
				[text drawAtPoint:CGPointMake(sec.frame.origin.x+sec.paddingLeft+2+w,sec.frame.origin.y+lnPaddingtop) withFont:[UIFont fontWithName:self.m_pStrFontName size: lnFontSize]];
                if(lnSkipWidth)
                    
                {
                    //w += [text sizeWithFont:[UIFont fontWithName:lpFontName size: lnFontSize]].width;
                }else
                {
                    w += [text sizeWithFont:[UIFont fontWithName:lpFontName size: lnFontSize]].width;
                }
				
                if (lnLabelType == KEY_LABEL_TYPE_UNIT)
                {
                    w += 10;
                }
			}
			[label release];
		}
	}
}

-(void)setLabel:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
	NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model setLabel:self label:label forSerie:serie];
}

-(void)drawSerie:(NSMutableDictionary *)serie
{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model drawSerie:self serie:serie];
    
    NSEnumerator *enumerator = [self.models keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]))
    {
        ChartModel *m = [self.models objectForKey:key];
        [m drawTips:self serie:serie];
    }
}

-(void)drawYAxis{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO );
	CGContextSetLineWidth(context, 1.0f);
	
	for(int secIndex=0;secIndex<[self.sections count];secIndex++)
    {
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
			continue;
		}
		CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
		CGContextMoveToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
		CGContextStrokePath(context);
	}
	
	CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
	CGFloat dash[] = {5};
	CGContextSetLineDash (context,0,dash,1);
    
	for(int secIndex=0;secIndex<self.sections.count;secIndex++)
    {
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden)
        {
			continue;
		}
		for(int aIndex=0;aIndex<sec.yAxises.count;aIndex++)
        {
			YAxis *yaxis = [sec.yAxises objectAtIndex:aIndex];
			NSString *format=[@"%." stringByAppendingFormat:@"%df",yaxis.decimal];
			
			float baseY = [self getLocalY:yaxis.baseValue withSection:secIndex withAxis:aIndex];
			CGContextSetStrokeColorWithColor(context, [[[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]autorelease].CGColor);
			CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,baseY);
			CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,baseY);
			CGContextStrokePath(context);
			
			[[@"" stringByAppendingFormat:format,yaxis.baseValue] drawAtPoint:CGPointMake(sec.frame.origin.x-1,baseY-7) withFont:[UIFont fontWithName:self.m_pStrFontName size: self.m_nYAxisFontSize]];
			
			CGContextSetStrokeColorWithColor(context, [[[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0]autorelease].CGColor);
			CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,baseY);
			CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,baseY);
            
			if (yaxis.tickInterval%2 == 1)
            {
				yaxis.tickInterval +=1;
			}
			
			float step = (float)(yaxis.max-yaxis.min)/yaxis.tickInterval;
			for(int i=1; i<= yaxis.tickInterval+1;i++)
            {
				if(yaxis.baseValue + i*step <= yaxis.max)
                {
					float iy = [self getLocalY:(yaxis.baseValue + i*step) withSection:secIndex withAxis:aIndex];
					
					CGContextSetStrokeColorWithColor(context, [[[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]autorelease].CGColor);
					CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
					CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,iy);
					CGContextStrokePath(context);
					
					[[@"" stringByAppendingFormat:format,yaxis.baseValue+i*step] drawAtPoint:CGPointMake(sec.frame.origin.x-1,iy-7) withFont:[UIFont fontWithName:self.m_pStrFontName size: self.m_nYAxisFontSize]];
					
					if(yaxis.baseValue + i*step < yaxis.max){
						CGContextSetStrokeColorWithColor(context, [[[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0]autorelease].CGColor);
						CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
						CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
					}
					
					CGContextStrokePath(context);
				}
			}
			for(int i=1; i <= yaxis.tickInterval+1;i++)
            {
				if(yaxis.baseValue - i*step >= yaxis.min)
                {
					float iy = [self getLocalY:(yaxis.baseValue - i*step) withSection:secIndex withAxis:aIndex];
					
					CGContextSetStrokeColorWithColor(context, [[[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]autorelease].CGColor);
					CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
					CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,iy);
					CGContextStrokePath(context);
					
					[[@"" stringByAppendingFormat:format,yaxis.baseValue-i*step] drawAtPoint:CGPointMake(sec.frame.origin.x-1,iy-7) withFont:[UIFont fontWithName:self.m_pStrFontName size: self.m_nYAxisFontSize]];
					
					if(yaxis.baseValue - i*step > yaxis.min)
                    {
						CGContextSetStrokeColorWithColor(context, [[[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0]autorelease].CGColor);
						CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
						CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
					}
					
					CGContextStrokePath(context);
				}
			}
		}
	}
	CGContextSetLineDash (context,0,NULL,0);
}

-(void)drawXAxis{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO);
	CGContextSetLineWidth(context, 1.f);
	CGContextSetStrokeColorWithColor(context, [[[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]autorelease].CGColor);
	for(int secIndex=0;secIndex<self.sections.count;secIndex++){
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
			continue;
		}
		CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
		
		CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
	}
	CGContextStrokePath(context);
}

-(void) setSelectedIndexByPoint:(CGPoint) point
{
   // return [self setSelectedIndexByPointNotMove:point];
	
	if([self getIndexOfSection:point] == -1){
		return;
	}
	Section *sec = [self.sections objectAtIndex:[self getIndexOfSection:point]];
	
	for(int i=self.rangeFrom;i<self.rangeTo;i++)
    {
		if((plotWidth*(i-self.rangeFrom))<=(point.x-sec.paddingLeft-self.paddingLeft) && (point.x-sec.paddingLeft-self.paddingLeft)<plotWidth*((i-self.rangeFrom)+1))
        {
			if (self.selectedIndex != i) {
				self.selectedIndex=i;
				[self setNeedsDisplay];
			}
			
			return;
		}
	}
}


-(void) setSelectedIndexByPointNotMove:(CGPoint) point
{
	
	if([self getIndexOfSection:point] == -1)
    {
		return;
	}
    int lnSecIndex = [self getIndexOfSection:point];
	Section *sec = [self.sections objectAtIndex:lnSecIndex];
	
    int lnSearchPixl = 10;
    int lnStartStep = 0;

    int lnNextStep = ceil(lnSearchPixl*1.0/plotWidth)+1;
    if (lnNextStep >= self.rangeTo)
    {
        lnNextStep = self.rangeTo;
    }
    //1 get min index

	for(int i=self.rangeFrom;i<self.rangeTo;i++)
    {
		if((plotWidth*(i-self.rangeFrom))<=(point.x-sec.paddingLeft-self.paddingLeft) && (point.x-sec.paddingLeft-self.paddingLeft)<=(plotWidth*((i-self.rangeFrom)+1)+lnSearchPixl))
        {
            lnStartStep = i;
			break;
		}
	}
    float lfDistanceMin = -1;
    
    int lnMinDistanceIndex =0;
#ifdef DEBUG
    NSLog(@"Point pressed:(%f,%f)",point.x,point.y);
#endif
    for (int i = lnStartStep; i<lnStartStep+lnNextStep;i++)
    {
        for (int j=0; j<sec.series.count; j++)
        {
            NSMutableDictionary * serie = [sec.series objectAtIndex:j];
            NSMutableArray *data          = [serie objectForKey:@"data"];
            if (nil == data)
            {
                continue;
            }
            float valNext  = [[[data objectAtIndex:(i)] objectAtIndex:0] floatValue];
            float lfDistance = [self GetDistance:point Section:sec anXIndex:i afYvalue:valNext withSection:lnSecIndex withAxis:0];
            
            if (lfDistance<= lfDistanceMin || (0> lfDistanceMin))
            {
                lfDistanceMin = lfDistance;
                lnMinDistanceIndex = i;
            }
            
        }

    }
    
    self.selectedIndex = lnMinDistanceIndex;
    [self setNeedsDisplay];
    
//    for(int i=(self.rangeTo-1);i>=lnMinIndex;i--)
//    {
//		if((plotWidth*(i-self.rangeFrom))<=(point.x-sec.paddingLeft-self.paddingLeft) && (point.x-sec.paddingLeft-self.paddingLeft)<=(plotWidth*((i-self.rangeFrom)+1)+lnSearchPixl))
//        {
//            lnMinIndex = i;
//			break;
//		}
//	}
}

-(void)appendToData:(NSArray *)data forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"data"] == nil){
				NSMutableArray *tempData = [[NSMutableArray alloc] init];
			    [[self.series objectAtIndex:i] setObject:tempData forKey:@"data"];
				[tempData release];
			}
			
			for(int j=0;j<data.count;j++){
				[[[self.series objectAtIndex:i] objectForKey:@"data"] addObject:[data objectAtIndex:j]];
			}
	    }
	}
}

-(void)clearDataforName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"data"] != nil){
				[[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
			}
	    }
	}
}

-(void)clearData{
	for(int i=0;i<self.series.count;i++){
		[[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
	}
}

-(void)setData:(NSMutableArray *)data forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
		    [[self.series objectAtIndex:i] setObject:data forKey:@"data"];
		}
	}
}

-(void)appendToCategory:(NSArray *)category forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"category"] == nil){
				NSMutableArray *tempData = [[NSMutableArray alloc] init];
			    [[self.series objectAtIndex:i] setObject:tempData forKey:@"category"];
				[tempData release];
			}
			
			for(int j=0;j<category.count;j++){
				[[[self.series objectAtIndex:i] objectForKey:@"category"] addObject:[category objectAtIndex:j]];
			}
	    }
	}
}

-(void)clearCategoryforName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqual:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"category"] != nil){
				[[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
			}
	    }
	}
}

-(void)clearCategory{
	for(int i=0;i<self.series.count;i++){
		[[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
	}
}

-(void)setCategory:(NSMutableArray *)category forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
		    [[self.series objectAtIndex:i] setObject:category forKey:@"category"];
		}
	}
}

/*
 * Sections
 */
-(Section *)getSection:(int) index
{
    return [self.sections objectAtIndex:index];
}
-(int)getIndexOfSection:(CGPoint) point{
    for(int i=0;i<self.sections.count;i++){
	    Section *sec = [self.sections objectAtIndex:i];
		if (CGRectContainsPoint(sec.frame, point)){
		    return i;
		}
	}
	return -1;
}

/*
 * series
 */
-(NSMutableDictionary *)getSerie:(NSString *)name{
	NSMutableDictionary *serie = nil;
    for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			serie = [self.series objectAtIndex:i];
			break;
		}
	}
	return serie;
}

-(void)addSerie:(NSObject *)serie{
	if([serie isKindOfClass:[NSArray class]]){
		int section = 0;
	    for (NSDictionary *ser in serie) {
		    section = [[ser objectForKey:@"section"] intValue];
			[self.series addObject:ser];
		}
		[[[self.sections objectAtIndex:section] series] addObject:serie];
	}else{
		int section = [[serie objectForKey:@"section"] intValue];
		[self.series addObject:serie];
		[[[self.sections objectAtIndex:section] series] addObject:serie];
	}
}

/*
 *  Chart Sections
 */
-(void)addSection:(NSString *)ratio{
	[ratio retain];
	Section *sec = [[Section alloc] init];
    [self.sections addObject:sec];
	[sec release];
	[self.ratios addObject:ratio];
	[ratio release];
}

-(void)removeSection:(int)index{
    [self.sections removeObjectAtIndex:index];
	[self.ratios removeObjectAtIndex:index];
}

-(void)addSections:(int)num withRatios:(NSArray *)rats{
	[rats retain];
	for (int i=0; i< num; i++) {
		Section *sec = [[Section alloc] init];
		[self.sections addObject:sec];
		[sec release];
		[self.ratios addObject:[rats objectAtIndex:i]];
	}
	[rats release];
}

-(void)removeSections{
    [self.sections removeAllObjects];
	[self.ratios removeAllObjects];
}

-(void)initSections{
    float height = self.frame.size.height-(self.paddingTop+self.paddingBottom);
    float width  = self.frame.size.width-(self.paddingLeft+self.paddingRight);
    
    int total = 0;
    for (int i=0; i< self.ratios.count; i++) {
        if([[self.sections objectAtIndex:i] hidden]){
            continue;
        }
        int ratio = [[self.ratios objectAtIndex:i] intValue];
        total+=ratio;
    }
    
    Section*prevSec = nil;
    for (int i=0; i< self.sections.count; i++) {
        int ratio = [[self.ratios objectAtIndex:i] intValue];
        Section *sec = [self.sections objectAtIndex:i];
        if([sec hidden]){
            continue;
        }
        float h = height*ratio/total;
        float w = width;
        
        if(i==0){
            [sec setFrame:CGRectMake(0+self.paddingLeft, 0+self.paddingTop, w,h)];
        }else{
            if(i==([self.sections count]-1)){
                [sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,self.paddingTop+height-(prevSec.frame.origin.y+prevSec.frame.size.height))];
            }else {
                [sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,h)];
            }
        }
        prevSec = sec;
        
    }
    self.isSectionInitialized = YES;
}


-(YAxis *)getYAxis:(int) section withIndex:(int) index{
	Section *sec = [self.sections objectAtIndex:section];
	YAxis *yaxis = [sec.yAxises objectAtIndex:index];
    return yaxis;
}

/*
 * UIView Methods
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self)
    {
		self.enableSelection = YES;
		self.isInitialized   = NO;
		self.isSectionInitialized   = NO;
		self.selectedIndex   = -1;
		self.padding         = nil;
		self.paddingTop      = 0;
		self.paddingRight    = 0;
		self.paddingBottom   = 0;
		self.paddingLeft     = 0;
		self.rangeFrom       = 0;
		self.rangeTo         = 0;
		self.range           = 120;
		self.touchFlag       = 0;
		self.touchFlagTwo    = 0;
		NSMutableArray *rats = [[[NSMutableArray alloc] init]autorelease];
		self.ratios          = rats;
        self.m_bInMove       = NO;
		
		
		NSMutableArray *secs = [[[NSMutableArray alloc] init]autorelease];
		self.sections        = secs;
		
        
        NSMutableDictionary *mods = [[[NSMutableDictionary alloc] init]autorelease];
		self.models        = mods;
		;
		
		[self setMultipleTouchEnabled:YES];
        
        //字体
        self.m_pStrFontName = @"Gill Sans";
        self.m_nLabelFontSize = DEFAULT_LABEL_FONT_SIZE;
        self.m_nYAxisFontSize = DEFAULT_FONT_SIZE;
        
        //init models
        [self initModels];
    }
    return self;
}

-(void)initModels{
    //line
    ChartModel *model = [[[LineChartModel alloc] init]autorelease];
    [self addModel:model withName:@"line"];
   
    
    //area
    model = [[[AreaChartModel alloc] init]autorelease];
    [self addModel:model withName:@"area"];
    
    
    //column
    model = [[[ColumnChartModel alloc] init]autorelease];
    [self addModel:model withName:@"column"];
       
    //candle
    model = [[[CandleChartModel alloc] init]autorelease];
    [self addModel:model withName:@"candle"];
  
    
}

-(void)addModel:(ChartModel *)model withName:(NSString *)name{
    [self.models setObject:model forKey:name];
}

-(ChartModel *)getModel:(NSString *)name{
    return [self.models objectForKey:name];
}

- (void)drawRect:(CGRect)rect {
	[self initChart];
	[self initSections];
	[self initXAxis];
	[self initYAxis];
	[self drawXAxis];
	[self drawYAxis];
	[self drawChart];
}

- (void)dealloc
{

    self.m_pStrFontName = nil;
//	[borderColor release];
//	[padding release];
//	[series release];
//	[title release];
//	[sections release];
//	[ratios release];
    [super dealloc];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *ts = [touches allObjects];
	self.touchFlag = 0;
	self.touchFlagTwo = 0;
	if([ts count]==1)
    {
		UITouch* touch = [ts objectAtIndex:0];
		if([touch locationInView:self].x < 40)
        {
		    self.touchFlag = [touch locationInView:self].y;
		}
        
	}else if ([ts count]==2)
    {
		self.touchFlag = [[ts objectAtIndex:0] locationInView:self].x ;
		self.touchFlagTwo = [[ts objectAtIndex:1] locationInView:self].x;
	}
    self.m_bInMove = NO;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.m_bInMove = YES;
	NSArray *ts = [touches allObjects];
	if([ts count]==1)
    {
		UITouch* touch = [ts objectAtIndex:0];
        
		int i = [self getIndexOfSection:[touch locationInView:self]];
		if(i!=-1)
        {
			Section *sec = [self.sections objectAtIndex:i];
			if([touch locationInView:self].x > sec.paddingLeft)
			{
                [self setSelectedIndexByPoint:[touch locationInView:self]];
            }
			int interval = 5;
			if([touch locationInView:self].x < sec.paddingLeft){
				if(abs([touch locationInView:self].y - self.touchFlag) >= MIN_INTERVAL){
					if([touch locationInView:self].y - self.touchFlag > 0)
                    {
						if(self.plotCount > (self.rangeTo-self.rangeFrom))
                        {
							if(self.rangeFrom - interval >= 0)
                            {
								self.rangeFrom -= interval;
								self.rangeTo   -= interval;
								if(self.selectedIndex >= self.rangeTo)
                                {
									self.selectedIndex = self.rangeTo-1;
								}
							}else
                            {
								self.rangeFrom = 0;
								self.rangeTo  -= self.rangeFrom;
								if(self.selectedIndex >= self.rangeTo)
                                {
									self.selectedIndex = self.rangeTo-1;
								}
							}
							[self setNeedsDisplay];
						}
					}else
                    {
						if(self.plotCount > (self.rangeTo-self.rangeFrom))
                        {
							if(self.rangeTo + interval <= self.plotCount)
                            {
								self.rangeFrom += interval;
								self.rangeTo += interval;
								if(self.selectedIndex < self.rangeFrom)
                                {
									self.selectedIndex = self.rangeFrom;
								}
							}else
                            {
								self.rangeFrom  += self.plotCount-self.rangeTo;
								self.rangeTo     = self.plotCount;
								
								if(self.selectedIndex < self.rangeFrom)
                                {
									self.selectedIndex = self.rangeFrom;
								}
							}
							[self setNeedsDisplay];
						}
					}
					self.touchFlag = [touch locationInView:self].y;
				}
			}
		}
		
	}else if ([ts count]==2)
    {
		float currFlag = [[ts objectAtIndex:0] locationInView:self].x;
		float currFlagTwo = [[ts objectAtIndex:1] locationInView:self].x;
        if (currFlag > currFlagTwo)
        {
            
            float lfSwap = currFlag;
            currFlag = currFlagTwo;
            currFlagTwo = lfSwap;
        }
		if(self.touchFlag == 0)
        {
		    self.touchFlag = currFlag;
			self.touchFlagTwo = currFlagTwo;
		}else
        {
            float changedOne = abs(currFlag - self.touchFlag) ;
            float changedTow = abs(currFlagTwo - self.touchFlagTwo);
            
			float intervalOne = (changedOne)/self.plotWidth;
            float intervalTow = (changedTow)/self.plotWidth;
#ifdef DEBUG
            NSLog(@"One:%f Tow:%f One Interval:%f Tow Interval:%f from:%f to:%f",changedOne,changedTow,intervalOne,intervalTow,(self.rangeFrom - intervalOne),(self.rangeTo - intervalTow));
#endif
           
			//pan to right
			if((currFlag - self.touchFlag) > 0 && (currFlagTwo - self.touchFlagTwo) > 0)
            {
				if(self.plotCount > (self.rangeTo-self.rangeFrom))
                {
					if(self.rangeFrom - changedOne >= 0)
                    {
						self.rangeFrom -= changedOne;
						self.rangeTo   -= changedTow;
						if(self.selectedIndex >= self.rangeTo)
                        {
							self.selectedIndex = self.rangeTo-1;
						}
                        #ifdef DEBUG
                        NSLog(@"pan to right 1");
                        #endif
					}else
                    {
						self.rangeFrom = 0;
						self.rangeTo  -= self.rangeFrom;
						if(self.selectedIndex >= self.rangeTo)
                        {
							self.selectedIndex = self.rangeTo-1;
						}
                        #ifdef DEBUG
                        NSLog(@"pan to right 2");
                        #endif
					}
					[self setNeedsDisplay];
				}
            //pan to left
			}else if((currFlag - self.touchFlag) < 0 && (currFlagTwo - self.touchFlagTwo) < 0)
            {
				if(self.plotCount > (self.rangeTo-self.rangeFrom))
                {
					if(self.rangeTo + intervalTow <= self.plotCount)
                    {
						self.rangeFrom += changedOne;
						self.rangeTo += intervalTow;
						if(self.selectedIndex < self.rangeFrom)
                        {
							self.selectedIndex = self.rangeFrom;
						}
                        #ifdef DEBUG
                        NSLog(@"pan to left 1");
                        #endif
					}else
                    {
						self.rangeFrom  += self.plotCount-self.rangeTo;
						self.rangeTo     = self.plotCount;
						
						if(self.selectedIndex < self.rangeFrom)
                        {
							self.selectedIndex = self.rangeFrom;
						}
                        #ifdef DEBUG
                        NSLog(@"pan to left 2");
                        #endif
					}
					[self setNeedsDisplay];
				}
			}else {
                //zoom in
				if(abs(abs(currFlagTwo-currFlag)-abs(self.touchFlagTwo-self.touchFlag)) >= MIN_INTERVAL)
                {
					if(abs(currFlagTwo-currFlag)-abs(self.touchFlagTwo-self.touchFlag) > 0)
                    {
						if(self.plotCount>self.rangeTo-self.rangeFrom)
                        {
                            float lnNextFrom = self.rangeFrom + intervalOne;
                            float lnNextTo = self.rangeTo -intervalTow;
                            if (abs((int)(lnNextFrom-lnNextTo))<=10)
                            {
#ifdef DEBUG
                                NSLog(@"zoom in reach min points limitation:%d:",10);
#endif
                                
                            }else
                            {
                                if(self.rangeFrom + intervalOne < self.rangeTo)
                                {
                                    self.rangeFrom += intervalOne;
                                }
                                if(self.rangeTo - intervalTow > self.rangeFrom)
                                {
                                    self.rangeTo -= intervalTow;
                                }
#ifdef DEBUG
                                NSLog(@"zoom in 1");
#endif
                            }

						}else
                        {
							if(self.rangeTo - intervalTow > self.rangeFrom)
                            {
								self.rangeTo -= intervalTow;
							}
                            #ifdef DEBUG
                            NSLog(@"zoom in  2");
                            #endif
						}
						[self setNeedsDisplay];
                        
                    //zoom out
					}else
                    {
                        float lnNextFrom = self.rangeFrom - intervalOne;
                        float lnNextTo = self.rangeTo +intervalTow;
                        

                        {
                            if(self.rangeFrom - intervalOne >= self.rangeFrom_original)
                            {
                                self.rangeFrom -= intervalOne;
#ifdef DEBUG
                                NSLog(@"zoom out 1");
#endif
                            }else
                            {
                                self.rangeFrom = self.rangeFrom_original;
#ifdef DEBUG
                                NSLog(@"zoom out 2");
#endif
                            }
                            if (lnNextTo <= self.rangeTo_original)
                            {
                                self.rangeTo += intervalTow;
                            }else
                            {
                                self.rangeTo = self.rangeTo_original;
                            }
                        
                        }

						[self setNeedsDisplay];
					}
				}
			}
            
		}
		self.touchFlag = currFlag;
		self.touchFlagTwo = currFlagTwo;
	}
   // [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray *ts = [touches allObjects];
	UITouch* touch = [[event allTouches] anyObject];
	if([ts count]==1)
    {
		int i = [self getIndexOfSection:[touch locationInView:self]];
		if(i!=-1)
        {
			Section *sec = [self.sections objectAtIndex:i];
			if([touch locationInView:self].x > sec.paddingLeft)
            {
				if(sec.paging)
                {
					[sec nextPage];
					[self setNeedsDisplay];
				}else
                {
                    if (self.m_bInMove)
                    {
                        self.m_bInMove = YES;
                    }else
                    {
                     [self setSelectedIndexByPointNotMove:[touch locationInView:self]];    
                    }

				}
			}
		}
	}
	self.touchFlag = 0;
    [super touchesBegan:touches withEvent:event];
}

@end
