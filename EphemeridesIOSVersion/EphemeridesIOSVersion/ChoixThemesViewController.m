//
//  ChoixThemesViewController.m
//  EphemeridesIOSVersion
//
//  Created by Maryam on 22/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import "ChoixThemesViewController.h"
#import "ClientViewController.h"
#import "Synchroniseur.h"

#define ClientChoixThemesinsert [NSURL URLWithString:@"http://localhost:8888/pcd/ChoixThemesinsert.php"]
#define ClientChoixThemesdelete [NSURL URLWithString:@"http://localhost:8888/pcd/ChoixThemesdelete.php"]
#define EPHEMERIDES [NSURL URLWithString:@"http://localhost:8888/pcd/ephemerides.php"]
#define ReccupereChoix [NSURL URLWithString:@"http://localhost:8888/pcd/reccupererChoixThemes.php"]
#import "EphemeridesAppDelegate.h"

@interface ChoixThemesViewController ()

@end

@implementation ChoixThemesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [self changerlesSwitches];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onOffSwitch:(UISwitch *)theswitch{
    
    NSLog(@"%@ was toggled!",theswitch.accessibilityLabel);
    [self enregistrerThemeModifie: theswitch cocheoDecoche:(theswitch.on)];
    [self synchroniserDonneesduThemeModifie:theswitch cocheoDecoche:(theswitch.on)];
    
}
-(void)enregistrerThemeModifie:(UISwitch*)leSwitch cocheoDecoche:(BOOL)etat{
        //ClientViewController *c=[[ClientViewController alloc] init];
        NSInteger success = 0;
        NSURL *url=[[NSURL alloc] init]; //url pour insérer ou supprimer les choix du theme en question    
        @try {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSNumber *idclient=[defaults objectForKey:@"idclient"];
            NSLog(@"idclient default %@",idclient);
            NSString *post =[[NSString alloc] initWithFormat:@"idtheme=%@&idclient=%@", leSwitch.accessibilityLabel,idclient]; 
            NSLog(@"envois des donnees au serveur: %@",post);
            if (etat==YES) {
                
            //entrer les donnees
            url=ClientChoixThemesinsert; //la page qui va renvoyer le succès ou l'echec selon les données entrées
            //synchroniser les donnes
    
        
            }
            else{
            
            url=ClientChoixThemesdelete;
            
            }
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSLog(@"%@",postData); //coder les données en ASCCI
            
            
            //la requete!
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:postData];
            
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            
            //les données de la page php résultat sont stockés dans urldata
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            NSLog(@"%@",urlData);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                //encoder les données
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                
                
                success = [jsonData[@"success"] integerValue];
                NSLog(@"Success: %ld",(long)success);
                
                if(success == 1)
                {   
                    NSLog(@" Changement theme SUCCESS");
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Succes est 0!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connexion échouée" :@"pas de reponse!" :0];
            }
        }

            
        
        @catch (NSException *e) {
            NSLog(@"Exception: %@", e);
            [self alertStatus:@"connexion échouée." :@"Erreur due à une exception" :0]; //l'erreur est probablement au niveau code php ou la base
            
        }
       
}


//une procedure se chargeant de synchroniser les donnes pour le theme modifier (supprimer ou importer)

-(void)synchroniserDonneesduThemeModifie:(UISwitch*)leSwitch cocheoDecoche:(BOOL)etat{
    if(etat==YES)
    {
   // EphemeridesAppDelegate *appdelegate=(EphemeridesAppDelegate *)[[UIApplication sharedApplication]delegate];
    Synchroniseur *s=[[Synchroniseur alloc] init];
  //  NSData *data =[ NSData dataWithContentsOfURL: EPHEMERIDES];
    // NSLog(@"hi");
   // NSArray *importe= [ s importFromServerData: data];
    //NSLog(@"Imported from server: %@", importe);
    // [s test];
    // Override pointfor customization after application launch.
   // NSManagedObjectContext *context = [appdelegate managedObjectContext];
       
    //context = [appdelegate managedObjectContext];
    [s saveServerDataToLocalBaseforidtheme:leSwitch.accessibilityLabel];
    }
    else{
        NSLog(@"encore a implementer la suppression");
    }


}





- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}




- (IBAction)continuez:(id)sender {
    //test du bouton de synchronisation
    EphemeridesAppDelegate *appdelegate=(EphemeridesAppDelegate *)[[UIApplication sharedApplication]delegate];
     NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    Synchroniseur *s=[[Synchroniseur alloc] init];
    
    [s synchroniserDonneesEtThemesAPartirDuJour:@"1" duMois:@"1"];

//   */
   
   }

