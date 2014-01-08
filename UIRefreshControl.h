/* Core refresh control class, contains _UIRefreshControlContentView (below) */
@interface UIRefreshControl (Private) /*: UIControl {
    int _style;
    id *_contentView; //_UIRefreshControlContentView
    UIScrollView *_scrollView;
    float _refreshControlHeight;
    float _visibleHeight;
    float _snappingHeight;
    float _additionalTopInset;
    BOOL _insetsApplied;
    BOOL _adjustingInsets;
    UIEdgeInsets _appliedInsets;
    int _refreshControlState;
}

@property(getter=isRefreshing,readonly) BOOL refreshing;
@property(retain) UIColor *tintColor;
@property(retain) NSAttributedString *attributedTitle; 
^ commented as they are declared in public UIKit files ^ */

@property(readonly) int refreshControlState;
@property(readonly) int style;
@property(readonly) float _refreshControlHeight;
@property(readonly) float _snappingHeight;
@property(readonly) float _visibleHeight;
@property(getter=_isApplyingInsets,readonly) BOOL _applyingInsets;
@property(getter=_appliedInsets,readonly) UIEdgeInsets appliedInsets;

+(UIColor *)_defaultColor;
+(Class)_contentViewClassForStyle:(int)arg1;

// lifecycle
-(UIRefreshControl *)init;
-(UIRefreshControl *)initWithCoder:(id)arg1;
-(UIRefreshControl *)initWithFrame:(CGRect)arg1;
-(UIRefreshControl *)initWithStyle:(int)arg1;
-(void)encodeWithCoder:(id)arg1;
-(void)dealloc;

// view management
-(void)setBounds:(CGRect)arg1;
-(void)setFrame:(CGRect)arg1;
-(void)setBackgroundColor:(UIColor *)arg1;
-(void)_addInsetHeight:(float)arg1;
-(void)_removeInsetHeight:(float)arg1;
-(void)_resizeToFitContents;
-(void)_addInsets;
-(void)_removeInsets;
-(void)willMoveToSuperview:(id)arg1;
-(void)didMoveToSuperview;
-(void)sizeToFit;
-(CGSize)sizeThatFits:(CGSize)arg1;
-(void)_populateArchivedSubviews:(id)arg1;

// setters
-(void)_setVisibleHeight:(float)arg1;
-(void)_setAttributedTitle:(id)arg1;
-(void)setAttributedTitle:(id)arg1;
-(void)setRefreshControlState:(int)arg1;
-(void)_setTintColor:(id)arg1;
-(void)setTintColor:(id)arg1;

// getters
-(int)style;
-(id)_contentView; //_UIRefreshControlContentView
-(float)_scrollViewHeight;
-(float)_visibleHeight;
-(BOOL)isRefreshing;
-(UIColor *)_tintColor;
-(UIColor *)tintColor;
-(NSAttributedString *)_attributedTitle;
-(NSAttributedString *)attributedTitle;
-(float)_refreshControlHeight;
-(float)_snappingHeight;
-(float)_visibleHeightForContentOffset:(CGPoint)arg1 origin:(CGPoint)arg2;
-(UIEdgeInsets)_appliedInsets;

// checkers
-(BOOL)_canTransitionFromState:(int)arg1 toState:(int)arg2;
-(void)_setRefreshControlState:(int)arg1 notify:(BOOL)arg2;
-(float)_stiffnessForVelocity:(float)arg1;
-(CGPoint)_originForContentOffset:(CGPoint)arg1;
-(BOOL)_isApplyingInsets;
-(void)_didScroll;

// processes
-(void)_updateConcealingMask;
-(void)_updateHiddenStateIfNeeded;
-(int)_recomputeNewState;
-(float)revealedFraction;
-(void)_updateSnappingHeight;
-(void)endRefreshing;
-(void)beginRefreshing;
-(int)refreshControlState;
-(void)_update;
@end

/* Animation delegate, contains only instances of itself and blocks */
@interface _UIRefreshControlAnimationDelegate : NSObject {
    id block;
}

+(_UIRefreshControlAnimationDelegate *)delegateWithCompletionBlock:(id)arg1;
-(void)animationDidStop:(id)arg1 finished:(BOOL)arg2;
-(void)dealloc;
@end

/* Content view, references main RefreshControl in many ways */
@interface _UIRefreshControlContentView : UIView {
    UIRefreshControl *_refreshControl;
    UIColor *_tintColor;
}

@property(readonly) int style;
@property UIRefreshControl *refreshControl;
@property(retain) UIColor *tintColor;
@property(retain) NSAttributedString *attributedTitle;
@property(readonly) float minimumSnappingHeight;
@property(readonly) float maximumSnappingHeight;

// lifecycle
-(void)dealloc;

// view management
-(void)willTransitionFromState:(int)arg1 toState:(int)arg2;
-(void)didTransitionFromState:(int)arg1 toState:(int)arg2;

// setters
-(void)setRefreshControl:(UIRefreshControl *)arg1;
-(void)setTintColor:(UIColor *)arg1;
-(void)setAttributedTitle:(NSAttributedString *)arg1;

// getters
-(int)style;
-(UIRefreshControl *)refreshControl;
-(UIColor *)tintColor;
-(NSAttributedString *)attributedTitle;
-(float)minimumSnappingHeight;
-(float)maximumSnappingHeight;

