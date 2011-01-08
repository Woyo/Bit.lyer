//
//  URLShortener.m
//  Bit.lyer
//
//  Created by Woyo on 08.01.11.
//  Copyright 2011 Motionship Labs, Sàrl. All rights reserved.
//

#import "URLShortener.h"
#import "MKBitlyHelper.h"

// You can provide a custon API keys for bit.ly right here
#define BITLY_LOGIN_NAME @"woyo"
#define BITLY_API_KEY	 @"R_a6d632676a93b9c0ced4d50565237c7a"

@implementation URLShortener

+ (NSURL *)shortenURL:(NSURL*)urlToBeShortened error:(NSError *)error
{
	MKBitlyHelper *shrinker = [[MKBitlyHelper alloc] initWithLoginName:BITLY_LOGIN_NAME	andAPIKey:BITLY_API_KEY];
	NSString *result = [shrinker shortenURL:[urlToBeShortened absoluteString]];
	[shrinker release];
	
	if (!result)
	{
		error = [NSError errorWithDomain:@"Failed to create short link" code:0 userInfo:nil];
		return nil;
	}
	
	return [NSURL URLWithString:result];
}

@end
