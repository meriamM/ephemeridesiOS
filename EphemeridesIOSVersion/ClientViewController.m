//
//  ClientViewController.m
//  EphemeridesIOSVersion
//
//  Created by Maryam on 16/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import "ClientViewController.h"
#import "ChoixThemesViewController.h"
#import "Synchroniseur.h"
#define ClientLogin [NSURL URLWithString:@"http://localhost:8888/pcd/ClientLogin.php"]
#define ClientID [NSURL URLWithString:@"http://localhost:8888/pcd/idclient.php"] 

@interface ClientViewController ()

@end

@implementation ClientViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"loggedin"]) {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIn:(id)sender {
    NSInteger success = 0;
    
    
    @try {

    if([[self.textlogin text] isEqualToString:@""] || [[self.textmotdepasse text] isEqualToString:@""] ) {
        
        [self alertStatus:@"Entrez votre login et mot de passe!" :@"Connexion echouée" :0];
    }
    
    else {  //réccuper les données à envoyer au serveur en une chaine
        
            NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",[self.textlogin text],[self.textmotdepasse text]];
            NSLog(@"envois des donnees au serveur: %@",post);
            
            NSURL *url=ClientLogin; //la page qui va renvoyer le succès ou l'echec selon les données entrées
            
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
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init]; //pour convertir la chaine en entier
                [f setNumberStyle:NSNumberFormatterNoStyle];
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                //encoder les données 
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                
                
                success = [jsonData[@"success"] integerValue];
        
                _idclient= [f numberFromString:jsonData[@"idclient"]];
                NSLog(@"Success: %ld",(long)success);
                NSLog(@"idclient: %@",_idclient);
                
                
                if(success == 1)
                    
                {
                    ChoixThemesViewController *choix=[[ChoixThemesViewController alloc]init];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    //write the username and password and set BOOL value in NSUserDefaults
                    [defaults setObject:_textlogin forKey:@"username"];
                    [defaults setObject:_textmotdepasse forKey:@"motdepasse"];
                    [defaults setBool:YES forKey:@"loggedin"];
                    [defaults setObject:_idclient forKey:@"idclient"];
                    [defaults synchronize];
                    _textlogin=nil;
                    _textmotdepasse=nil;
                    [choix verifierThemesExistantsPourChargerEtatDesSwitchs];
                    

                    NSLog(@"Login SUCCESS");
                    
                    //////////////////////////////////////////////////////////////////
                    Synchroniseur *s=[[Synchroniseur alloc] init];
                    [s chargerEphemeridesApartirDeCeJour];
                    
                    [self performSegueWithIdentifier:@"login_success" sender:self];
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Succes est 0!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connexion échouée" :@"pas de reponse!" :0];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"connexion échouée." :@"Erreur due à une exception" :0]; //l'erreur est probablement au niveau code php ou la base
    }
    
}



- (IBAction)backgroundReturnKeyboard:(id)sender {
    
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

    //les alertes à afficher titre et message
- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        alertView.tag = tag;
        [alertView show];
}





@end


