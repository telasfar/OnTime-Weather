//

//

import XCTest

class OnTime_Weather_AppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
   
        app = XCUIApplication()
        continueAfterFailure = false
       
    }
    
    override func tearDown() {
        app = nil //3ashan fe kol mara yekon 3andena instance gededa men el app
        super.tearDown()
    }
    
    func test_tableView_cellDidSelect() {
      app.launch()
        XCTAssertTrue(app.staticTexts["ONTime Weather"].exists) //mawgood wala la2
        app.swipeLeft() //swipe left
        let articleTableView = XCUIApplication().tables["table--articleTableView"]
        XCTAssertTrue(articleTableView.exists, "The article tableview exists")

        
        let tableCells = articleTableView.cells
        if tableCells.count > 0 {
            let count: Int = (tableCells.count - 1)
            
            let promise = expectation(description: "Wait for table cells")
            
            for i in stride(from: 0, to: count , by: 1) {
                // Grab the first cell and verify that it exists and tap it
                let tableCell = tableCells.element(boundBy: i)
                XCTAssertTrue(tableCell.exists, "The \(i) cell is in place on the table")
                // Does this actually take us to the next screen
                tableCell.tap()
                
                if i == (count - 1) {
                    promise.fulfill()
                }
                // Back
            }
            waitForExpectations(timeout: 20, handler: nil)
            XCTAssertTrue(true, "Finished validating the table cells")
            
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }

    }
   
    func test_swipeLeft_goToHome(){
        app.launch() //sha3'al el app
        XCTAssertTrue(app.staticTexts["ONTime Weather"].exists) //mawgood wala la2
        app.swipeLeft() //swipe left
        
        XCTAssertTrue(app.staticTexts["HOME"].exists)
    }
}
