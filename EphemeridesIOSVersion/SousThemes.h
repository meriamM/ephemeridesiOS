//
//  SousThemes.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 15/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Themes;

@interface SousThemes : NSManagedObject

@property (nonatomic, retain) NSNumber * iden;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) Themes *themeparent;

@end
