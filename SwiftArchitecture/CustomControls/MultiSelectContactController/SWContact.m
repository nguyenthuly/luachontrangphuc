//
//  SWContact.m
//  SwiftArchitecture
//
//  Created by luan pham on 6/22/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import "SWContact.h"

@implementation SWContact
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize fullName = _fullName;
@synthesize sectionNumber = _sectionNumber;
@synthesize isSelected = _isSelected;

- (NSString *)sorterFirstName {

    if (nil != _firstName && ![_firstName isEqualToString:@""]) {
        
        return _firstName;
    }
    if (nil != _lastName && ![_lastName isEqualToString:@""]) {
        
        return _lastName;
    }
    if (nil != self.fullName && ![self.fullName isEqualToString:@""]) {
        
        return self.fullName;
    }
    return nil;
}

- (NSString *)sorterLastName {
    
    if (nil != _firstName && ![_firstName isEqualToString:@""]) {
        
        return _firstName;
    }
    if (nil != _lastName && ![_lastName isEqualToString:@""]) {
        
        return _lastName;
    }
    if (nil != self.fullName && ![self.fullName isEqualToString:@""]) {
        
        return self.fullName;
    }
    return nil;
}

- (NSString *)sorterFullName {
    
    if (nil != self.fullName && ![self.fullName isEqualToString:@""]) {
       
        return self.fullName;
    }
    if (nil != self.fullName && ![self.fullName isEqualToString:@""]) {
        
        return self.fullName;
    }
    return nil;
}

@end
