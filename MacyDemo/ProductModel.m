//
//  ProductModel.m
//  MacyDemo
//
//  Created by troy on 7/26/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import "ProductModel.h"

#define PRODUCT_ID_STARTING_NUMBER  100
#define SQLLITE_DATABASE_FILE_NAME  @"products.db"
#define KEY_FOR_USER_DEFAULTS       @"somethingLongExcellentAndUnique"


@interface ProductModel ()

@property (nonatomic) NSNumber              * nextAvailableProductId;         // non-repeating counter
@property (nonatomic) NSMutableArray        * mutableArray;
@property (nonatomic, strong) ProductObject * currentlySelectedProductObject;

//
// sqlite
//

@property (nonatomic, strong) NSURL     * documentDirectoryURL;
@property (nonatomic, strong) NSString  * databasePath;
@property (nonatomic) sqlite3           * productDB;

-(void) insertObjectIntoDatabase:(ProductObject *)newObject;
-(void) updateObjectInDatabase:(ProductObject *)newObject;
-(int)  numberOfRecordsInDatabase;

@end



@implementation ProductModel

-(int) numberOfRecordsInDatabase
{
    //
    // Returns number of records in database
    //
    NSFileManager *fileManager = [NSFileManager defaultManager];
    const char *dbpath = [self.databasePath UTF8String];
    sqlite3 * localProductDB;
    const char *sql_stmt;
    SQLITE_API int integerResult;
    sqlite3_stmt * sqlResult;
    
    int result = 0;
    
    if ([fileManager fileExistsAtPath:self.databasePath] == YES)
    {
        
        if (sqlite3_open(dbpath, &localProductDB) == SQLITE_OK)
        {
            self.productDB = localProductDB;
            
            NSString *sqlStatementString = @"SELECT COUNT(*) FROM product_table;";
            
            sql_stmt = [sqlStatementString UTF8String];
            
            integerResult = sqlite3_prepare_v2(localProductDB, sql_stmt, -1, &sqlResult, NULL);
            if (integerResult != SQLITE_OK)
            {
                NSLog(@"SQL: ERROR:  Prepare: %@ ==> %d", sqlStatementString, integerResult);
            }
            else
            {
                integerResult = sqlite3_step(sqlResult);
                
                if (integerResult == SQLITE_ROW)
                {
                    result = (int)sqlite3_column_int(sqlResult, 0);
                }
                else
                {
                    NSLog(@"SQL: Error: invalid response from database: %d", integerResult);
                    result = 0;
                }
            }
            
            sqlite3_finalize(sqlResult);    // finalize previous statement
            sqlite3_close(localProductDB);  // close the database
        }
    }
    else
    {
        NSLog(@"SQL: Error:  database not available: %@", self.databasePath);
    }
    
    return result;
}




-(void) deleteCurrentProductObjectFromModel
{
    //
    // Delete an existing ProductObject from both the SharedModel and the database.
    //
    // Strategy is to first Delete Record from database, then delete record from SharedModel
    //
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    const char *dbpath = [self.databasePath UTF8String];
    sqlite3 * localProductDB;
    const char *sql_stmt;
    char *errorMessage;
    
    if ([fileManager fileExistsAtPath:self.databasePath] == YES)
    {
        if (sqlite3_open(dbpath, &localProductDB) == SQLITE_OK)
        {
            self.productDB = localProductDB;
            
            NSString *sqlStatementString;
            
            sqlStatementString = [NSString stringWithFormat:
                                  @"DELETE FROM product_table WHERE %@ = %d;",
                                  @"product_id",            [self.currentlySelectedProductObject.id intValue]
                                  ];
            
            sql_stmt = [sqlStatementString UTF8String];
            
            // NSLog(@"Database DELETE string = %@", sqlStatementString);
            
            if (sqlite3_exec(localProductDB, sql_stmt, NULL, NULL, &errorMessage) != SQLITE_OK)
            {
                NSLog(@"Failed to Delete record");
            }
            else
            {
                // By including this line inside the code block,
                // we will only delete from the SharedModel IF able to access the database.
                
                [self deleteObjectFromModelWithProductObject:self.currentlySelectedProductObject];
                // NSLog(@"Record Deleted successfully");
            }
            sqlite3_close(localProductDB);
        }
    }
    else
    {
        NSLog(@"SQL: Error:  database not available: %@", self.databasePath);
    }
}