// checkers
-(float)_heightAtWhichNoneOfTheInterfaceElementsAreVisibleEvenIfTheControlIsStillPartiallyOnScreen;
-(void)refreshControlInvalidatedSnappingHeight;
@end

/* Template of content view (above class), contains references only to other classes */
@interface _UIRefreshControlDefaultContentView : _UIRefreshControlContentView {
    BOOL _animationsAreValid;
    UIImageView *_imageView;
    UILabel *_textLabel;
    UIImageView *_arrow;
    UIActivityIndicatorView *_spinner;
    NSMutableDictionary *_snappingTextFromValues;
    NSMutableDictionary *_snappingImageFromValues;
    NSMutableDictionary *_snappingArrowFromValues;
    BOOL _areAnimationsValid;
}

@property(readonly) UIImageView *imageView;
@property(readonly) UIImageView *arrow;
@property(readonly) UIActivityIndicatorView *spinner;
@property(readonly) UILabel *textLabel;
@property BOOL areAnimationsValid;

// lifecycle
-(_UIRefreshControlDefaultContentView *)initWithFrame:(CGRect)arg1;
-(void)dealloc;

// view management
-(void)didTransitionFromState:(int)arg1 toState:(int)arg2;
-(void)willTransitionFromState:(int)arg1 toState:(int)arg2;
-(CGSize)sizeThatFits:(CGSize)arg1;
- (void)layoutSubviews;

// setters
-(void)setAttributedTitle:(NSAttributedString *)arg1;
-(void)setTintColor:(UIColor *)arg1; // parent class
-(void)setAreAnimationsValid:(BOOL)arg1;

// getters
-(int)style;
-(NSAttributedString *)attributedTitle; // parent class

-(UIImageView *)imageView;
-(UILabel *)textLabel;
-(UIImageView *)arrow;
-(UIActivityIndicatorView *)spinner;
-(float)minimumSnappingHeight; // parent class
-(float)maximumSnappingHeight;

// checkers
-(BOOL)areAnimationsValid;
-(double)_snappingTimeOffset;
-(double)_currentTimeOffset;
-(float)_heightAtWhichNoneOfTheInterfaceElementsAreVisibleEvenIfTheControlIsStillPartiallyOnScreen;
-(void)refreshControlInvalidatedSnappingHeight;

// processes
-(id)_regenerateArrow; // one can assume UIImageView
-(id)_regenerateCircle;
-(void)_updateTimeOffsetOfRelevantLayers;
-(id)_revealingTextAnimations; // UILabel?
-(id)_revealingArrowAnimations;
-(id)_revealingImageAnimations;

// magic
-(void)_spinOutMagic;
-(void)_refreshingMagic;
-(void)_snappingMagic;
-(void)_revealingMagic;
-(void)_fadeInMagic;
@end

/* Another? template of content view (above class), contains references only to other classes */
@interface _UIRefreshControlModernReplicatorView : UIView
+(Class)layerClass;
-(BOOL)_shouldAnimatePropertyWithKey:(id)arg1;
@end

/* Another?! template of content view (above class), contains references only to other classes */
@interface _UIRefreshControlModernContentView : _UIRefreshControlContentView  {
    BOOL _animationsAreValid;
    UIView *_replicatorContainer;
    _UIRefreshControlModernReplicatorView *_replicatorView; // above class
    UIView *_seed;
    BOOL _hasFinishedRevealing;
    UILabel *_textLabel;
    BOOL _areAnimationsValid;
    float _currentPopStiffness;
}

@property(readonly) UILabel *textLabel;
@property float currentPopStiffness;
@property BOOL areAnimationsValid;

// lifecycle
-(_UIRefreshControlModernContentView *)initWithFrame:(CGRect)arg1;
-(void)dealloc;

// view management
-(void)didTransitionFromState:(int)arg1 toState:(int)arg2;
-(void)willTransitionFromState:(int)arg1 toState:(int)arg2;
-(CGSize)sizeThatFits:(CGSize)arg1;
-(void)layoutSubviews;

// setters
-(void)setTintColor:(UIColor *)arg1;
-(void)setAttributedTitle:(NSAttributedString *)arg1;
-(void)setCurrentPopStiffness:(float)arg1;
-(void)setAreAnimationsValid:(BOOL)arg1;

// getters
-(int)style;
-(BOOL)areAnimationsValid;
-(UIColor *)_effectiveTintColor;
-(UILabel *)textLabel;
-(NSAttributedString *)attributedTitle;
-(float)maximumSnappingHeight; // parent class

// checkers
-(float)_effectiveScrollViewHeight;
-(float)_percentageShowing;
-(float)currentPopStiffness;
-(id)_effectiveTintColorWithAlpha:(float)arg1;
-(float)_heightAtWhichNoneOfTheInterfaceElementsAreVisibleEvenIfTheControlIsStillPartiallyOnScreen;

// processes
-(void)_reveal;
-(void)_tick;
-(void)_setSpunAppearance;
-(void)_cleanUpAfterRevealing;
-(void)_goAway;
-(void)_tickDueToProgrammaticRefresh;
-(void)_spin;
-(void)_resetToRevealingState;
-(void)_updateTimeOffsetOfRelevantLayers;
-(double)_currentTimeOffset;

// magic
-(void)_snappingMagic;
@end