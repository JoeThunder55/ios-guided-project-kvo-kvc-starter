//
//  ViewController.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIDepartment.h"
#import "LSIEmployee.h"
#import "LSIHRController.h"


@interface ViewController ()

@property (nonatomic) LSIHRController *hrController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    LSIDepartment *marketing = [[LSIDepartment alloc] init];
    marketing.name = @"Marketing";
    LSIEmployee *philSchiller = [[LSIEmployee alloc] init];
    philSchiller.name = @"Phil";
    philSchiller.jobTitle = @"VP of Marketing";
    philSchiller.salary = 10000000;
    marketing.manager = philSchiller;
    
    
    LSIDepartment *engineering = [[LSIDepartment alloc] init];
    engineering.name = @"Engineering";
    LSIEmployee *craig = [[LSIEmployee alloc] init];
    craig.name = @"Craig";
    craig.salary = 9000000;
    craig.jobTitle = @"Head of Software";
    engineering.manager = craig;
    
    LSIEmployee *e1 = [[LSIEmployee alloc] init];
    e1.name = @"Chad";
    e1.jobTitle = @"Engineer";
    e1.salary = 200000;
    
    LSIEmployee *e2 = [[LSIEmployee alloc] init];
    e2.name = @"Lance";
    e2.jobTitle = @"Engineer";
    e2.salary = 250000;
    
    LSIEmployee *e3 = [[LSIEmployee alloc] init];
    e3.name = @"Joe";
    e3.jobTitle = @"Marketing Designer";
    e3.salary = 100000;
    
    [engineering addEmployee:e1];
    [engineering addEmployee:e2];
    [marketing addEmployee:e3];
    
    LSIHRController *controller = [[LSIHRController alloc] init];
    [controller addDepartment:engineering];
    [controller addDepartment:marketing];
    self.hrController = controller;
    
    NSLog(@"%@", self.hrController);
    
    //    NSString *key = @"privateName";
    //
    //    NSString *value = [craig valueForKey:key];
    //    NSLog(@"value for key %@", key, value);
    //
    //    [philSchiller setValue:@"Awesome Phil" forKey:key];
    //
    //    value = [philSchiller valueForKey:key];
    //
    //        NSLog(@"value for key %@: %@", key, value);
    
    //    NSString *keyPath = @"departments.employees";
    
    NSString *keyPath = @"departments.@distinctUnionOfArrays.employees";
    
    NSArray *employees = [self.hrController valueForKeyPath:keyPath];
    NSLog(@"Employees: %@", employees);
    
    //    NSString *key = @"salary";
    //    NSArray *salaries = [employees valueForKeyPath:key];
    //    NSLog(@"Salaries: %@", salaries);
    
    @try {
        NSArray *directSalaries = [self valueForKeyPath:@"hrController.departments.employees.salary"];
        NSLog(@"Direct Salaries: %@", directSalaries);
    } @catch (NSException *exception) {
        NSLog(@"Got an exception: %@", exception);
    }
    
    [craig setValue:@(42 + 5) forKey:@"salary"];
    
    NSLog(@"Avg Salary: %@", [employees valueForKeyPath:@"@avg.salary"]);
    
    NSSortDescriptor *nameSortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    NSSortDescriptor *salarySortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"salary" ascending:NO];
    
    NSArray *sortedEmployees = [employees sortedArrayUsingDescriptors:@[nameSortDiscriptor,
                                    salarySortDiscriptor]];
    
    NSLog(@"Sorted: %@", sortedEmployees);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"John"];
    NSArray *filteredEmployees = [employees filteredArrayUsingPredicate:predicate];
    NSLog(@"Filtered: %@", filteredEmployees);
}

@end
