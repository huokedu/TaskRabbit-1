//
// Created by Pritesh Shah on 3/28/15.
// Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "TRUser.h"
#import <Bolts/Bolts.h>

static NSString *const profilePictureURL = @"https://graph.facebook.com/v2.2/%@/picture?width=%d&height=%d";

@interface TRUser ()
- (BFTask *)fetchProfilePicture:(NSURL *)URL;
@end

@implementation TRUser {

}

#pragma mark - Public API

- (BFTask *)fetch100x100Picture:(NSString *)userId {
    NSString *profilePicture100x100URL = [NSString stringWithFormat:profilePictureURL, userId, 100, 100];

    return [self fetchProfilePicture:[NSURL URLWithString:profilePicture100x100URL]];
}

- (BFTask *)fetch200x200Picture:(NSString *)userId {
    NSString *profilePicture200x200URL = [NSString stringWithFormat:profilePictureURL, userId, 200, 200];

    return [self fetchProfilePicture:[NSURL URLWithString:profilePicture200x200URL]];
}

#pragma mark - Private implementation

// Objective-C
// https://github.com/BoltsFramework/Bolts-iOS
- (BFTask *)fetchProfilePicture:(NSURL *)URL {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:URL options:NSDataReadingUncached error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [task setResult:imageData];
            } else {
                [task setError:error];
            }
        });
    });

    return task.task;
}

@end