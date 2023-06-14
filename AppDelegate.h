//
//  AppDelegate.h
//  
//
//  Created by aSDasd SDsadsada on 13.06.2023.
//

#ifndef AppDelegate_h
#define AppDelegate_h


#endif /* AppDelegate_h */

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end


//@interface KeyState : NSObject
//
//@property bool globe;
//@property bool command;
//@property bool anyKey;
//@property bool spaceKey;
//
//@end
//
//extern KeyState *state;


extern bool globe;
extern bool command;
extern bool anyKey;
extern bool spaceKey;


@interface KeyState : NSObject {
    bool _globe;
    bool _command;
    bool _anyKey;
    bool _spaceKey;
}

+ (bool) globe;

+ (bool) command;

+ (bool) anyKey;

+ (bool) spaceKey;

+ (void)setGlobe: (bool)newValue;

+ (void)setCommand: (bool)newValue;

+ (void)setAnyKey: (bool)newValue;

+ (void)setSpaceKey: (bool)newValue;

@end
