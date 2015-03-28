//
// Created by Pritesh Shah on 3/28/15.
// Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <Bolts/Bolts.h>
#import "TRUser.h"
#import "ImageUtilities.h"

#define DEFAULT_TEST_TIMEOUT 10.0 // in seconds

SPEC_BEGIN(TRUserSpec)

    describe(@"TRUser", ^{

        __block TRUser *_user;
        __block NSString *_userId;

        beforeEach(^{
            _user = [[TRUser alloc] init];
            _userId = @"10153012454715971";
        });

        context(@"when fetching 200 x 200 picture", ^{
            it(@"should return a picture", ^{
                __block NSData *_imageData;
                BFTask *imageFetchTask = [_user fetch200x200Picture:_userId];
                [imageFetchTask continueWithBlock:^id(BFTask *task) {
                    if (task.isCancelled) {
                        // the fetch was cancelled.
                    } else if (task.error) {
                        // the fetch failed.
                    } else {
                        // the picture was fetched successfully.
                        _imageData = task.result;
                    }
                    return nil;
                }];
                [[expectFutureValue(_imageData) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
            });
        });

        context(@"tasks in parallel", ^{
            it(@"should fetch images in parallel", ^{
                __block NSData *_imageData100x100;
                __block NSData *_imageData200x200;
                BFTask *imageFetchTask100x100 = [_user fetch100x100Picture:_userId];
                BFTask *imageFetchTask200x200 = [_user fetch200x200Picture:_userId];
                NSArray *allImageFetchTasks = @[imageFetchTask100x100, imageFetchTask200x200];
                BFTask *masterTask = [BFTask taskForCompletionOfAllTasks:allImageFetchTasks];
                [masterTask continueWithSuccessBlock:^id(BFTask *task) {
                    _imageData100x100 = imageFetchTask100x100.result;
                    _imageData200x200 = imageFetchTask200x200.result;
                    return nil;
                }];
                [[expectFutureValue(_imageData100x100) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
                [[expectFutureValue(_imageData200x200) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
            });
        });

        context(@"tasks in series", ^{
            it(@"should fetch images one after the other", ^{
                __block NSData *_imageData100x100;
                __block NSData *_imageData200x200;
                BFTask *imageFetchTask100x100 = [_user fetch100x100Picture:_userId];
                BFTask *imageFetchTask200x200 = [_user fetch200x200Picture:_userId];
                [[imageFetchTask100x100 continueWithSuccessBlock:^id(BFTask *task) {
                    _imageData100x100 = task.result;
                    [[theValue(imageFetchTask200x200.isCompleted) should] beNo];
                    [[imageFetchTask200x200.result should] beNil];
                    return imageFetchTask200x200;
                }] continueWithSuccessBlock:^id(BFTask *task) {
                    _imageData200x200 = task.result;
                    return nil;
                }];
                [[expectFutureValue(_imageData100x100) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
                [[expectFutureValue(_imageData200x200) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
            });
        });

        context(@"when resizing an image", ^{
            it(@"should resize only after the image is fetched", ^{
                __block UIImage *_image100x100;
                __block NSData *_imageData200x200;
                BFTask *imageFetchTask200x200 = [_user fetch200x200Picture:_userId];
                [[imageFetchTask200x200 continueWithSuccessBlock:^id(BFTask *task) {
                    _imageData200x200 = task.result;
                    UIImage *image = [UIImage imageWithData:_imageData200x200];
                    BFTask *imageResizeTask = [ImageUtilities resizeImage:image toWidth:100];
                    return imageResizeTask;
                }] continueWithSuccessBlock:^id(BFTask *task) {
                    _image100x100 = task.result;
                    return nil;
                }];
                [[expectFutureValue(_image100x100) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
                [[expectFutureValue(theValue(_image100x100.size.width)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:theValue(100)];
                [[expectFutureValue(theValue(_image100x100.size.height)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:theValue(100)];
                [[expectFutureValue(_imageData200x200) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
            });
        });

    });

SPEC_END
