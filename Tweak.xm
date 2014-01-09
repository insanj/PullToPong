#include <CoreGraphics/CoreGraphics.h>
#include <QuartzCore/QuartzCore.h>
#import "BOZPongRefreshControl.h"
#import "UIRefreshControl.h"
#import "CydiaSubstrate.h"

@interface _UIRefreshControlAnimationDelegate (PullToPong)
-(void)assignSender:(BOZPongRefreshControl *)arg1;
@end

%hook _UIRefreshControlAnimationDelegate
static BOZPongRefreshControl *sender;
%new -(void)assignSender:(BOZPongRefreshControl *)arg1{
	sender = arg1;
}

+(_UIRefreshControlAnimationDelegate *)delegateWithCompletionBlock:(id)arg1{
	[sender assignCompletionBlock:arg1];
	return %orig;
}
%end

%hook UIScrollViewDelegate
static BOZPongRefreshControl *sender;
%new -(void)assignSender:(BOZPongRefreshControl *)arg1{
	sender = arg1;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	NSLog(@"--- in delegate ended dragging with sender %@", sender);
	%orig;
	if(sender)
		[sender scrollViewDidEndDragging];
}
%end

@interface UIRefreshControl (PullToPong)
-(void)prepPongRefresh;
-(void)scrollViewDidEndDragging;
-(void)assignCompletionBlock:(id)arg1;
@end

%hook UIRefreshControl
BOZPongRefreshControl *pongControl;
id completionBlock;

/* New methods to create pongControl, load in required delegates/data, and call sufficient blocks */
%new -(void)prepPongRefresh{
	NSLog(@"---- prep pong");
	UIScrollView *scrollView = MSHookIvar<UIScrollView *>(self, "_scrollView");
	[scrollView.delegate assignSender:pongControl];

	[self setHidden:YES];
	UIScrollView *scrollView = MSHookIvar<UIScrollView *>(self, "_scrollView");
	pongControl = [BOZPongRefreshControl attachToScrollView:scrollView withRefreshTarget:self andRefreshAction:@selector(finishAnimation)];
}

%new -(void)assignCompletionBlock:(id)arg1{
	NSLog(@"---- assign completionBlock");
	completionBlock = arg1;
}

%new -(void)scrollViewDidEndDragging{
	NSLog(@"---- end dragging");
	[pongControl scrollViewDidEndDragging];
}

%new -(void)finishAnimation{
	NSLog(@"---- finish animation");
	[[NSOperationQueue mainQueue] addOperationWithBlock:completionBlock];
}

/* Override standard UIRefreshControl methods, convert into PongRefreshControl versions */
-(void)beginRefreshing{
	NSLog(@"---- begin refreshing");
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

/* Experimentation methods-- can these be used? */
-(int)refreshControlState{
	NSLog(@"---- refresh control state:%i", %orig);
	return %orig;
}

-(void)_update{
	NSLog(@"---- _update");
	%orig;
}

/* Override initializations to properly init Pong refresh control */
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