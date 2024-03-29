//
//  AVTViewController.m
//  TransloadExample
//
//  Created by Yury on 02.04.14.
//  Copyright (c) 2014 Yury. All rights reserved.
//

#import "AVTViewController.h"
#import "Transloadit.h"
#import "Step.h"
#import "AssemblyBuilder.h"
#import "TransloaditResponse.h"
#import "TransloaditLogger.h"


@interface AVTViewController ()

@end

@implementation AVTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create Transloadit instance
    NSObject<ITransloadit>* transloadit = [[Transloadit alloc] init:@"cbefd6a0a39e11e39bece329444099d9"];
    
    //Create assembly builder to build up the assembly
    NSObject<IAssemblyBuilder>* assembly = [[AssemblyBuilder alloc] init];
    
    //Set template ID
    [assembly setTemplateID:@"40780400ba3f11e38ca025c3a099fb02"];
    
    NSString* path=[NSString stringWithFormat:@"%@/%@",[[NSBundle bundleForClass:[self class]] resourcePath],@"atkritka_1335458443_233_m.jpg"];
    
    NSData* img = [NSData dataWithContentsOfFile:path];
    
    NSError* error;
    
    //Add a file to be uploaded with autogenerated key
    [assembly addFile:img withError:error];
    
    if(error!=nil)
    {
        TRANSLOADIT_LOG_ERROR(self.class,error);
        return;
    }
    
    //Invoke assembly, and wait for the result
    TransloaditResponse* response = [transloadit invokeAssembly:assembly withError:error];
    
    if(error != nil)
    {
        TRANSLOADIT_LOG_ERROR_WITH_MESSAGE(self.class, @"Error has occured while completing assembly");
        return;
    }
    
    if([response isSuccess])
    {
        TRANSLOADIT_LOG_INFO(self.class, @"Assembly %@ result",[[response getData] objectForKey:@"assembly_id"]);
    }else
    {
        TRANSLOADIT_LOG_ERROR_WITH_MESSAGE(self.class, @"Error has occured while completing assembly");
    }
}

@end