//////////////////************************
//fonction poura garder les switches dans leurs états

-(void)verifierThemesExistantsPourChargerEtatDesSwitchs{
    __block int i;
    //   NSData *data =[ NSData dataWithContentsOfURL: ReccupereChoix];
    
    NSURL *url=[[NSURL alloc] init]; //url pour insérer ou supprimer les choix du theme en question
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *idclient=[defaults objectForKey:@"idclient"];
        NSLog(@"idclient default %@",idclient);
        NSString *post =[[NSString alloc] initWithFormat:@"idclient=%@", idclient];
        NSLog(@"envois des donnees au serveur: %@",post);
        
            
            //entrer les donnees
            url=ReccupereChoix;
            
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSLog(@"%@",postData); //coder les données en ASCCI
        
        
        //la requete!
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        
        //les données de la page php résultat sont stockés dans urldata
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        NSLog(@"%@",urlData);
        
        if ([response statusCode] >= 200 && [response statusCode] < 300)
        {       NSNumberFormatter * f = [[NSNumberFormatter alloc] init]; //pour convertir la chaine en entier
            [f setNumberStyle:NSNumberFormatterNoStyle];
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            
           
            //encoder les données
            Synchroniseur *s=[[Synchroniseur alloc] init];
            
            NSArray *importe= [s importFromServerData: urlData];
            
                
                [importe enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                   
                    
                    i =[[obj objectForKey:@"idTheme"] intValue];
                    NSLog(@"idTheme est %d",i);
                     //i=(int)labelduswitch;

                    NSLog(@"%d",i);
                    switch (i) {
                        case 1:
                            [defaults setBool:YES forKey:@"1"];
                            [defaults synchronize];
                            
                            break;
                        case 2:
                            
                           
                            [defaults setBool:YES forKey:@"2"];
                            [defaults synchronize];
        
                            break;
                            
                        case 3:
                            
                            
                            [defaults setBool:YES forKey:@"3"];
                            [defaults synchronize];
                           
                            break;
                            
                            
                        case 4:
                            
                            [defaults setBool:YES forKey:@"4"];
                            [defaults synchronize];
                            
                            break;
                        case 5:
                            
                            [defaults setBool:YES forKey:@"5"];
                            [defaults synchronize];
                            break;
                        
                        case 6:
                            
                          
                            [defaults setBool:YES forKey:@"6"];
                            [defaults synchronize];
                            break;
                        
                        case 7:
                            
                           
                            [defaults setBool:YES forKey:@"7"];
                            [defaults synchronize];
                            break;
                        
                        case 8:
                            
                            [defaults setBool:YES forKey:@"8"];
                            [defaults synchronize];
                            break;
                        
                        case 9:
                            
                            
                            [defaults setBool:YES forKey:@"9"];
                            [defaults synchronize];
                            break;
                            
                        default:
                            NSLog(@"erreur identifiant");
                            break;
                    }

                    
                }];
        }
        
    
            
        else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connexion échouée" :@"pas de reponse!" :0];
        }
    }
    
    
    
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"connexion échouée." :@"Erreur due à une exception" :0]; //l'erreur est probablement au niveau code php ou la base
        
    }

    
    
}
//change les switches sans acceded au serveur

-(void)changerlesSwitches{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"1"]) {
        [self.Divers setOn:YES animated:YES];
        
    }
    if ([defaults objectForKey:@"2"]) {
        [self.Arts setOn:YES animated:YES];
        
    }
    if ([defaults objectForKey:@"3"]) {
        [self.Sports setOn:YES animated:YES];
        
    }
    if ([defaults objectForKey:@"4"]) {
        [self.Litterature setOn:YES animated:YES];
        
    }
    if ([defaults objectForKey:@"5"]) {
        [self.Technologie setOn:YES animated:YES];
        
    }
    if ([defaults objectForKey:@"6"]) {
        [self.Sciences setOn:YES animated:YES];
        
    }
    if ([defaults objectForKey:@"7"]) {
        [self.Economie setOn:YES animated:YES];
        
    }
    if ([defaults objectForKey:@"8"]) {
        [self.PolitiqueTunisienne setOn:YES animated:YES];
        
    }
    if ([defaults objectForKey:@"9"]) {
        [self.Histoire setOn:YES animated:YES];
        
    }


}


@end
