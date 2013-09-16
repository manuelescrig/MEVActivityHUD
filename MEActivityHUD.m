//
//  MEActivityHUD.m
//  eMAGine EDU
//
//  Created by Manuel Escrig Ventura on 9/13/13.
//
//

#import "MEActivityHUD.h"

@implementation MEActivityHUD

#pragma mark - Class methods

static const CGFloat kPadding = 10.0f;
static const CGFloat kTitleFontSize = 17.0f;
static const CGFloat kDescriptionlFontSize = 13.0f;
static const CGFloat kLightBoxAlpha = 0.4f;
static const CGFloat kMessageBoxAlpha = 0.9f;
static const CGFloat kIconSize = 24.0f;
static const CGFloat KAnimationDuration = 0.3f;


CGPoint CGRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


#pragma mark - Class methods


+ (id)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    DebugLog(@"");

	MEActivityHUD *hud = [[self alloc] initWithView:view];
	[view addSubview:hud];
	[hud show:animated];
	return hud;
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    DebugLog(@"");

	MEActivityHUD *hud = [self HUDForView:view];
	if (hud != nil) {
        [hud hide:animated];
		return YES;
	}
	return NO;
}


+ (BOOL)changeHUDForView:(UIView *)view animated:(BOOL)animated withTitle:(NSString *)title withDescription:(NSString *)description andMode:(MBProgressHUDMode)mode
{
    DebugLog(@"");

    MEActivityHUD *hud = [self HUDForView:view];
    
	if (hud != nil) {
        hud.titleLabel.text         = title;
        hud.descriptionLabel.text   = description;
        
        switch (mode) {
            case MEActivityHUDModeIndeterminate: {
                hud.activitiyView.hidden = NO;
                hud.iconViewHolder.hidden = YES;
            }   break;
                
            case MEActivityHUDModeSucced: {
                hud.activitiyView.hidden = YES;
                UIImage *image = [UIImage imageNamed:@"checkmark_icon.png"];
                hud.iconViewHolder.image = image;
            }   break;
                
            case MEActivityHUDModeFailed: {
                hud.activitiyView.hidden = YES;
                UIImage *image = [UIImage imageNamed:@"cross_icon.png"];
                hud.iconViewHolder.image = image;
            }   break;
                
            default:
                break;
        }
        
		return YES;
	}
	return NO;
}

+ (id)showHUDAddedTo:(UIView *)view animated:(BOOL)animated withTime:(float)time
{
    DebugLog(@"");
    
	MEActivityHUD *hud = [[self alloc] initWithView:view];
	[view addSubview:hud];
	[hud show:animated];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Hide
        [hud hide:animated];
    });

	return hud;
}

+ (id)HUDForView:(UIView *)view
{
    DebugLog(@"");

	NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
	for (UIView *subview in subviewsEnum) {
		if ([subview isKindOfClass:self]) {
			return (MEActivityHUD *)subview;
		}
	}
	return nil;
}

#pragma mark - Lifecycle


- (id)initWithView:(UIView *)view
{
    DebugLog(@"");

	NSAssert(view, @"View must not be nil.");
	return [self initWithFrame:view.bounds];
}



