#import "CDVSystemBrowser.h"

@implementation CDVSystemBrowser

- (NSURL*)validateURL:(NSString*)urlStr command:(CDVInvokedUrlCommand*)command {
    if (!urlStr) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"URL is required"] callbackId:command.callbackId];
        return nil;
    }
    NSURL* url = [NSURL URLWithString:urlStr];
    NSString* scheme = [url.scheme lowercaseString];
    if (!url || (![scheme isEqualToString:@"http"] && ![scheme isEqualToString:@"https"])) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Only http/https URLs are supported"] callbackId:command.callbackId];
        return nil;
    }
    return url;
}

- (void)openExternal:(CDVInvokedUrlCommand*)command {
    NSURL* url = [self validateURL:[command argumentAtIndex:0] command:command];
    if (!url) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            CDVPluginResult* result = success
                ? [CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                : [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to open URL"];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];
    });
}

- (void)openSheet:(CDVInvokedUrlCommand*)command {
    NSURL* url = [self validateURL:[command argumentAtIndex:0] command:command];
    if (!url) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        SFSafariViewController* sfvc = [[SFSafariViewController alloc] initWithURL:url];
        sfvc.modalPresentationStyle = UIModalPresentationPageSheet;
        [[self topViewController] presentViewController:sfvc animated:YES completion:nil];
    });

    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

// Cordova IAB는 별도 UIWindow(tmpWindow)에서 동작하므로 keyWindow 기준으로 최상단 VC를 찾는다.
// IAB가 열리면 tmpWindow가 makeKeyAndVisible되어 keyWindow가 됨.
- (UIViewController*)topViewController {
    UIWindow* keyWindow = nil;
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    UIViewController* vc = keyWindow.rootViewController ?: self.viewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

@end
