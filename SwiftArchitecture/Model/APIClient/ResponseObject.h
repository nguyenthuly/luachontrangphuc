//
//  ResponseObject.h
//  NewWindBase
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseObject : NSObject
{

}
@property (nonatomic, strong) id data;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDictionary *info;
@end
