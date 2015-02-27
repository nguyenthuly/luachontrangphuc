//
//  SWVerticalLabel.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData+MagicalRecord.h"

@interface DataManager : NSObject
{

}
+ (DataManager*)sharedInstance;
+ (BOOL)saveAllChanges;
+ (void)revertLocalChanges;
@end
