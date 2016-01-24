//
//  Synchroniseur.m
//  project1
//
//  Created by Maryam on 05/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import "Synchroniseur.h"
#import "Ephemerides.h"
#import "Themes.h"
#import "Types.h"
#import "SousThemes.h"
#import "Motscles.h"
#import "EphemeridesAppDelegate.h"

#define EPHEMERIDESINITIAL [NSURL URLWithString:@"http://localhost:8888/pcd/ephemeridesinitial.php"]
#define EPHEMERIDES [NSURL URLWithString:@"http://localhost:8888/pcd/ephemerides.php"]
#define THEMES [NSURL URLWithString:@"http://localhost:8888/pcd/Themes.php"]
#define SOUSTHEMES [NSURL URLWithString:@"http://localhost:8888/pcd/SousThemes.php"]
#define MOTSCLES [NSURL URLWithString:@"http://localhost:8888/pcd/Motscles.php"]
#define TYPES [NSURL URLWithString:@"http://localhost:8888/pcd/Types.php"]

@implementation Synchroniseur



//une méthode qui reccupère les données d'un document JSON et les stocke dans un tableau
//on suppose que pour chaque table, il existe un fichier JSON séparé




-(NSArray *)importFromServerData:(NSData *)datatosave{
    
    NSError* err = nil;
    NSArray *importe = [NSJSONSerialization JSONObjectWithData:datatosave options:kNilOptions error:&err];
    NSLog(@"Imported from server: %@", importe);
    return importe;
    
}
-(NSData*)sendidClientPourJour:(NSString*)jour pourMois:(NSString*)mois{
    @try {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *idclient=[defaults objectForKey:@"idclient"];
        NSURL *url=[[NSURL alloc] init];
        
        NSLog(@"idclient default %@",idclient);
        
        NSString *post =[[NSString alloc] initWithFormat:@"jour=%@&mois=%@&idclient=%@",jour,mois,idclient];
        url=EPHEMERIDESINITIAL;
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
       // NSLog(@"%@",postData); //coder les données en ASCCI
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        
        //les données de la page php résultat sont stockés dans urldata
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
       // NSLog(@"%@",urlData);
        return urlData;
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        
    }

}

-(NSData*)sendIdClientandidtheme:(NSString*)idtheme{
    @try {
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *idclient=[defaults objectForKey:@"idclient"];
        NSURL *url=[[NSURL alloc] init];
        
        NSLog(@"idclient default %@",idclient);
        
        NSString *post =[[NSString alloc] initWithFormat:@"idtheme=%@&idclient=%@",idtheme,idclient];
        url=EPHEMERIDES;
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
       // NSLog(@"%@",postData); //coder les données en ASCCI
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        
        //les données de la page php résultat sont stockés dans urldata
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
       // NSLog(@"%@",urlData);
        return urlData;
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        
    }
    
    
}

//************** Fonction pour géréer les modifications des themes******************************************
//**********************************************************************************************************

-(void) saveServerDataToLocalBaseforidtheme:(NSString*)idtheme
{   NSLog(@"Saving data...");
    NSData *data=[[NSData alloc] init];;
    NSArray *importe= [[NSArray alloc] init]; 
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init]; //pour convertir la chaine en entier
     [f setNumberStyle:NSNumberFormatterNoStyle];
    
 
    //*****************************Les ephemerides*****************************************************
    
    data =[self sendIdClientandidtheme:idtheme];
    importe= [self importFromServerData: data];
    //NSManagedObjectContext *context = [self managedObjectContext];
    EphemeridesAppDelegate *appDelegate=(EphemeridesAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
   
  
    
    [importe enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Ephemerides *event = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Ephemerides"
                              inManagedObjectContext:context];
     
        event.iden = [f numberFromString:[obj objectForKey:@"id"]];
        event.titre = [obj objectForKey:@"titre"];
        event.jour = [f numberFromString:[obj objectForKey:@"jour"]];
        event.mois = [f numberFromString:[obj objectForKey:@"mois"]];
        event.annee = [f numberFromString:[obj objectForKey:@"annee"]];
        event.descrip = [obj objectForKey:@"description"];
        event.liens =[obj objectForKey:@"lien"];
        event.priorite =[f numberFromString:[obj objectForKey:@"priorite"]];
        NSLog(@"%@",event.titre);
    
        NSError *error;
         if (![context save:&error]) {
         NSLog(@"problème lors de la sauvgarde des Ephemerides: %@", [error localizedDescription]);
         } 
    }];
    
}
//une initialization de la base lorsqu'un utilisateur s'enregistre

