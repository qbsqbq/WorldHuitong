//
//  AppDelegate.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/1.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HTTabBarController.h"
#import "LLLockViewController.h" //手势密码解锁

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,strong)HTTabBarController *tabBarVC;
@property(nonatomic,retain)LLLockViewController *lockVc; // 添加解锁界面
-(void)showLLLockViewController:(LLLockViewType)type;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

