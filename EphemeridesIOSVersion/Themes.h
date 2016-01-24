//
//  Themes.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 15/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ephemerides, SousThemes;

@interface Themes : NSManagedObject

@property (nonatomic, retain) NSNumber * iden;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSSet *ephemeridesdutheme;
@property (nonatomic, retain) NSSet *sousthemesrelatifs;
@end

@interface Themes (CoreDataGeneratedAccessors)

- (void)addEphemeridesduthemeObject:(Ephemerides *)value;
- (void)removeEphemeridesduthemeObject:(Ephemerides *)value;
- (void)addEphemeridesdutheme:(NSSet *)values;
- (void)removeEphemeridesdutheme:(NSSet *)values;

- (void)addSousthemesrelatifsObject:(SousThemes *)value;
- (void)removeSousthemesrelatifsObject:(SousThemes *)value;
- (void)addSousthemesrelatifs:(NSSet *)values;
- (void)removeSousthemesrelatifs:(NSSet *)values;

@end