-(void) copyAllRecordsFromDatabaseToDataModel
{
    //
    // Select ALL
    // Adds all database records to sharedDataModel
    //
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    const char *dbpath = [self.databasePath UTF8String];
    sqlite3 * localProductDB;
    const char *sql_stmt;
    // char *errorMessage;
    SQLITE_API int integerResult;
    sqlite3_stmt * sqlResult;
    
    ProductObject * newObject;
    NSString * colorString;
    

    if ([fileManager fileExistsAtPath:self.databasePath] == YES)
    {
        
        if (sqlite3_open(dbpath, &localProductDB) == SQLITE_OK)
        {
            self.productDB = localProductDB;
    
            // First, we must clear out existing model to make sure no duplicates
            self.mutableArray = [[NSMutableArray alloc] init];
            self.currentlySelectedProductObject = nil;
            
            NSString *sqlStatementString;
            
            sqlStatementString = [NSString stringWithFormat: @"SELECT %@, %@, %@, %@, %@, %@, %@, %@ FROM product_table;",
                                  @"product_id",
                                  @"product_name",
                                  @"product_description",
                                  @"image_thumb",
                                  @"image_full",
                                  @"regular_price",
                                  @"sale_price",
                                  @"product_color"
                                  ];
            
            // NSLog(@"Selection String:  %@", sqlStatementString);
            
            sql_stmt = [sqlStatementString UTF8String];
            
            integerResult = sqlite3_prepare_v2(localProductDB, sql_stmt, -1, &sqlResult, NULL);
            if (integerResult != SQLITE_OK)
            {
                NSLog(@"SQL: ERROR:  Prepare: %@ ==> %d", sqlStatementString, integerResult);
            }
            else
            {
                integerResult = sqlite3_step(sqlResult);
                
                while (integerResult != SQLITE_DONE)
                {
                    // create new object
                    newObject = [[ProductObject alloc] init];
                    
                    // Fill it up with values returned from the database
                    newObject.id            = [NSNumber numberWithInt:(int)sqlite3_column_int(sqlResult, 0)];
                    newObject.name          = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlResult, 1)];
                    newObject.description   = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlResult, 2)];
                    newObject.imageThumb    = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlResult, 3)];
                    newObject.imageFull     = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlResult, 4)];
                    newObject.regularPrice  = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlResult, 5)];
                    newObject.salePrice     = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlResult, 6)];
                    colorString             = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlResult, 7)];
                    newObject.colorArray    = [[NSArray alloc] initWithObjects:colorString, nil];  // only preserving 1 color in database
                    
                    // add it to array
                    [self.mutableArray addObject:newObject];
                    
                    integerResult = sqlite3_step(sqlResult);    // get next record
                    
                }
                
            }

            sqlite3_finalize(sqlResult);    // finalize previous statement
            sqlite3_close(localProductDB);
        }
    }
    else
    {
        NSLog(@"SQL: Error:  database not available: %@", self.databasePath);
    }
}


-(void) updateObjectInDatabase:(ProductObject *)newObject
{
    //
    // Update an existing object (does not create/insert a new object)
    //
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    const char *dbpath = [self.databasePath UTF8String];
    sqlite3 * localProductDB;
    const char *sql_stmt;
    char *errorMessage;
    
    if ([fileManager fileExistsAtPath:self.databasePath] == YES)
    {
        
        if (sqlite3_open(dbpath, &localProductDB) == SQLITE_OK)
        {
            self.productDB = localProductDB;
            
            NSString *sqlStatementString;
     
            sqlStatementString = [NSString stringWithFormat:
                                 @"UPDATE product_table SET %@ = \'%@\', %@ = \'%@\', %@ = \'%@\', %@ = \'%@\', %@ = \'%@\', %@ = \'%@\', %@ = \'%@\' WHERE %@ = %d;",
                                  @"product_name",          newObject.name,
                                  @"product_description",   newObject.description,
                                  @"image_thumb",           newObject.imageThumb,
                                  @"image_full",            newObject.imageFull,
                                  @"regular_price",         newObject.regularPrice,
                                  @"sale_price",            newObject.salePrice,
                                  @"product_color",         [newObject.colorArray firstObject],
                                  @"product_id",            [newObject.id intValue]             // Note: 'id' field is NSNumber (not string)
                                  ];

            
            sql_stmt = [sqlStatementString UTF8String];
            
            // NSLog(@"Database UPDATE string = %@", sqlStatementString);
            
            if (sqlite3_exec(localProductDB, sql_stmt, NULL, NULL, &errorMessage) != SQLITE_OK)
            {
                NSLog(@"Failed to update record");
            }
            else
            {
                // NSLog(@"Record updated successfully");
            }
            
            sqlite3_close(localProductDB);
        }
    }
    else
    {
        NSLog(@"SQL: Error:  database not available: %@", self.databasePath);
    }
}



