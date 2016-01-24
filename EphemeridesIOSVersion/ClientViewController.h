//
//  ClientViewController.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 16/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textlogin;
@property (weak, nonatomic) IBOutlet UITextField *textmotdepasse;
@property  NSNumber* idclient;


- (IBAction)signIn:(id)sender; //le bouton submit
- (IBAction)backgroundReturnKeyboard:(id)sender; // comment se débarasser du clavier
- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag;//gestion des alertes qui s'affichent

@end
