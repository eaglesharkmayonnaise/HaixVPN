#import <UIKit/UIKit.h>

@interface WSTextView : UITextView
/** 占位文字 */
@property (nonatomic,copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic,strong) UIColor *placeholderColor;
@end
