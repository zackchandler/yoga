#import <UIKit/UIKit.h>

#import "ClassesController.h"

#if RUN_KIF_TESTS
#import "YogaTestController.h"
#endif

@interface YogaAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *classesNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *classesNavController;

@end
