//
//  ClientCreationCompteViewController.m
//  EphemeridesIOSVersion
//
//  Created by Maryam on 19/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import "ClientCreationCompteViewController.h"
#define ClientCreation [NSURL URLWithString:@"http://localhost:8888/pcd/ClientCreationCompte.php"]
#import "Synchroniseur.h"
#import "EphemeridesAppDelegate.h"

@interface ClientCreationCompteViewController ()

@end

@implementation ClientCreationCompteViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submit:(id)sender {
    NSArray *donneestosend=[[NSArray alloc]init];
    NSInteger success = 0;
    donneestosend=[self verifierChamps];
    
    if (donneestosend) {
        
            NSString *post =[[NSString alloc] initWithFormat:@"nom=%@&prenom=%@&username=%@&password=%@&datedenaissance=%@&email=%@",donneestosend[0],donneestosend[1],donneestosend[2],donneestosend[3],donneestosend[5],donneestosend[6]];
                NSLog(@"envois des donnees au serveur: %@",post);
                NSURL *url=ClientCreation; //la page qui va renvoyer le succès ou l'echec selon les données entrées
                NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSLog(@"%@",postData); //coder les données en ASCCI
        
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
                NSLog(@"Donnees enregistrées");
                EphemeridesAppDelegate *appdelegate=[[EphemeridesAppDelegate alloc] init];
                Synchroniseur *s=[[Synchroniseur alloc] init];
                NSManagedObjectContext *context = [appdelegate managedObjectContext];
                [s initializationDataToLocalBase:context];
                
                
            }
        }
    
    }
}





-(NSArray *)verifierChamps
{
    NSMutableArray *donnees=[[NSMutableArray alloc]init];
    
        /////////////////nom et prenom///////////////////
        if ([[self.nom text] isEqualToString:@""] || [[self.prenom text] isEqualToString:@""]) {
            NSLog(@"nom et prenom champs vides");
            return nil;
        }
        else
        {
            [donnees insertObject: [self.nom text] atIndex:0];
            [donnees insertObject:[self.prenom text] atIndex:1];
        
        }
        
        /////////////////username///////////////////
        if ([[self.username text] isEqualToString:@""]) {
            NSLog(@"username champ vide");
            return nil;
            
        }
        else
        {
            [donnees insertObject:[self.username text] atIndex:2];
            
        }
    
    /////////////////password///////////////////
    if ([[self.motdepasse text] isEqualToString:@""]) {
        NSLog(@"password champ vide");
        return nil;
    }
    else
    {
        [donnees insertObject:[self.motdepasse text] atIndex:3];
        
    }
    /////////////////Confirmationpassword///////////////////
    if ([[self.confirmationmotedepasse text] isEqualToString:@""]) {
        NSLog(@"veuillez confirmer le password");
        return nil;
    }
    else
    {
        [donnees insertObject:[self.confirmationmotedepasse text] atIndex:4];
        
    }
    /////////////////date de naissance///////////////////
    if ([[self.datedenaissance text] isEqualToString:@""]) {
        NSLog(@"Le champ de la date de naissance est vide");
    }
    else
    {
        [donnees insertObject:[self.datedenaissance text] atIndex:5];
        
    }
    
    /////////////////email///////////////////
    if ([[self.email text] isEqualToString:@""]) {
        NSLog(@"username champ vide");
    }
    else
    {
        [donnees insertObject:[self.email text] atIndex:6];
        
    }
    
    
    return donnees;
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)backgroundclavier:(id)sender{

    [self.view endEditing:YES ];
}


@end
