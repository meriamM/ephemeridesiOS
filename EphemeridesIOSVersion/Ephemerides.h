//
//  Ephemerides.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 15/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Motscles, Themes, Types;

@interface Ephemerides : NSManagedObject

@property (nonatomic, retain) NSNumber * annee;
@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) NSNumber * iden;
@property (nonatomic, retain) NSNumber * jour;
@property (nonatomic, retain) NSString * liens;
@property (nonatomic, retain) NSNumber * mois;
@property (nonatomic, retain) NSNumber * priorite;
@property (nonatomic, retain) NSString * titre;
@property (nonatomic, retain) Themes *lethemedelephemeride;
@property (nonatomic, retain) Types *letypedelephemeride;
@property (nonatomic, retain) NSSet *motsclesdelephemeride;
@end

@interface Ephemerides (CoreDataGeneratedAccessors)

- (void)addMotsclesdelephemerideObject:(Motscles *)value;
- (void)removeMotsclesdelephemerideObject:(Motscles *)value;
- (void)addMotsclesdelephemeride:(NSSet *)values;
- (void)removeMotsclesdelephemeride:(NSSet *)values;

@end
