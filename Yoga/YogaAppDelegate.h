#import <UIKit/UIKit.h>

#import "ClassesController.h"

@interface YogaAppDelegate : NSObject <UIApplicationDelegate> {
    ClassesController *classesController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ClassesController *classesController;

@end
