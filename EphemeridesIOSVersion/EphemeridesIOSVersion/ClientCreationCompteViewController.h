//
//  ClientCreationCompteViewController.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 19/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientCreationCompteViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nom;

@property (weak, nonatomic) IBOutlet UITextField *prenom;
@property (weak, nonatomic) IBOutlet UITextField *motdepasse;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *confirmationmotedepasse;
@property (weak, nonatomic) IBOutlet UITextField *datedenaissance;
@property (weak, nonatomic) IBOutlet UITextField *email;

- (IBAction)submit:(id)sender;
- (IBAction)backgroundclavier:(id)sender;

@end
