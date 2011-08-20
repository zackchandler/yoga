#import <UIKit/UIKit.h>

#import "ClassesController.h"

@interface YogaAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *classesNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *classesNavController;

@end
