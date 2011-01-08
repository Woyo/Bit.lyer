//
//  AppController.m
//  Bit.lyer
//
//  Created by Woyo on 08.01.11.
//  Copyright 2011 Motionship Labs, Sàrl. All rights reserved.
//

#import "AppController.h"
#import "URLShortener.h"

#define UI_STATE_READY		0
#define UI_STATE_PROCESSING 1
#define UI_STATE_ERROR		2
#define UI_STATE_COMPLETED	3

@implementation AppController(Private)
NSString *shortenedLink;
@end

@implementation AppController

@synthesize shrinkFromSafariURLButton, shrinkFromClipboardButton, shrinkFromSelfTextfieldButton;
@synthesize hiddenCopyToClpbrdButton;
@synthesize urlInputTextField, errorMessage, progressIndicator, tryAgainButton;

- (void)setUIState:(int)state
{
	switch (state) {
		case UI_STATE_READY: 
		{
			[shrinkFromClipboardButton isEnabled] ? : [shrinkFromClipboardButton setEnabled:YES];
			[shrinkFromSafariURLButton isEnabled] ? : [shrinkFromSafariURLButton setEnabled:YES];
			[shrinkFromSelfTextfieldButton isEnabled] ? : [shrinkFromSelfTextfieldButton setEnabled:YES];
			[tryAgainButton isHidden] ? : [tryAgainButton setHidden:YES];
			[tryAgainButton isEnabled] ? : [tryAgainButton setEnabled:NO];
			[hiddenCopyToClpbrdButton setEnabled:NO];
			[hiddenCopyToClpbrdButton setHidden:YES];
			[hiddenCopyToClpbrdButton setAlphaValue:0.];
			if (![errorMessage isHidden]) [errorMessage setHidden:YES];
			[progressIndicator stopAnimation:self];
			if (![urlInputTextField isEnabled]) [urlInputTextField setEnabled:YES];
			[urlInputTextField setEditable:YES];
			
			urlInputTextField.stringValue = @""; // Displays the urlInTextField's placeholder
		}
			break;
			
		case UI_STATE_PROCESSING:
		{
			if ([shrinkFromClipboardButton isEnabled]) [shrinkFromClipboardButton setEnabled:NO];
			if ([shrinkFromSafariURLButton isEnabled]) [shrinkFromSafariURLButton setEnabled:NO];
			if ([shrinkFromSelfTextfieldButton isEnabled]) [shrinkFromSelfTextfieldButton setEnabled:NO];
			if ([hiddenCopyToClpbrdButton isEnabled]) [hiddenCopyToClpbrdButton setEnabled:NO];
			if (![errorMessage isHidden]) [errorMessage setHidden:YES];
			[progressIndicator startAnimation:self];
			[urlInputTextField setEnabled:NO];
			[tryAgainButton isHidden] ? : [tryAgainButton setHidden:YES];
			[tryAgainButton isEnabled] ? : [tryAgainButton setEnabled:NO];
		}
			break;
			
		case UI_STATE_ERROR:
		{
			if ([shrinkFromClipboardButton isEnabled]) [shrinkFromClipboardButton setEnabled:NO];
			if ([shrinkFromSafariURLButton isEnabled]) [shrinkFromSafariURLButton setEnabled:NO];
			if ([shrinkFromSelfTextfieldButton isEnabled]) [shrinkFromSelfTextfieldButton setEnabled:NO];
			if ([hiddenCopyToClpbrdButton isEnabled]) [hiddenCopyToClpbrdButton setEnabled:NO];
			if ([errorMessage isHidden]) [errorMessage setHidden:NO];
			if ([tryAgainButton isHidden]) [tryAgainButton setHidden:NO];
			if (![tryAgainButton isEnabled]) [tryAgainButton setEnabled:YES];
			[progressIndicator stopAnimation:self];
			[urlInputTextField setEnabled:NO];
		}
			break;
		
		case UI_STATE_COMPLETED:
		{
			if ([tryAgainButton isHidden]) [tryAgainButton setHidden:NO];
			if (![tryAgainButton isEnabled]) [tryAgainButton setEnabled:YES];
			if ([shrinkFromClipboardButton isEnabled]) [shrinkFromClipboardButton setEnabled:NO];
			if ([shrinkFromSafariURLButton isEnabled]) [shrinkFromSafariURLButton setEnabled:NO];
			if ([shrinkFromSelfTextfieldButton isEnabled]) [shrinkFromSelfTextfieldButton setEnabled:NO];
			[hiddenCopyToClpbrdButton setEnabled:YES];
			[hiddenCopyToClpbrdButton setHidden:NO];
			[hiddenCopyToClpbrdButton setAlphaValue:0.];
			[progressIndicator stopAnimation:self];
			[urlInputTextField setEnabled:YES];
			[urlInputTextField setEditable:NO];
			[urlInputTextField setSelectable:NO];
		}
			break;
	}
}

