//
//  main.m
//  InstallServerCertOnSimulator
//
//  Created by yanguo sun on 2017/8/4.
//  Copyright © 2017年 Lvmama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NSURL *getCertAtHost(NSString *host) {
    NSString *logFileName = [host stringByAppendingString:@".cer"];
    NSString *logFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:logFileName];
    NSArray *commandArray =  @[@"echo | openssl s_client -connect ", host, @":443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ", logFilePath];
    NSString *commandString = [commandArray componentsJoinedByString:@""];
    system([commandString UTF8String]);
    NSURL *logFileUrl = [NSURL fileURLWithPath:logFilePath];
    //    NSString *logFileContent = [NSString stringWithContentsOfURL:logFileUrl encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",logFileUrl.absoluteString);
    return logFileUrl;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *host = [NSString stringWithFormat:@"%s",argv[1]];
        if (![host containsString:@"."]) {
            NSLog(@"need host");
            return 0;
        }
        NSURL *certUrl = getCertAtHost(host);
        //        NSLog(@"%@",certString);


        //        return 0;

        NSString *appPath = @"/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app";
        //        appPath = @"/Applications/TextMate.app";
        NSString *appBundleIdentifier = @"com.apple.iphonesimulator";
        //        appBundleIdentifier = @"com.macromates.TextMate";
        [[NSWorkspace sharedWorkspace] launchApplication:appPath];

        NSArray<NSRunningApplication *> *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:appBundleIdentifier];
        for (NSRunningApplication *app in apps) {
            //            NSLog(@"%@",app.executableURL);
            //            NSLog(@"%@",@(app.isFinishedLaunching));
            [app activateWithOptions:NSApplicationActivateAllWindows];

        }
        NSError *error = nil;
        NSPropertyListFormat format;
        NSDictionary *dic = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[@"~/Library/Preferences/com.apple.iphonesimulator.plist" stringByStandardizingPath]] options:NSPropertyListMutableContainersAndLeaves format:&format error:&error];
        NSLog(@"%@",apps);
        NSString *CurrentDeviceUDID = dic[@"CurrentDeviceUDID"];
        NSString *commandString = [NSString stringWithFormat:@"xcrun simctl openurl %@ %@",CurrentDeviceUDID, certUrl.absoluteString];
        int ret =  system([commandString UTF8String]);
        while (ret != 0) {
            sleep(1);
            ret = system([commandString UTF8String]);
        }
        
    }
    return 0;
}
