//
//  EphemeridesAppDelegate.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 15/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EphemeridesAppDelegate : UIResponder <UIApplicationDelegate> 

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
