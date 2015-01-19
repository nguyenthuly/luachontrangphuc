//
//  SWVerticalLabel.h
//  SwiftArchitecture
//
//  Created by luan pham on 6/19/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
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
