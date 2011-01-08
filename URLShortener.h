//
//  URLShortener.h
//  Bit.lyer
//
//  Created by Woyo on 08.01.11.
//  Copyright 2011 Motionship Labs, Sàrl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLShortener : NSObject {}

+ (NSURL *)shortenURL:(NSURL*)urlToBeShortened error:(NSError *)error;

@end
