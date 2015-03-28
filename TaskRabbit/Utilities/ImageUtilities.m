//
// Created by Pritesh Shah on 3/28/15.
// Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "ImageUtilities.h"
#import <Bolts/Bolts.h>

@implementation ImageUtilities {

}

+ (BFTask *)resizeImage:(UIImage *)image toWidth:(CGFloat)width {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        UIImage *thumbImage = nil;
        CGSize newSize = CGSizeMake(width, (width / image.size.width) * image.size.height);

        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        thumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [task setResult:thumbImage];
    });

    return task.task;
}

@end