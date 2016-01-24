//
//  EphemeridesViewController.m
//  EphemeridesIOSVersion
//
//  Created by Maryam on 01/05/14.
//  Copyright (c) 2014 Maryam. All rights reserved.
//

#import "EphemeridesViewController.h"
#import "EphemeridesAppDelegate.h"
#import "Ephemerides.h"
@interface EphemeridesViewController ()

@end

@implementation EphemeridesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
   
    EphemeridesAppDelegate *appdelegate=(EphemeridesAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Ephemerides" inManagedObjectContext:context];
       [fetchRequest setEntity:entity];
    NSError *error;
    self.ephemerides = [context executeFetchRequest:fetchRequest error:&error];
    self.title = @"Ephemerides";}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_ephemerides count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
    // Configure the cell...
    
    Ephemerides *event = [_ephemerides objectAtIndex:indexPath.row];
    NSLog(@"%@",event.titre);
    cell.textLabel.text = event.titre;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
                                 event.jour, event.mois];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
