//
//  ProductModel.h
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductObject.h"
#import <sqlite3.h>


@interface ProductModel : NSObject


//  Class Method(s)
+(ProductModel *)getProductModel;                           // Database and Table "Create"


//  Instance Methods
-(void) copyAllRecordsFromDatabaseToDataModel;              // Database "Select All"

-(NSInteger)    getNumberOfObjectsInModel;
-(void)         addObjectToModel:(ProductObject *)newObject;        // This method handles both "Insert" and "Update"
                                                            // If "id == 0", do Insert
                                                            // If "id != 0", then do Update

-(ProductObject *) getObjectAtIndexPath:(NSIndexPath *)indexPath;

-(void) describeModel;
-(void) createObjectFromJSONOFile:(NSInteger)fileNumber;

-(void) setCurrentProductObject:(ProductObject *)newObject;
-(void) unsetCurrentProductObject;
-(void) deleteCurrentProductObjectFromModel;                // SQL "Delete"
-(ProductObject *)getCurrentProductObject;


@end