-(void) insertObjectIntoDatabase:(ProductObject *)newObject
{
    //
    // Create/Insert new ProductOjbect into database (makes new database record)
    //
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    const char *dbpath = [self.databasePath UTF8String];
    sqlite3 * localProductDB;
    const char *sql_stmt;
    char *errorMessage;
    
    if ([fileManager fileExistsAtPath:self.databasePath] == YES)
    {
        
        if (sqlite3_open(dbpath, &localProductDB) == SQLITE_OK)
        {
            self.productDB = localProductDB;

            NSArray  *sqlStatementArray;
            NSString *sqlStatementString;
            NSString * firstColor;

            // Find and save first color in array
            if ([newObject.colorArray count] > 0)
            {
                firstColor = [newObject.colorArray firstObject];
            }
            else
            {
                firstColor = @"";   // the Empty String
            }
            
            sqlStatementArray = [[NSArray alloc] initWithObjects:
                                 @"INSERT INTO product_table (product_id, product_name, product_description, image_thumb, image_full, regular_price, sale_price, product_color) VALUES (",
                                 newObject.id, @", ",
                                 @"\'", newObject.name, @"\', ",
                                 @"\'", newObject.description, @"\', ",
                                 @"\'", newObject.imageThumb, @"\', ",
                                 @"\'", newObject.imageFull, @"\', ",
                                 @"\'", newObject.regularPrice, @"\', ",
                                 @"\'", newObject.salePrice, @"\', ",
                                 @"\'", firstColor, @"\'",
                                 @");",
                                 nil];
            
            sqlStatementString = [sqlStatementArray componentsJoinedByString:@""];
            sql_stmt = [sqlStatementString UTF8String];
            
            // NSLog(@"Database INSERTION string = %@", sqlStatementString);
            
            if (sqlite3_exec(localProductDB, sql_stmt, NULL, NULL, &errorMessage) != SQLITE_OK)
            {
                NSLog(@"Failed to insert record");
            }
            else
            {
                // NSLog(@"Record inserted successfully");
            }
            
            sqlite3_close(localProductDB);

        }
    }
    else
    {
        NSLog(@"SQL: Error:  database not available: %@", self.databasePath);
    }
}



-(void) addObjectToModel:(ProductObject *)newObject
{
    //
    // This method handles both Updates and Inserts.
    //
    // If, newObject.id == 0, then this creates new record and does Insert (and generate new id)
    // If, newObject.id != 0, then this is Update for an existing record
    //
    if ([newObject.id integerValue] == 0)
    {
        // Case where adding new object to model
        newObject.id = self.nextAvailableProductId;
        [self.mutableArray addObject:newObject];
        self.nextAvailableProductId = [NSNumber numberWithInt:(1 + (int)[self.nextAvailableProductId integerValue])];
        
        // save new value in UserDefaults
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:self.nextAvailableProductId forKey:KEY_FOR_USER_DEFAULTS];
        [userDefaults synchronize];

        [self insertObjectIntoDatabase:newObject];

    }
    else
    {
        // Case where record already exists.  So, do Update
        int numberOfRecords = (int)[self.mutableArray count];
        int i = 0;
        ProductObject * tempProduct;
        
        while (i<numberOfRecords)
        {
            tempProduct = [self.mutableArray objectAtIndex:i];
            if ([tempProduct.id intValue] == [newObject.id intValue])
            {
                [self.mutableArray replaceObjectAtIndex:i withObject:newObject];
                break;
            }
            i++;
        }
        
        [self updateObjectInDatabase:newObject];

    }
}



