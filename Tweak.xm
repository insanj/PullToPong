#include <CoreGraphics/CoreGraphics.h>
#include <QuartzCore/QuartzCore.h>
#import "BOZPongRefreshControl.h"
#import "UIRefreshControl.h"
#import "CydiaSubstrate.h"

#import <objc/runtime.h>

@interface UIScrollView (PullToPong)
@property (nonatomic, retain) BOZPongRefreshControl *sender;
@end

// Thanks, http://stackoverflow.com/questions/20731714/hook-in-cllocationmanagerdelegate-protocol!
static IMP original_scrollViewDidEndDragging;
void replaced_scrollViewDidEndDragging(id self, SEL _cmd, UIScrollView* scrollView, BOOL willDecelerate){
    NSLog(@" ---- replace scrollview ");
    if(scrollView.sender)
    	[scrollView.sender scrollViewDidEndDragging];

    original_scrollViewDidEndDragging(self, _cmd, scrollView, willDecelerate);
}

void eatDelegates(){
	int numClasses = objc_getClassList(NULL, 0);
	Class* list = (Class*)malloc(sizeof(Class) * numClasses);
	objc_getClassList(list, numClasses);    

	for(int i = 0; i < numClasses; i++)
	    if(class_conformsToProtocol(list[i], @protocol(UIScrollViewDelegate)) && class_getInstanceMethod(list[i], @selector(scrollViewDidEndDragging:willDecelerate:)))
        		MSHookMessageEx(list[i], @selector(locationManager:didUpdateLocations:), (IMP)replaced_scrollViewDidEndDragging, (IMP*)&original_scrollViewDidEndDragging);

	free(list);
}

@interface UIRefreshControl (PullToPong)
-(void)prepPongRefresh;
-(void)scrollViewDidEndDragging;
@end

%hook UIRefreshControl
BOZPongRefreshControl *pongControl;

%new -(void)prepPongRefresh{
	NSLog(@"---- prep pong");

	[self setHidden:YES];
	UIScrollView *scrollView = MSHookIvar<UIScrollView *>(self, "_scrollView");
	pongControl = [BOZPongRefreshControl attachToScrollView:scrollView withRefreshTarget:self andRefreshAction:@selector(_update)];
	scrollView.sender = pongControl;
	eatDelegates();
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

%new -(void)scrollViewDidEndDragging{
	NSLog(@"---- end dragging");
	[pongControl scrollViewDidEndDragging];
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