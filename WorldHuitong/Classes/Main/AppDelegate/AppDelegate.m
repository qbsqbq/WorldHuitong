//
//  AppDelegate.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/1.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//
#define ShareAppID @"11b03da2d0015"

#import "AppDelegate.h"
#import "UserGuideViewController.h"
#import "HTTabBarController.h"

//指纹解锁
#import "TouchWindow.h"

//ShareSDK头文件
#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate ()
@property (nonatomic, strong) TouchWindow *touchWindow;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) int *time;



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    //0.添加启动图
    [self addlendPagesImage];
    
    //1.初始化ShareSDK应用
    [ShareSDK registerApp:ShareAppID];
    
    //2. 初始化社交平台
    [self initializePlat];
     
    //3.开启指纹/手势解锁
    [self touchIDAction];
    [self openShouShiAction];
    
    //4.检测网络
    [HTView isWiffOnView:self.window];
    

    return YES;
}

-(void)addlendPagesImage
{
    //0.添加启动图
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        UserGuideViewController* userGuideVC = [[UserGuideViewController alloc] init];
        UINavigationController  *navigation=[[UINavigationController alloc]initWithRootViewController:userGuideVC];
        self.window.rootViewController = navigation;
        
    }else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HTTabBarController *detail = [storyboard instantiateViewControllerWithIdentifier:@"HTTabBarController"];
        self.window.rootViewController = detail;
        
    }
    
    [self.window makeKeyAndVisible];

}

-(void)initializePlat
{
    //1.连接新浪微博开放平台
    [ShareSDK connectSinaWeiboWithAppKey:@"104142196"
                               appSecret:@"f7a372a75c135745218f98d231552408"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"
                             weiboSDKCls:[WeiboSDK class]];
//    [ShareSDKConnector connectWeibo:[WeiboSDK class]];

    
    //2.连接微信应用以使用相关功能
    [ShareSDK connectWeChatWithAppId:@"wxbd62832b33284fdc"
                           appSecret:@"2f431d9fcf00a425fd3c60c721df5388"
                           wechatCls:[WXApi class]];
    
    
    //3. 连接QQ空间应用以使用相关功能
    [ShareSDK connectQZoneWithAppKey:@"1105269147"
                           appSecret:@"apf4yTQ6LqrUZCPR"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //4. 连接QQ应用以使用相关功能
    [ShareSDK connectQQWithQZoneAppKey:@"1105269147"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //5.连接短信分享
    [ShareSDK connectSMS];
    
    
    //6.连接拷贝
    [ShareSDK connectCopy];
    
       
}

#pragma mark - 如果使用SSO（可以简单理解成跳客户端授权），以下方法是必要的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {

    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

-(void)scrollTimer
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

//开启指纹解锁
-(void)touchIDAction
{
    BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:@"OntouchId"];
    
    if (on) {
        
        //打开指纹解锁
        if (self.window.rootViewController.presentingViewController == nil) {
            
            self.touchWindow = [[TouchWindow alloc] initWithFrame:self.window.frame];
            [self.touchWindow show];
            
        }else{
            
        }
    }
}

//开启手势解锁
-(void)openShouShiAction
{
    NSString *pswd = [LLLockPassword loadLockPassword];
    
    if (pswd) {
        [self showLLLockViewController:LLLockViewTypeCheck];
    }else
    {
        //        [self showLLLockViewController:LLLockViewTypeCreate];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
        
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "HT.WorldHuitong" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WorldHuitong" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WorldHuitong.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


//创建手势密码
-(void)showLLLockViewController:(LLLockViewType)type
{
    /**Unbalanced calls to begin/end appearance transitions for <UINavigationController: 0x7fa98281fa00>.**/
    if (self.window.rootViewController.presentingViewController == nil) {
        self.lockVc = [[LLLockViewController alloc]init];
        self.lockVc.nLockViewType = type;
        self.lockVc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.window.rootViewController presentViewController:self.lockVc animated:NO completion:^{
//            LLLog(@"创建了一个pop=%@", self.lockVc);
            
        }];
    }
    
    
}

@end
