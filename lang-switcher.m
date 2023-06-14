#include <stdio.h>
#include <stdlib.h>
#include <Carbon/Carbon.h>
#include <Foundation/Foundation.h>
#include "AppDelegate.h"

@implementation KeyState

static KeyState* keyState;

- (bool) globe {return _globe;}
- (bool) command {return _command;}
- (bool) anyKey {return _anyKey;}
- (bool) spaceKey {return _spaceKey;}

- (void)setGlobe: (bool)newValue {
    _globe = newValue;
}

- (void)setCommand: (bool)newValue {
    _command = newValue;
}

- (void)setAnyKey: (bool)newValue {
    _anyKey = newValue;
}

- (void)setSpaceKey: (bool)newValue {
    _spaceKey = newValue;
}

+ (void) initialize {
    keyState = [[KeyState alloc] init];
}


+ (bool) globe {
    return [keyState globe];
}

+ (bool) command {
    return [keyState command];
}

+ (bool) anyKey {
    return [keyState anyKey];
}

+ (bool) spaceKey {
    return [keyState spaceKey];
}

+ (void)setGlobe: (bool)newValue {
    [keyState setGlobe: newValue];
}

+ (void)setCommand: (bool)newValue {
    [keyState setCommand: newValue];
}

+ (void)setAnyKey: (bool)newValue {
    [keyState setAnyKey: newValue];
}

+ (void)setSpaceKey: (bool)newValue {
    [keyState setSpaceKey: newValue];
}

@end

KeyState* keyState2;

NSArray* getInputSources() {
    return [(NSArray *)TISCreateInputSourceList(NULL,false) autorelease];
}

NSArray* getAllInputSources() {
    return [(NSArray *)TISCreateInputSourceList(NULL,true) autorelease];
}

TISInputSourceRef getCurrentInputSource() {
    return TISCopyCurrentKeyboardLayoutInputSource();
}

void selectInputSource(TISInputSourceRef inputSource) {
    TISSelectInputSource(inputSource);
}

void switchLang() {
    id pool = [NSAutoreleasePool new];


    NSArray *inputSources = getInputSources();

    NSMutableArray *indexMapper = [NSMutableArray array];

    TISInputSourceRef currentInputSource = getCurrentInputSource();

    NSString *currentInputSourceID = TISGetInputSourceProperty(currentInputSource, kTISPropertyInputSourceID);
    int currentInputSourceInd = 0;
    int ind = 0;
    int ind2 = 0;
    for (NSObject *inputSource in inputSources) {
        NSString *inputSourceID = TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceID);
        if(![inputSourceID hasPrefix:@"com.apple.keylayout"]) {
            ind2++;
            continue;
        }

        if (strcmp([inputSourceID UTF8String],[currentInputSourceID UTF8String]) == 0) {
            currentInputSourceInd = ind;
        }
        [indexMapper addObject:[NSNumber numberWithInteger:ind2]];
        ind++;
        ind2++;
    }

    currentInputSourceInd += 1;
    if (currentInputSourceInd >= ind) {
        currentInputSourceInd = 0;
    }

    TISInputSourceRef inputSource = (TISInputSourceRef)[inputSources objectAtIndex:[[indexMapper objectAtIndex:currentInputSourceInd] integerValue]];
    selectInputSource(inputSource);
    [pool release];
}


@implementation AppDelegate

BOOL checkAccessibility()
{
    NSDictionary* opts = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)opts);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (checkAccessibility()) {
        NSLog(@"Accessibility Enabled");
    }
    else {
        NSLog(@"Accessibility Disabled");
    }

    keyState = [[KeyState alloc] init];

    keyState.globe = false;
    keyState.command = false;
    keyState.anyKey = false;
    keyState.spaceKey = false;

    NSLog(@"registering keydown mask");

    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^(NSEvent *event){
        NSUInteger flags = [event modifierFlags] & NSEventModifierFlagDeviceIndependentFlagsMask;

        if(flags == NSEventModifierFlagFunction){ //  && ![event containsCharacter]
            NSLog(@"keydown Globe");
            keyState.globe = true;
        } else if(flags == NSEventModifierFlagCommand){
            NSLog(@"keydown command");
            keyState.command = true;
        } else if (flags == 0) {
            if (keyState.globe && !keyState.command && !keyState.anyKey) {
                switchLang();
            }
            if (keyState.command && !keyState.globe && !keyState.anyKey) {
                // Switch on space key down
            }
            keyState.globe = false;
            keyState.command = false;
        } else {
            keyState.globe = false;
            keyState.command = false;
        }

    }];

    // NSEventMaskKeyUp
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^(NSEvent *event){
        if([[event characters] isEqualToString:@" "] && keyState.command == true){
            NSLog(@"keydown Space");
            switchLang();
        } else {
            keyState.anyKey = true;
        }
    }];

    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskKeyUp handler:^(NSEvent *event){
        keyState.anyKey = false;
    }];
}

@end


int main(int argc, char const * const * argv) {
    @autoreleasepool {
        AppDelegate *delegate = [[AppDelegate alloc] init];

        NSApplication * application = [NSApplication sharedApplication];
        [application setDelegate:delegate];
        [NSApp run];
    }

    return 0;
}
