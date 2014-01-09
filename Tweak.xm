#include <CoreGraphics/CoreGraphics.h>
#include <QuartzCore/QuartzCore.h>
#import "BOZPongRefreshControl.h"
#import "UIRefreshControl.h"
#import "CydiaSubstrate.h"

@interface PongControlReplacer : NSObject <UIScrollViewDelegate>
@property (nonatomic, retain) UIRefreshControl *originalController;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) BOZPongRefreshControl *pongControl;

-(PongControlReplacer *)initWithOriginal:(UIRefreshControl*)arg1;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
-(void)updateContentView;
@end

@implementation PongControlReplacer
-(PongControlReplacer *)initWithOriginal:(UIRefreshControl*)arg1{
	if((self = [super init])){
		_originalController = arg1;
		_pongControl = [BOZPongRefreshControl attachToScrollView:_scrollView withRefreshTarget:self andRefreshAction:@selector(updateScrollView)];
	}

	return self;
}

-(void)updateContentView{
	[_originalController beginRefreshing];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_pongControl scrollViewDidScroll];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_pongControl scrollViewDidEndDragging];
}
@end

%hook UIRefreshControl
PongControlReplacer *replacer;

-(UIRefreshControl *)init{	// most common usage is from -initWithStyle
	UIRefreshControl *current = %orig;
	[current setFrame:CGRectMake(0,0,0,0)];
	UIScrollView *scrollView = MSHookIvar<UIScrollView *>(current, "_scrollView");
	scrollView.delegate = replacer = [[PongControlReplacer alloc] initWithOriginal:current];
	return current;
}

-(void)endRefreshing{					// appears to be called at expected time (before hiding control)
	[replacer.pongControl finishedLoading];
}
%end