//
//  main.m
//  HappyShare
//
//  Created by scsys on 15/4/30.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [Bmob registerWithAppKey:@"f9759919847dc7b102b496cb120406ad"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
