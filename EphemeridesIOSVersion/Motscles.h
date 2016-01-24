//
//  Motscles.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 15/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ephemerides;

@interface Motscles : NSManagedObject

@property (nonatomic, retain) NSNumber * iden;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSSet *ephemeridesdumotcle;
@end

@interface Motscles (CoreDataGeneratedAccessors)

- (void)addEphemeridesdumotcleObject:(Ephemerides *)value;
- (void)removeEphemeridesdumotcleObject:(Ephemerides *)value;
- (void)addEphemeridesdumotcle:(NSSet *)values;
- (void)removeEphemeridesdumotcle:(NSSet *)values;

@end
