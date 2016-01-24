//
//  ChoixThemesViewController.h
//  EphemeridesIOSVersion
//
//  Created by Maryam on 22/04/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoixThemesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *Divers;

@property (weak, nonatomic) IBOutlet UISwitch *Arts;
@property (weak, nonatomic) IBOutlet UISwitch *Sports;
@property (weak, nonatomic) IBOutlet UISwitch *Litterature;
@property (weak, nonatomic) IBOutlet UISwitch *Technologie;
@property (weak, nonatomic) IBOutlet UISwitch *Sciences;
@property (weak, nonatomic) IBOutlet UISwitch *Economie;
@property (weak, nonatomic) IBOutlet UISwitch *PolitiqueTunisienne;
@property (weak, nonatomic) IBOutlet UISwitch *Histoire;

-(IBAction)onOffSwitch:(id)sender;

-(void)enregistrerThemeModifie:(UISwitch*)leSwitch cocheoDecoche:(BOOL)etat;
-(void)verifierThemesExistantsPourChargerEtatDesSwitchs;

@property (weak, nonatomic) IBOutlet UIButton *Continuez;

- (IBAction)continuez:(id)sender;

@end
