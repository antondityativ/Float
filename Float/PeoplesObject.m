//
//  PeoplesObject.m
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import "PeoplesObject.h"

@implementation PeoplesObject

@dynamic email;
@dynamic people_id;

@end

@implementation PeoplesObjectObject

-(instancetype)initWithEmail:(NSArray *)email withPeopleID:(NSArray *)people_id {
    self = [super init];
    if(self) {
        self.email = email;
        self.people_id = people_id;
    }
    return self;
}

@end
