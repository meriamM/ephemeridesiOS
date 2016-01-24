//
//  Types.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 15/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ephemerides;

@interface Types : NSManagedObject

@property (nonatomic, retain) NSNumber * iden;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSSet *ephemeridesdutype;
@end

@interface Types (CoreDataGeneratedAccessors)

- (void)addEphemeridesdutypeObject:(Ephemerides *)value;
- (void)removeEphemeridesdutypeObject:(Ephemerides *)value;
- (void)addEphemeridesdutype:(NSSet *)values;
- (void)removeEphemeridesdutype:(NSSet *)values;

@end
