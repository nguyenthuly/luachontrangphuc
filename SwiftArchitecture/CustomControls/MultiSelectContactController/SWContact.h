//
//  SWContact.h
//  SwiftArchitecture
//
//  Created by luan pham on 6/22/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWContact : NSObject
{

}
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *fullName;
@property (nonatomic,assign) NSInteger sectionNumber;
@property (nonatomic) BOOL isSelected;

//Sorting method
- (NSString *)sorterFirstName;
- (NSString *)sorterLastName;
- (NSString *)sorterFullName;
@end
