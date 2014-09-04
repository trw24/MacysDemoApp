//
//  modelAndDatabaseTestCases.m
//  MacyDemo
//
//  Created by troy on 9/3/14.
//  Copyright (c) 2014 Troy W. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProductObject.h"
#import "ProductModel.h"

@interface modelAndDatabaseTestCases : XCTestCase

@end

@implementation modelAndDatabaseTestCases

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"=======================");
}

- (void)tearDown
{
    // clear model and database when finished
    ProductModel * productModel = [ProductModel getProductModel];
    [productModel clearModelAndDatabase];
    NSLog(@"-----------------------");
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}




-(void) testModelAndDatabaseHaveSameNumberOfElementsAfterClearing
{
    NSLog(@"==> %s", __PRETTY_FUNCTION__);
    ProductModel * productModel = [ProductModel getProductModel];
    [productModel clearModelAndDatabase];
    
    XCTAssertTrue([productModel modelAndDatabaseHaveSameNumberOfRecords], @"Problem: model and database do not both have zero objects/records after being cleared");
}

-(void) testModelHasZeroObjectsAfterClearing
{

    NSLog(@"==> %s", __PRETTY_FUNCTION__);
    ProductModel * productModel = [ProductModel getProductModel];

    [productModel clearModelAndDatabase];
    int numberOfObjectsInModel = [productModel getNumberOfObjectsInModel];
    
    XCTAssertEqual(numberOfObjectsInModel, 0, @"Problem model not empty after being cleared");

}


#if 0
//
// this test not working
//
// it needs to be implemented in a way to accommodate asynchronous method calls
// apple is expected to included methods and techniques for this in xcode # 6
//
//    -(void) testNumberOfElementsInModelAfterAddingSome
//    {
//        NSLog(@"==> %s", __PRETTY_FUNCTION__);
//        ProductModel * productModel = [ProductModel getProductModel];
//        [productModel clearModelAndDatabase];
//        // next 5 calls are asynchronous
//        [productModel createObjectFromJSONFile:JSON_OBJECT_1];
//        [productModel createObjectFromJSONFile:JSON_OBJECT_2];
//        [productModel createObjectFromJSONFile:JSON_OBJECT_3];
//        [productModel createObjectFromJSONFile:JSON_OBJECT_4];
//        [productModel createObjectFromJSONFile:JSON_OBJECT_5];
//        
//        int numberOfObjectsInModel = [productModel getNumberOfObjectsInModel];
//        
//        XCTAssertEqual(numberOfObjectsInModel, 5, @"Problem: number of elements in model is not correct");
//    }
//
// asyc test methods include: expectationWithDescription and waitForExpectationsWithTimeout
//
// More info here:  https://developer.apple.com/library/prerelease/ios/documentation/DeveloperTools/Conceptual/testing_with_xcode/testing_3_writing_test_classes/testing_3_writing_test_classes.html
//
#endif


@end
















