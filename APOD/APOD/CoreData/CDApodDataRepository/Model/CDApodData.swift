//
//  CDApodData.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import CoreData

class CDApodData: NSManagedObject {
    @NSManaged var copyright: String
    @NSManaged var explanation: String
    @NSManaged var mediaType: String
    @NSManaged var title: String
    @NSManaged var imagePath: String
    @NSManaged var date: String
}
