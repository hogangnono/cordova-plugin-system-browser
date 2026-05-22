#import <Cordova/CDVPlugin.h>
#import <SafariServices/SafariServices.h>

@interface CDVSystemBrowser : CDVPlugin
- (void)openExternal:(CDVInvokedUrlCommand*)command;
- (void)openSheet:(CDVInvokedUrlCommand*)command;
@end