- (id)initWithFrame:(CGRect)frame
{
    DebugLog(@"");

    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        float floatLabelPadding = kPadding;
        
        // The light box
        self.lightBoxBackgroundView = [[UIView alloc] initWithFrame:frame];
        [self.lightBoxBackgroundView setBackgroundColor:[UIColor blackColor]];
        [self.lightBoxBackgroundView setHidden:YES];
        [self addSubview:self.lightBoxBackgroundView];
        
        // The message box
        self.messageBoxView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 140.0f)];
        [self.messageBoxView setBackgroundColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f]];
        [self.messageBoxView setHidden:YES];
        [self.messageBoxView setCenter:CGRectCenter(frame)];
        [self.messageBoxView.layer setCornerRadius:10.0f];
        [self addSubview:self.messageBoxView];

        // The title
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(floatLabelPadding, floatLabelPadding, self.messageBoxView.frame.size.width - (floatLabelPadding*2), 30.0f)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:kTitleFontSize]];
        //[self.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.titleLabel setText:@""];
        [self.titleLabel setNumberOfLines:1];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.messageBoxView addSubview:self.titleLabel];
        
        // The description
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(floatLabelPadding, 30.0f, self.messageBoxView.frame.size.width - (floatLabelPadding*2), 60.0f)];
        [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:kDescriptionlFontSize]];
        //[self.descriptionLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.descriptionLabel setText:@""];
        [self.descriptionLabel setNumberOfLines:3];
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        [self.messageBoxView addSubview:self.descriptionLabel];
        
        // The activity view
        self.activitiyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activitiyView setFrame:CGRectMake(140-12, 100, kIconSize, kIconSize)];
        [self.activitiyView startAnimating];
        [self.messageBoxView addSubview:self.activitiyView];
        
        // The icon view
        self.iconView = [[UIView alloc] initWithFrame:CGRectMake(floatLabelPadding, 90.0f, self.messageBoxView.frame.size.width - (floatLabelPadding*2), 40.0f)];
        [self.iconView setBackgroundColor:[UIColor clearColor]];
        [self.iconView setHidden:NO];
        [self.messageBoxView addSubview:self.iconView];
        
        // The icon view holder
        self.iconViewHolder = [[UIImageView alloc] initWithFrame:CGRectMake(((self.messageBoxView.frame.size.width - (floatLabelPadding*2))/2)-(kIconSize/2), kIconSize/2, kIconSize, kIconSize)];
        [self.iconViewHolder setBackgroundColor:[UIColor clearColor]];
        [self.iconViewHolder setHidden:NO];
        [self.iconView addSubview:self.iconViewHolder];
    }
    
    return self;
}



#pragma mark - Show & hide


- (void)show:(BOOL)animated 
{
    [self.lightBoxBackgroundView    setAlpha:0.0f];
    [self.messageBoxView            setAlpha:0.0f];
    [self.titleLabel                setAlpha:0.0f];
    [self.descriptionLabel          setAlpha:0.0f];
    [self.activitiyView             setAlpha:0.0f];
    [self.iconView                  setAlpha:0.0f];
    
    [self.lightBoxBackgroundView    setHidden:NO];
    [self.messageBoxView            setHidden:NO];
    [self.titleLabel                setHidden:NO];
    [self.descriptionLabel          setHidden:NO];
    
    // Delay execution
    float floatAnimationBoxPadding = kPadding;
    
    CGRect oldFrame = self.messageBoxView.frame;
    [self.messageBoxView setFrame:CGRectMake(oldFrame.origin.x - floatAnimationBoxPadding, oldFrame.origin.y - floatAnimationBoxPadding, oldFrame.size.width + (floatAnimationBoxPadding*2), oldFrame.size.height + (floatAnimationBoxPadding*2))];
    
    [UIView animateWithDuration: animated ? KAnimationDuration : 0.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.titleLabel               setAlpha:1.0f];
                         [self.descriptionLabel         setAlpha:1.0f];
                         [self.activitiyView            setAlpha:1.0f];
                         [self.iconView                 setAlpha:1.0f];
                         [self.lightBoxBackgroundView   setAlpha:kLightBoxAlpha];
                         [self.messageBoxView           setAlpha:kMessageBoxAlpha];
                         [self.messageBoxView           setFrame:oldFrame];
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}


- (void)hide:(BOOL)animated
{
    DebugLog(@"");
    
    float floatAnimationBoxPadding = kPadding;
    
    CGRect oldFrame         = self.messageBoxView.frame;
    [self.titleLabel        setAlpha:0.0f];
    [self.descriptionLabel  setAlpha:0.0f];
    [self.activitiyView     setAlpha:0.0f];
    [self.iconView          setAlpha:0.0f];
    
    [UIView animateWithDuration:animated ? KAnimationDuration : 0.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.messageBoxView setAlpha:0.0f];
                         [self.messageBoxView setFrame:CGRectMake(oldFrame.origin.x + floatAnimationBoxPadding, oldFrame.origin.y + floatAnimationBoxPadding, oldFrame.size.width - (floatAnimationBoxPadding*2), oldFrame.size.height - (floatAnimationBoxPadding*2))];
                         
                     }
                     completion:^(BOOL finished) {
                         [self.messageBoxView removeFromSuperview];
                         [self.lightBoxBackgroundView removeFromSuperview];
                         [self removeFromSuperview];
                     }];
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
