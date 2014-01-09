#include <CoreGraphics/CoreGraphics.h>
#include <QuartzCore/QuartzCore.h>
#import "BOZPongRefreshControl.h"
#import "UIRefreshControl.h"
#import "CydiaSubstrate.h"

static NSMutableArray *lastDelegates; // _UIRefreshControlAnimationDelegate *lastDelegate

%hook _UIRefreshControlAnimationDelegate
+(_UIRefreshControlAnimationDelegate *)delegateWithCompletionBlock:(id)arg1{
	NSLog(@"---- in delegate :%@ ", arg1);

	_UIRefreshControlAnimationDelegate *delegate = %orig;
	if(!lastDelegates)
		lastDelegates = [[NSMutableArray alloc] init];
	[lastDelegates addObject:delegate];
	return delegate;
}
%end

@interface UIPongScrollViewDelegate : UIScrollViewDelegate
@property (nonatomic, retain) BOZPongRefreshControl *sender;
@end

@implementation UIPongScrollView
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[sender scrollViewDidEndDragging];
}
@end

@interface UIRefreshControl (PullToPong)
-(void)prepPongRefresh;
@end

%hook UIRefreshControl
BOZPongRefreshControl *pongControl;

%new -(void)prepPongRefresh{
	NSLog(@"---- prep pong");

	[self setHidden:YES];
	UIScrollView *scrollView = MSHookIvar<UIScrollView *>(self, "_scrollView");
	pongControl = [BOZPongRefreshControl attachToScrollView:scrollView withRefreshTarget:self andRefreshAction:@selector(finishAnimation)];
}

%new -(void)finishAnimation{
	NSLog(@"---- finish animation");

	_UIRefreshControlAnimationDelegate *delegate = [lastDelegates objectAtIndex:0];
	[delegate animationDidStop:nil finished:YES];
	[lastDelegates removeObjectAtIndex:0];

	// if nonfunctional, could use:
	//[[NSOperationQueue mainQueue] addOperationWithBlock: ^{
}

-(void)beginRefreshing{
	NSLog(@"---- being refreshing");
	[pongControl beginLoading];
}

-(void)endRefreshing{
	NSLog(@"---- end refreshing");
	[pongControl finishedLoading];
}

-(void)_didScroll{
	NSLog(@"---- did scroll");
	[pongControl scrollViewDidScroll];
}

-(float)revealedFraction{
	NSLog(@"---- revealed fraction");
	[pongControl scrollViewDidEndDragging];
	return %orig;
}

-(UIRefreshControl *)init{
	self = %orig;
	[self prepPongRefresh];
	return self;
}

-(UIRefreshControl *)initWithCoder:(id)arg1{
	self = %orig;
	[self prepPongRefresh];
	return self;
}

-(UIRefreshControl *)initWithFrame:(CGRect)arg1{
	self = %orig;
	[self prepPongRefresh];
	return self;
}

-(UIRefreshControl *)initWithStyle:(int)arg1{
	self = %orig;
	[self prepPongRefresh];
	return self;
}

%end