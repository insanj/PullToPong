#include <CoreGraphics/CoreGraphics.h>
#include <QuartzCore/QuartzCore.h>
#import "BOZPongRefreshControl.h"
#import "UIRefreshControl.h"
#import "CydiaSubstrate.h"

#import <objc/runtime.h>

// Best app for testing: Instagram

@interface UIScrollView (PullToPong)
@property (nonatomic, retain) BOZPongRefreshControl *sender;
@end

// Thanks, http://stackoverflow.com/questions/20731714/hook-in-cllocationmanagerdelegate-protocol!
// meant to low-level change the implementation of UIScrollViewDelegate, replacing the original_
// with the replaced_ version, which calls my %new'd method of the categoried _sender (PongControl).
// doesn't appear to be called, ever.
static IMP original_scrollViewDidEndDragging;
void replaced_scrollViewDidEndDragging(id self, SEL _cmd, UIScrollView* scrollView, BOOL willDecelerate){
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

-(UIRefreshControl *)init{	// most common usage is from -initWithStyle
	self = %orig;
	[self prepPongRefresh];
	return self;
}

/* !!! attaching PongRefreshControl seems to make %hook'd methods tempermental in calls?! */
%new -(void)prepPongRefresh{			// called when initializing UIScrollView (sometimes twice)
	//[self setHidden:YES];	// doesn't do anything, I guess this has to modified in an action method
	UIScrollView *scrollView = MSHookIvar<UIScrollView *>(self, "_scrollView");
	pongControl = [BOZPongRefreshControl attachToScrollView:scrollView withRefreshTarget:self andRefreshAction:@selector(_update)];
	scrollView.sender = pongControl;
	eatDelegates();
}

-(void)beginRefreshing{					// appears to be called at expected time (when showing control)
	[pongControl beginLoading];
}

-(void)endRefreshing{					// appears to be called at expected time (before hiding control)
	[pongControl finishedLoading];
}

-(void)_didScroll{						// called whenever UIScrollView scrolls (always)
	[pongControl scrollViewDidScroll];	
}

%new -(void)scrollViewDidEndDragging{	// implementation of above C-hooks (doesn't appear to work)
	[pongControl scrollViewDidEndDragging];
}

-(void)_update{							// called whenever UIScroll/TableView updates content
	%orig;
	[pongControl scrollViewDidEndDragging];
}

%end