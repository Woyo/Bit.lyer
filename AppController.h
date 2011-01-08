//
//  AppController.h
//  Bit.lyer
//
//  Created by Woyo on 08.01.11.
//  Copyright 2011 Motionship Labs, Sàrl. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject {
	NSButton *shrinkFromSafariURLButton;
	NSButton *shrinkFromClipboardButton;
	NSButton *shrinkFromSelfTextfieldButton;	
	NSTextField *urlInputTextField;	
	NSButton *hiddenCopyToClpbrdButton;
	NSTextField *errorMessage;
	NSProgressIndicator *progressIndicator;
	NSButton *tryAgainButton;
}

@property (retain) IBOutlet	NSButton *shrinkFromSafariURLButton;
@property (retain) IBOutlet	NSButton *shrinkFromClipboardButton;
@property (retain) IBOutlet	NSButton *shrinkFromSelfTextfieldButton;	
@property (retain) IBOutlet	NSTextField *urlInputTextField;
@property (retain) IBOutlet	NSButton *hiddenCopyToClpbrdButton;
@property (retain) IBOutlet NSTextField *errorMessage;
@property (retain) IBOutlet NSProgressIndicator *progressIndicator;
@property (retain) IBOutlet NSButton *tryAgainButton;

- (IBAction)shortenURLFromSafariCurrentPage:sender;
- (IBAction)shortenURLFromClipboard:sender;
- (IBAction)shortenURLFromSelfTextField:sender;

- (IBAction)copyTextFromURLTextFieldToClipboard:sender;
- (IBAction)tryAgain:sender;

@end
