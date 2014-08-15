//
//  BSDefaultViewObject.m
//  BASE
//
//  Created by Takkun on 2013/04/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSDefaultViewObject.h"

@implementation BSDefaultViewObject

static UIImageView *backgroundImageView = nil;

+ (UIImageView*)setBackground
{
    

    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        UIImage * backgroundImage = [UIImage imageNamed:@"background-568h@2x.png"];
        
        //CGSize newBackgroundSize;
        /*
        newBackgroundSize = CGSizeMake(320, 568);
        UIGraphicsBeginImageContext(newBackgroundSize);
        [backgroundImage drawInRect:CGRectMake(0, 0, newBackgroundSize.width, newBackgroundSize.height)];
        backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
         */
        backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = [[UIScreen mainScreen] bounds];
        
    }else{
        NSString *aImagePath = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"];
        //aImageView.image = [UIImage imageWithContentsOfFile:aImagePath];
        
        UIImage * backgroundImage = [UIImage imageWithContentsOfFile:aImagePath];
        backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = [[UIScreen mainScreen] bounds];
        
    }
    
    return backgroundImageView;
}

+ (NSString*)setApiUrl{
    //本番環境x.x.x-prod-deploy
//    return @"https://dt.thebase.in";
    
    //ステージング環境x.x.x-stg-deploy
//     return @"http://dt.base0.info";
    
    //テスト環境
//    return @"http://api.base0.info";
    
    //テスト環境x.x.x-dev-deploy
//    return @"http://api.n-base.info";
    
    //反社チェック用
    //return @"http://api.upbase.info";
    
    return @"http://54.92.88.238";
    
}

+ (BOOL)isMoreIos7{
    
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    //NSLog(@"iOS %f", iOSVersion);
    if(iOSVersion >= 7.0)
    {
        //iOS 7.0以上の場合
        //NSLog(@"iOS 7.0 or more!");
        return YES;
    }else{
        //NSLog(@"iOS 7.0じゃない場合");
        return NO;
    }
}

+ (void)customNavigationBar:(int)isBuySide{
    
    if ([self isMoreIos7]) {
        [UINavigationBar appearance].tintColor =  [UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0];

    }else{
        //お店買う側のヘッダー
        if (isBuySide == 1) {
            UIImage *image1 = [UIImage imageNamed:@"nav_bar.png"];
            
            [[UINavigationBar appearance] setBackgroundImage:image1 forBarMetrics:UIBarMetricsDefault];
            //[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:249 green:247 blue:248 alpha:1.0]];
            
            
            [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:249.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1]];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
            
            NSDictionary *navbarTitleTextAttributes = @{UITextAttributeTextColor: [UIColor  grayColor],
                                                       UITextAttributeTextShadowColor: [UIColor clearColor],
                                                       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)]};
            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
            
            
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [attributes setValue:[UIColor darkGrayColor] forKey:UITextAttributeTextColor];
            [attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
            [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
        }else{
            //お店管理側のヘッダー
            UIImage *image = [UIImage imageNamed:@"nav_bar_manage.png"];
            
            [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            NSMutableDictionary *attributesNav = [NSMutableDictionary dictionary];
            [attributesNav setValue:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0] forKey:UITextAttributeTextColor];
            [attributesNav setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
            [[UINavigationBar appearance] setTitleTextAttributes:attributesNav];
        }
    }
}


+ (void)setNavigationBar:(UINavigationBar*)navBar{
    if ([BSDefaultViewObject isMoreIos7]) {
        if (navBar.tag == 100) {
            /*
             UIView *colourView = [[UIView alloc] initWithFrame:CGRectMake(0.f, -20.f, 320.f, 64.f)];
             colourView.opaque = NO;
             colourView.alpha = .8f;
             colourView.backgroundColor = [UIColor grayColor];
             */
            navBar.barTintColor = [UIColor grayColor];
            UIColor *backgroundLayerColor = [[UIColor grayColor] colorWithAlphaComponent:0.8f];
            static CGFloat kStatusBarHeight = 20;
            
            CALayer *navBackgroundLayer = [CALayer layer];
            navBackgroundLayer.backgroundColor = [backgroundLayerColor CGColor];
            navBackgroundLayer.frame = CGRectMake(0, -kStatusBarHeight, navBar.frame.size.width,
                                                  kStatusBarHeight + navBar.frame.size.height);
            [navBar.layer addSublayer:navBackgroundLayer];
            // move the layer behind the navBar
            navBackgroundLayer.zPosition = -1;
            
        }else{
            UIView *colourView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 64.f)];
            colourView.opaque = NO;
            colourView.alpha = .8f;
            colourView.backgroundColor = [UIColor grayColor];
            
            navBar.barTintColor = [UIColor grayColor];
            [navBar.layer insertSublayer:colourView.layer atIndex:1];
        }
    }

}




@end