//  Class Method(s)
+ (ProductModel *)getProductModel
{
    static ProductModel * _ProductModel;
    
    if ( ! _ProductModel)
    {
        _ProductModel = [[ProductModel alloc] init];
        _ProductModel.mutableArray = [[NSMutableArray alloc] init];
        _ProductModel.currentlySelectedProductObject = nil;
        _ProductModel.nextAvailableProductId = [NSNumber numberWithInt:PRODUCT_ID_STARTING_NUMBER];

        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userDefaultsString = [userDefaults valueForKey:KEY_FOR_USER_DEFAULTS];

        if (userDefaultsString == nil)
        {
            // NSLog(@"userDefaultsString == nil");
        }
        
        if ((userDefaultsString != nil) && ([userDefaultsString intValue] > PRODUCT_ID_STARTING_NUMBER))
        {
            _ProductModel.nextAvailableProductId = [NSNumber numberWithInt:[userDefaultsString intValue]];
        }
        
        //
        //  SQLite: Create (or Verify) Database and Table
        //
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        _ProductModel.documentDirectoryURL = (NSURL *)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        _ProductModel.databasePath = [[_ProductModel.documentDirectoryURL path] stringByAppendingPathComponent:SQLLITE_DATABASE_FILE_NAME];
        _ProductModel.productDB = nil;

        sqlite3 * localProductDB;

        if ([fileManager fileExistsAtPath:_ProductModel.databasePath] == NO)
        {
            // NSLog(@"Database does NOT exist");
            
            const char *dbpath = [_ProductModel.databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &localProductDB) == SQLITE_OK)
            {
                _ProductModel.productDB = localProductDB;
                char *errorMessage;
                NSArray *sqlStatementArray;
                NSString *sqlStatementString;
                const char *sql_stmt;
                
                sqlStatementArray = [[NSArray alloc] initWithObjects:
                                     @"CREATE TABLE IF NOT EXISTS product_table (product_key INTEGER PRIMARY KEY AUTOINCREMENT, ",
                                     @"product_id INTEGER, ",
                                     @"product_name TEXT, ",
                                     @"product_description TEXT, ",
                                     @"image_thumb TEXT, ",
                                     @"image_full TEXT, ",
                                     @"regular_price TEXT, ",
                                     @"sale_price TEXT, ",
                                     @"product_color TEXT ",
                                     @");",
                                     nil];
                
                sqlStatementString = [sqlStatementArray componentsJoinedByString:@" "];
                sql_stmt = [sqlStatementString UTF8String];
                
                // NSLog(@"Database creation string = %@", sqlStatementString);
                                     
                if (sqlite3_exec(_ProductModel.productDB, sql_stmt, NULL, NULL, &errorMessage) != SQLITE_OK)
                {
                    NSLog(@"Failed to create product_table");
                }
                else
                {
                    // No need to report status every time
                    // NSLog(@"Database and product_table Created Successfully");
                }
                
                sqlite3_close(_ProductModel.productDB);
                
            }
            else
            {
                NSLog(@"SQL: Failed to create/open database");
            }
        }
        else
        {
            // No need to report status message every time
            // NSLog(@"SQL: Database already exists");
        }

    }
    
    return (_ProductModel);
}


//
//  These methods support concept of a Current Object (i.e. current database record).
//  It helps keep track of which object (record) is active while navigating between the views.
//
-(void) setCurrentProductObject:(ProductObject *)newObject
{
    self.currentlySelectedProductObject = newObject;
}

-(void) unsetCurrentProductObject
{
    self.currentlySelectedProductObject = nil;
}

-(ProductObject *)getCurrentProductObject
{
    return self.currentlySelectedProductObject;
}


-(void) describeModel
{
    ProductObject * productObject;
    unsigned long size = [self.mutableArray count];
    if (size == 0)
    {
        NSLog(@"Data Model is empty");
        NSLog(@"Database ProductTable contains %d rows", [self numberOfRecordsInDatabase]);
    }
    else
    {
        NSLog(@"============================");
        for (int i=0; i<size; i++)
        {
            productObject = [self.mutableArray objectAtIndex:i];
            NSLog(@"[%d] %ld %@ %@",
                  i,
                  (long)[productObject.id integerValue],
                  productObject.name,
                  productObject.description
                  );
        }

        if (self.currentlySelectedProductObject == nil)
        {
            NSLog(@"currentProductObject == nil");
        }
        else
        {
            NSLog(@"currentProductObject.id = %d", [self.currentlySelectedProductObject.id intValue]);
        }
        NSLog(@"nextAvailableProductId = %ld", (long)[self.nextAvailableProductId integerValue]);
        NSLog(@"Shared Data Model contains %d Objects", (int)[self.mutableArray count]);
        NSLog(@"Database ProductTable contains %d Records", [self numberOfRecordsInDatabase]);
        
        NSLog(@"----------------------------");

    }
}


- (void) doNothing {}


- (int) getNumberOfObjectsInModel
{
    return ((int)[self.mutableArray count]);
}


- (ProductObject *) getObjectAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row >= 0) && (indexPath.row < [self.mutableArray count]))
    {
        return  ([self.mutableArray objectAtIndex:indexPath.row]);
    }
    else
    {
        return nil;
    }
}


- (void) deleteObjectFromModelWithProductObject:(ProductObject *)productObjectToDelete
{
    if (productObjectToDelete == nil)
    {
        return;
    }
    else if ([productObjectToDelete.id intValue] == 0)
    {
        return;
    }
    else
    {
        // Case where record already exists.  So, find it and remove it
        int numberOfRecords = (int)[self.mutableArray count];
        int i = 0;
        ProductObject * tempProduct;
        
        while (i<numberOfRecords)
        {
            tempProduct = [self.mutableArray objectAtIndex:i];
            if ([tempProduct.id intValue] == [productObjectToDelete.id intValue])
            {
                [self.mutableArray removeObjectAtIndex:i];
                break;
            }
            i++;
        }
    }
}



