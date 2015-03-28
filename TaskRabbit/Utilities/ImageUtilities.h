//
// Created by Pritesh Shah on 3/28/15.
// Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BFTask;

@interface ImageUtilities : NSObject

+ (BFTask *)resizeImage:(UIImage *)image toWidth:(CGFloat)width;

@end