- (IBAction)tryAgain:sender
{
	[self setUIState:UI_STATE_READY];
}

- (NSString *)makeURLStringLowercaseAndHttpPrefixed:(NSString *)stringToMake
{
#define HTTP_PREFIX @"http://"
	
	if (![stringToMake hasPrefix:HTTP_PREFIX])
	{
		stringToMake = [HTTP_PREFIX stringByAppendingString:stringToMake];
	}
	
	stringToMake = [stringToMake lowercaseString];
	
	return stringToMake;
}

- (NSString*) safariURL
{
    NSDictionary *dict;
    NSAppleEventDescriptor *result;
	
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:
							 @"\ntell application \"Safari\"\n\tget URL of document 1\nend tell\n"];
	
    result = [script executeAndReturnError:&dict];
	
    [script release];
	
    if ((result != nil) && ([result descriptorType] != kAENullEvent)) {
        return [result stringValue];
    }
	
    return nil;
}

- (NSURL *)shortenURL:(NSURL *)url
{
	[url retain];
	NSError *error = nil;
	NSURL *result = [[[URLShortener shortenURL:url error:error] copy] autorelease];
	[url release];
	
	if (error)
	{
		[self setUIState:UI_STATE_ERROR];
		return nil;
	} else {
		return result;
	}
}

- (void)startShorteningProcessOfURLAsString:(NSString *)stringToBeShorten
{
	stringToBeShorten = [self makeURLStringLowercaseAndHttpPrefixed:stringToBeShorten];
	
	NSURL *URL = [NSURL URLWithString:stringToBeShorten];
	
	if (URL)
	{
		[self setUIState:UI_STATE_PROCESSING];
		URL = [self shortenURL:URL];
		
		if (URL)
		{
			self.urlInputTextField.stringValue = [URL absoluteString];
			[self setUIState:UI_STATE_COMPLETED];
		} else {
			NSLog(@"Something goes wrong...");
			[self setUIState:UI_STATE_ERROR];
		}
		
	} else {
		NSLog(@"URL looks like not-a-URL :(");
		[self setUIState:UI_STATE_ERROR];
	}
}

- (void)setShrinkedURLBackAsTextFieldsValue
{
	self.urlInputTextField.stringValue = shortenedLink;
	[shortenedLink release];
	shortenedLink = nil;
}

- (IBAction)copyTextFromURLTextFieldToClipboard:sender
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pb setString:self.urlInputTextField.stringValue forType:NSStringPboardType];
	[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(setShrinkedURLBackAsTextFieldsValue)
						  userInfo:nil repeats:NO];
	shortenedLink = self.urlInputTextField.stringValue;
	[shortenedLink retain];
	self.urlInputTextField.stringValue = @"Copied!";
}
- (IBAction)shortenURLFromSafariCurrentPage:sender
{
	NSString *safariURL = [self safariURL];
	if (safariURL)
	{
		[self startShorteningProcessOfURLAsString:safariURL];
	}
}

- (IBAction)shortenURLFromClipboard:sender
{
	NSString *textURL = [[NSPasteboard generalPasteboard] stringForType:NSStringPboardType];
	[self startShorteningProcessOfURLAsString:textURL];
}

- (IBAction)shortenURLFromSelfTextField:sender
{
	NSString *textURL = self.urlInputTextField.stringValue;
	[self startShorteningProcessOfURLAsString:textURL];
}

- (void)awakeFromNib
{
	// View did load initializations
	
	[self setUIState:UI_STATE_READY];
}

- (void)releaseOutlets
{
	self.shrinkFromClipboardButton = nil;
	self.shrinkFromSafariURLButton = nil;
	self.shrinkFromSelfTextfieldButton = nil;
	self.hiddenCopyToClpbrdButton = nil;
	self.urlInputTextField = nil;
	self.errorMessage = nil;
	self.progressIndicator = nil;
	self.tryAgainButton = nil;
}

- (void)dealloc
{
	[self releaseOutlets];
	[super dealloc];
}

@end
