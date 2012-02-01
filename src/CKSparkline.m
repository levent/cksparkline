#import "CKSparkline.h"


@implementation CKSparkline

@synthesize selected;
@synthesize lineColor;
@synthesize highlightedLineColor;
@synthesize lineWidth;
@synthesize data;
@synthesize computedData;


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		[self initializeDefaults];
    }
	
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
		[self initializeDefaults];
    }
	
    return self;
}


- (void)initializeDefaults
{
	self.selected = NO;
	self.backgroundColor = [UIColor clearColor];
	self.lineColor = [UIColor colorWithWhite:0.65 alpha:1.0];
	self.highlightedLineColor = [UIColor whiteColor];
	self.lineWidth = 1.0;
}


- (void)setSelected:(BOOL)isSelected
{
	selected = isSelected;	
	[self setNeedsDisplay];
}


- (void)setData:(NSArray *)newData
{
	CGFloat max = 0.0;
	CGFloat min = FLT_MAX;
	NSMutableArray *mutableComputedData = [[NSMutableArray alloc] initWithCapacity:[newData count]];

	for (NSNumber *dataValue in newData) {
		min = MIN([dataValue floatValue], min);
		max = MAX([dataValue floatValue], max);
	}
	
	for (NSNumber *dataValue in newData) {
		NSNumber *value = [[NSNumber alloc] initWithFloat:([dataValue floatValue] - min) / (max - min + 1.0)];
		[mutableComputedData addObject:value];
	}
	
	computedData = mutableComputedData;


	data = newData;
	
	[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
	if ([self.computedData count] < 1)
		return;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat maxX = CGRectGetMaxX(rect);
	CGFloat maxY = CGRectGetMaxY(rect);
	
	CGColorRef strokeColor = [(self.selected ? self.highlightedLineColor : self.lineColor) CGColor];
	CGContextSetStrokeColorWithColor(context, strokeColor);
	CGContextSetLineWidth(context, self.lineWidth);

	CGContextBeginPath(context);				
	CGContextMoveToPoint(context, 0.0, maxY - maxY * [[computedData objectAtIndex:0] floatValue]);
	
	for (int i = 1; i < [self.computedData count]; i++) {
		CGContextAddLineToPoint(context, maxX * ((CGFloat)i / ([self.computedData count] - 1)),
								maxY - maxY * [[self.computedData objectAtIndex:i] floatValue]);
	}
	
	CGContextStrokePath(context);
}


- (void)dealloc
{
}


@end
