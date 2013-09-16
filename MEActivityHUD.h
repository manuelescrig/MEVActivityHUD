//
//  MEActivityHUD.h
//  eMAGine EDU
//
//  Created by Manuel Escrig Ventura on 9/13/13.
//
//

#import <UIKit/UIKit.h>

typedef enum {
	/** Progress is shown using an UIActivityIndicatorView. This is the default. */
    MEActivityHUDModeIndeterminate,
	/** A thick image is shown. */
	MEActivityHUDModeSucced,
    /** A cross image is shown. */
	MEActivityHUDModeFailed

} MBProgressHUDMode;


@interface MEActivityHUD : UIView

@property (nonatomic, strong) UIView *lightBoxBackgroundView;               // The light box background view
@property (nonatomic, strong) UIView *messageBoxView;                       // The message box view
@property (nonatomic, strong) UILabel *titleLabel;                          // The label for the title
@property (nonatomic, strong) UILabel *descriptionLabel;                    // The label for the description
@property (nonatomic, strong) UIView *iconView;                             // The view for the icon in the message box
@property (nonatomic, strong) UIImageView *iconViewHolder;                  // The view for the icon in the message box
@property (nonatomic, strong) UIActivityIndicatorView *activitiyView;       // The activity indicador


+ (id)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+ (id)showHUDAddedTo:(UIView *)view animated:(BOOL)animated withTime:(float)time;
+ (BOOL)changeHUDForView:(UIView *)view animated:(BOOL)animated withTitle:(NSString *)title withDescription:(NSString *)description andMode:(MBProgressHUDMode)mode;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
+ (id)HUDForView:(UIView *)view;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
