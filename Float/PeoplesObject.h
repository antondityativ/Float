//
//  PeoplesObject.h
//  Float
//
//  Created by Антон Дитятив on 26.05.15.
//  Copyright (c) 2015 Антон Дитятив. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PeoplesObject : NSManagedObject

@property (nonatomic, retain) NSArray * email;
@property (nonatomic, retain) NSArray * people_id;

@end

@interface PeoplesObjectObject : NSObject

@property (strong, retain) NSArray * email;
@property (strong, retain) NSArray * people_id;

-(instancetype)initWithEmail:(NSArray *)email withPeopleID:(NSArray *)people_id;

@end
