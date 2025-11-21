import XCTest
import CoreData
@testable import CityExplore

final class CityExplorerTests: XCTestCase {

    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        context = nil
    }

    func testPlaceCreation() throws {
        let place = Place(context: context)
        place.id = UUID()
        place.name = "Test Place"
        place.category = "Test Category"
        place.latitude = 10.0
        place.longitude = 20.0
        place.notes = "Test Notes"
        place.isFavorite = true

        XCTAssertNotNil(place.id)
        XCTAssertEqual(place.name, "Test Place")
        XCTAssertEqual(place.category, "Test Category")
        XCTAssertEqual(place.latitude, 10.0)
        XCTAssertEqual(place.longitude, 20.0)
        XCTAssertEqual(place.notes, "Test Notes")
        XCTAssertTrue(place.isFavorite)
    }
}
