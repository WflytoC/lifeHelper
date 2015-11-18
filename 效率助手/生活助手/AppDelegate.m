//
//  AppDelegate.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "AppDelegate.h"

#import "SStabBarController.h"
#import "SSpassController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

int flag=0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
    if ([users boolForKey:@"password_notneed"]) {
        self.window.rootViewController=[[SStabBarController alloc] init];
    }else{
        self.window.rootViewController=[[SSpassController alloc] init];
        flag=1;

    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    flag=0;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
    bool need=[users boolForKey:@"password_notneed"];
    
    if (flag==0&&!need) {
        self.window.rootViewController=[[SSpassController alloc] init];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}



@end
