//
//  Synchroniseur.h
//  project1
//
//  Created by Maryam on 05/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Synchroniseur : NSObject


-(NSArray * ) importFromServerData:(NSData *)datatosave;
//-(void) saveServerDataToLocalBase:(NSManagedObjectContext *)context foridtheme:(NSString*)idtheme;
-(void) initializationDataToLocalBase:(NSManagedObjectContext *)context;
//-(void)synchroniserDonneesEtThemesAPartirDuJour:(NSString*)jour duMois:(NSString*)mois pourcontext:
//(NSManagedObjectContext*)context;
-(void) chargerEphemeridesDuMois;
-(void) chargerEphemeridesApartirDeCeJour;
-(void) saveServerDataToLocalBaseforidtheme:(NSString*)idtheme;
-(void)synchroniserDonneesEtThemesAPartirDuJour:(NSString*)jour duMois:(NSString*)mois;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

