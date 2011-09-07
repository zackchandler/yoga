#import "KIFTestScenario+YogaAdditions.h"

@implementation KIFTestScenario (YogaAdditions)

+ (id)scenarioToTestClassScheduleDisplay {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the class schedule is shown"];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"ClassesTableView"]];
    
    // [scenario addStep:[KIFTestStep stepToReset]];
    // [scenario addStepsFromArray:[KIFTestStep stepsToGoToLoginPage]];
    // [scenario addStep:[KIFTestStep stepToEnterText:@"user@example.com" intoViewWithAccessibilityLabel:@"Login User Name"]];
    // [scenario addStep:[KIFTestStep stepToEnterText:@"thisismypassword" intoViewWithAccessibilityLabel:@"Login Password"]];
    // [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log In"]];
    // 
    // // Verify that the login succeeded
    // [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Welcome"]];

    return scenario;
}

@end