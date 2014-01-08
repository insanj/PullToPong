#include <CoreGraphics/CoreGraphics.h>
#include <QuartzCore/QuartzCore.h>
#import "BOZPongRefreshControl.h"
#import "UIRefreshControl.h"
#import "CydiaSubstrate.h"

static _UIRefreshControlAnimationDelegate *lastDelegate;

%hook _UIRefreshControlAnimationDelegate
+(_UIRefreshControlAnimationDelegate *)delegateWithCompletionBlock:(id)arg1{
	lastDelegate = %orig;
	return lastDelegate;
}
%end

@interface UIRefreshControl (PullToPong)
-(void)prepPongRefresh;
@end

%hook UIRefreshControl
BOZPongRefreshControl *pongControl;

%new -(void)prepPongRefresh{
	[self setHidden:YES];
	UIScrollView *scrollView = MSHookIvar<UIScrollView *>(self, "_scrollView");
	pongControl = [BOZPongRefreshControl attachToScrollView:scrollView withRefreshTarget:self andRefreshAction:@selector(finishAnimation)];
}

%new -(void)finishAnimation{
	//_UIRefreshControlAnimationDelegate
	[lastDelegate animationDidStop:nil finished:YES];
	lastDelegate = nil;

	// if nonfunctional, could use:
	//[[NSOperationQueue mainQueue] addOperationWithBlock: ^{
}

-(void)beginRefreshing{
	[pongControl beginLoading];
}

-(void)endRefreshing{
	[pongControl finishedLoading];
}

-(void)_didScroll{
	[pongControl scrollViewDidScroll];
}

-(float)revealedFraction{
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