#define BASE_JSON_FILE_NAME  @"product_"
#define BASE_JSON_FILE_EXTENSION @"json"
#define BACKGROUND_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


-(void) createObjectFromJSONOFile:(int)fileNumber
{

    dispatch_async(BACKGROUND_QUEUE, ^{
        
        // Retrieve data in background thread
        NSString * fileName = [NSString stringWithFormat:@"%@%d", BASE_JSON_FILE_NAME, fileNumber];
        NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:BASE_JSON_FILE_EXTENSION];
        
        NSData * fileData = [NSData dataWithContentsOfFile:filePath];

        NSError *error;
        NSDictionary * jsonDictionary = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:&error];
        
        NSDictionary * productDictionary = [jsonDictionary objectForKey:@"product"];
        
        ProductObject * productObject = [[ProductObject alloc] init];

        productObject.id            = [productDictionary objectForKey:@"id"];
        productObject.name          = [productDictionary objectForKey:@"name"];
        productObject.description   = [productDictionary objectForKey:@"description"];
        productObject.imageFull     = [productDictionary objectForKey:@"image_full"];
        productObject.imageThumb    = [productDictionary objectForKey:@"image_thumb"];
        productObject.regularPrice  = [productDictionary objectForKey:@"regular_price"];
        productObject.salePrice     = [productDictionary objectForKey:@"sale_price"];

        NSArray * jsonColorArray = [productDictionary objectForKey:@"color_array"];
        NSMutableArray * mutableColorArray = [[NSMutableArray alloc] init];
        
        int numberOfColors = (int)[jsonColorArray count];
        
        for (int i=0; i<numberOfColors; i++)
        {
            [mutableColorArray addObject:[jsonColorArray objectAtIndex:i]];
        }

        productObject.colorArray = mutableColorArray;
        
        // Need to call ADD method to correctly handle ProductId
        // If product_id == 0, it will create new object/record
        // If product_id != 0, it will do Update on existing record
        [self addObjectToModel:productObject];
    });
    
}



-(void) createObjectManually:(int)fileNumber
{
    ProductObject * productObject = [[ProductObject alloc] init];
    
    switch (fileNumber)
    {
        case (JSON_OBJECT_1):
            productObject.id = [NSNumber numberWithInt:1];
            productObject.name = @"Jones New York Devon Three Button Blazer & Pencil Skirt";
            productObject.description = @"Suit yourself in this exquisitely tailored skirt suit from Jones New York.";
            productObject.imageFull = @"1161907_full";
            productObject.imageThumb = @"1161907_thumb";
            productObject.regularPrice = @"198.00";
            productObject.salePrice = @"157.98";
            // productObject.colorArray = [NSArray arrayWithObjects: nil];
            productObject.colorArray = [NSArray arrayWithObjects:@"Light Black", @"Dark Black", nil];
            break;
            
        case (JSON_OBJECT_2):
            productObject.id = [NSNumber numberWithInt:2];
            productObject.name = @"Tahari ASL Textured Crepe Skirt Suit";
            productObject.description = @"Command attention in Tahari by ASLs ravishing short-sleeve skirt suit featuring sleek button details for modern style.";
            productObject.imageFull = @"2116932_full";
            productObject.imageThumb = @"2116932_thumb";
            productObject.regularPrice = @"280.00";
            productObject.salePrice = @"129.99";
            productObject.colorArray = [NSArray arrayWithObjects:@"Light Red", nil];
            break;
            
        case (JSON_OBJECT_3):
            productObject.id = [NSNumber numberWithInt:3];
            productObject.name = @"Tahari ASL Textured Jacket, Ruffle-Front Blouse & Pencil Skirt";
            productObject.description = @"Sport a luxe look in Tahari ASLs chic suit separates featuring this chic lock-button jacket and matching pencil skirt!";
            productObject.imageFull = @"2127972_full";
            productObject.imageThumb = @"2127972_thumb";
            productObject.regularPrice = @"254.00";
            productObject.salePrice = @"201.98";
            productObject.colorArray = [NSArray arrayWithObjects:@"Teal", @"Blue", nil];
            break;
            
        default:
            NSLog(@"Ooops... Messed up");
            break;
    }

    // Need to call ADD method to correctly handle ProductId
    [self addObjectToModel:productObject];

    return;
}


@end










