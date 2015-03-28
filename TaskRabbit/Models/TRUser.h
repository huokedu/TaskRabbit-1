//
// Created by Pritesh Shah on 3/28/15.
// Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;


@interface TRUser : NSObject

- (BFTask *)fetch100x100Picture:(NSString *)userId;

- (BFTask *)fetch200x200Picture:(NSString *)userId;

@end