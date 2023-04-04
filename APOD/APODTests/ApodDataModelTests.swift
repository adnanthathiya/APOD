//
//  ApodDataModelTests.swift
//  APODTests
//
//  Created by Adnan Thathiya on 04/04/23.
//

import XCTest

@testable import APOD

class ApodDataModelTests: XCTestCase {
    private var model: ApodData!

    override func setUpWithError() throws {
        model = createApodDataModel()
        XCTAssertNotNil(model)
    }

    override func tearDownWithError() throws {
        model = nil
    }

    func testCreateApodDataModel() {
        let apodData = createApodDataModel()
        XCTAssertNotNil(apodData)

        XCTAssertEqual(apodData.title, "Olympus Mons: Largest Volcano in the Solar System")
        XCTAssertEqual(apodData.explanation, "The largest volcano in our Solar System is on Mars.  Although three times higher than Earth's Mount Everest, Olympus Mons will not be difficult for humans to climb because of the volcano's shallow slopes and Mars' low gravity.  Covering an area greater than the entire Hawaiian volcano chain, the slopes of Olympus Mons typically rise only a few degrees at a time.  Olympus Mons is an immense shield volcano, built long ago by fluid lava.  A relatively static surface crust allowed it to build up over time. Its last eruption is thought to have been about 25 million years ago.  The featured image was taken by the European Space Agency's robotic Mars Express spacecraft currently orbiting the  Red Planet.    Your Sky Surprise: What picture did APOD feature on your birthday? (post 1995)")
        XCTAssertEqual(apodData.url, "https://apod.nasa.gov/apod/image/2304/OlympusMons_MarsExpress_960.jpg")
        XCTAssertEqual(apodData.mediaType, "image")
        XCTAssertEqual(apodData.date, "2023-04-04")
    }

    //MARK: Helper Methods
    func createApodDataModel() -> ApodData {
        return .init(title: "Olympus Mons: Largest Volcano in the Solar System",
                     explanation: "The largest volcano in our Solar System is on Mars.  Although three times higher than Earth's Mount Everest, Olympus Mons will not be difficult for humans to climb because of the volcano's shallow slopes and Mars' low gravity.  Covering an area greater than the entire Hawaiian volcano chain, the slopes of Olympus Mons typically rise only a few degrees at a time.  Olympus Mons is an immense shield volcano, built long ago by fluid lava.  A relatively static surface crust allowed it to build up over time. Its last eruption is thought to have been about 25 million years ago.  The featured image was taken by the European Space Agency's robotic Mars Express spacecraft currently orbiting the  Red Planet.    Your Sky Surprise: What picture did APOD feature on your birthday? (post 1995)",
                     url: "https://apod.nasa.gov/apod/image/2304/OlympusMons_MarsExpress_960.jpg",
                     mediaType: "image",
                     copyright: nil,
                     date: "2023-04-04",
                     imagePath: nil)
    }
}