-(void) initializationDataToLocalBase:(NSManagedObjectContext *)context{
    
    NSData *data=[[NSData alloc] init];;
    NSArray *importe= [[NSArray alloc] init];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init]; //pour convertir la chaine en entier
    [f setNumberStyle:NSNumberFormatterNoStyle];
    

    //*****************************Les motsclés*****************************************************
    
    data =[ NSData dataWithContentsOfURL: MOTSCLES];
    
    importe= [self importFromServerData: data];
    
    [importe enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Motscles *lemotcle = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Motscles"
                              inManagedObjectContext:context];
        
        
        lemotcle.iden = [f numberFromString:[obj objectForKey:@"id"]];
        lemotcle.nom = [obj objectForKey:@"nom"];
        //NSLog(@"%@",lemotcle.nom);
        
        
    }];
    
    //*****************************Les types*****************************************************
    
    data =[ NSData dataWithContentsOfURL: TYPES];
    
    importe= [self importFromServerData: data];
    
    [importe enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Types *letype = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Types"
                         inManagedObjectContext:context];
        
        letype.iden = [f numberFromString:[obj objectForKey:@"id"]];
        letype.nom = [obj objectForKey:@"nom"];
        
        
    }];

    
}

//**************Fonction pour synchroniser les donnees au login ou au début de mois**********************
//**********************************************************************************************************

-(void)synchroniserDonneesEtThemesAPartirDuJour:(NSString*)jour duMois:(NSString*)mois{
    //tout supprimer de la base locale
    EphemeridesAppDelegate *appDelegate=(EphemeridesAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSData *data=[[NSData alloc] init];;
    NSArray *importe= [[NSArray alloc] init];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init]; //pour convertir la chaine en entier
    [f setNumberStyle:NSNumberFormatterNoStyle];
    
    [self initializationDataToLocalBase:context];
    
    //*****************************Les Themes*****************************************************
    
    data =[ NSData dataWithContentsOfURL: THEMES];
    importe= [self importFromServerData: data];
    
    [importe enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Themes *letheme = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Themes"
                           inManagedObjectContext:context];
        
        letheme.iden = [f numberFromString:[obj objectForKey:@"id"]];
        letheme.nom = [obj objectForKey:@"nom"];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"problème lors de la sauvgarde des Ephemerides: %@", [error localizedDescription]);
        }
    }];
    
    //*******ephemerides
    
    data =[self sendidClientPourJour:jour pourMois:mois];
    importe= [self importFromServerData: data];
    
    [importe enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Ephemerides *event = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Ephemerides"
                              inManagedObjectContext:context];
        
        event.iden = [f numberFromString:[obj objectForKey:@"id"]];
        event.titre = [obj objectForKey:@"titre"];
        event.jour = [f numberFromString:[obj objectForKey:@"jour"]];
        event.mois = [f numberFromString:[obj objectForKey:@"mois"]];
        event.annee = [f numberFromString:[obj objectForKey:@"annee"]];
        event.descrip = [obj objectForKey:@"description"];
        event.liens =[obj objectForKey:@"lien"];
        event.priorite =[f numberFromString:[obj objectForKey:@"priorite"]];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"problème lors de la sauvgarde des Ephemerides: %@", [error localizedDescription]);
        }
    }];
    
    
}

//*************************Méthode pour charger les éphémérides chaque début de mois************************
//**********************************************************************************************************
-(void) chargerEphemeridesDuMois
{
    NSDate *date=[NSDate date];
    NSCalendar *calendrier = [NSCalendar currentCalendar];
    NSDateComponents *composants = [calendrier
                                    components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                                                NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit) fromDate:date];
    /* test current date and components
     NSLog(@"Nous sommes le %i / %i / %i", [composants day], [composants month], [composants year]);
     NSLog(@"Il est %i : %i : %i", [composants hour], [composants minute], [composants second]);
     */
    NSLog(@"aujourd'hui est %@",date);
     
    
    //***********************partie vérification du début de mois (reach out the server)***************************
    if ([composants day]==1) {
     
        NSString *mois=[NSString stringWithFormat: @"%d", (int)[composants month]];
        EphemeridesAppDelegate *appdelegate=[[EphemeridesAppDelegate alloc] init];
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        [self synchroniserDonneesEtThemesAPartirDuJour:@"1" duMois:@"1"];
    } else {
        //***********************partie vérification du début du jour (reach out the local base)***********************
        
        
        NSLog(@"autre jour du mois");
        
    }
}

-(void) chargerEphemeridesApartirDeCeJour
{
    NSDate *date=[NSDate date];
    NSCalendar *calendrier = [NSCalendar currentCalendar];
    NSDateComponents *composants = [calendrier
                                    components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                                                NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit) fromDate:date];
    /* test current date and components
     NSLog(@"Nous sommes le %i / %i / %i", [composants day], [composants month], [composants year]);
     NSLog(@"Il est %i : %i : %i", [composants hour], [composants minute], [composants second]);
     */
   // NSLog(@"aujourd'hui est %@",date);
    
    
    //***********************partie vérification du début de mois (reach out the server)***************************
    
        
        
        EphemeridesAppDelegate *appdelegate=[[EphemeridesAppDelegate alloc] init];
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        NSString *jour=[NSString stringWithFormat: @"%d", (int)[composants day]];
        NSString *mois=[NSString stringWithFormat: @"%d", (int)[composants month]];
        [self synchroniserDonneesEtThemesAPartirDuJour:jour duMois:mois];
  
}


@end
