#import "BioID.h"
#import <React/RCTUtils.h>
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_X (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0f)

@implementation TouchID

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(isSupported: (RCTResponseSenderBlock)callback)
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        callback(@[[NSNull null], [self getBiometryType:context]]);
        // Device does not support TouchID
    } else {
        if (IS_IPHONE_X && (long)error.code == -6) {
            callback(@[RCTMakeError(@"RCTFaceIDNotAllowed", nil, nil)]);
            return;
        }
        callback(@[RCTMakeError(@"RCTTouchIDNotSupported", nil, nil)]);
        return;
    }
}

RCT_EXPORT_METHOD(authenticate: (NSString *)reason
                  callback: (RCTResponseSenderBlock)callback)
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    
    // Device has TouchID
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        // Attempt Authentification
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reason
                          reply:^(BOOL success, NSError *error)
         {
             // Failed Authentication
             if (error) {
                 NSString *errorReason;
                 
                 switch (error.code) {
                     case LAErrorAuthenticationFailed:
                         errorReason = @"LAErrorAuthenticationFailed";
                         break;
                         
                     case LAErrorUserCancel:
                         errorReason = @"LAErrorUserCancel";
                         break;
                         
                     case LAErrorUserFallback:
                         errorReason = @"LAErrorUserFallback";
                         break;
                         
                     case LAErrorSystemCancel:
                         errorReason = @"LAErrorSystemCancel";
                         break;
                         
                     case LAErrorPasscodeNotSet:
                         errorReason = @"LAErrorPasscodeNotSet";
                         break;
                         
                     case LAErrorTouchIDNotAvailable:
                         errorReason = @"LAErrorTouchIDNotAvailable";
                         break;
                         
                     case LAErrorTouchIDNotEnrolled:
                         errorReason = @"LAErrorTouchIDNotEnrolled";
                         break;
                         
                     default:
                         errorReason = @"RCTTouchIDUnknownError";
                         break;
                 }
                 
                 NSLog(@"Authentication failed: %@", errorReason);
                 callback(@[RCTMakeError(errorReason, nil, nil)]);
                 return;
             }
             
             // Authenticated Successfully
             callback(@[[NSNull null], @"Authenticat with Touch ID."]);
         }];
        
        // Device does not support TouchID
    } else {
        callback(@[RCTMakeError(@"RCTTouchIDNotSupported", nil, nil)]);
        return;
    }
}

- (NSString *)getBiometryType:(LAContext *)context
{
    if (@available(iOS 11, *)) {
        return context.biometryType == LABiometryTypeFaceID ? @"FaceID" : @"TouchID";
    }
    
    return @"TouchID";
}

@end
