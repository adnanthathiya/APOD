//
//  CDApodDataRepository.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import Foundation
import CoreData

protocol CDApodDataRepositoryProtocol {
    func getCDApodData(by date: String) -> CDApodData?
    func save(with apodData: ApodData) -> Bool
    func update(with apodData: ApodData) -> Bool
}

class CDApodDataRepository: CDApodDataRepositoryProtocol {

    func getCDApodData(by date: String) -> CDApodData? {
        let fetchRequest = NSFetchRequest<CDApodData>(entityName: "CDApodData")
        let predicate = NSPredicate(format: "date==%@", date)
        fetchRequest.predicate = predicate

        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            guard result != nil else { return nil }
            return result

        } catch let error {
            debugPrint(error)
        }

        return nil
    }

    func save(with apodData: ApodData) -> Bool {
        if self.isDataAvailable(for: apodData.date) {
            return self.update(with: apodData)
        } else {
            let cdApodData = CDApodData(context: PersistentStorage.shared.context)
            cdApodData.title = apodData.title
            cdApodData.explanation = apodData.explanation
            cdApodData.mediaType = apodData.mediaType
            cdApodData.copyright = apodData.copyright ?? ""
            cdApodData.date = apodData.date

            PersistentStorage.shared.saveContext()
            return true
        }
    }

    func update(with apodData: ApodData) -> Bool {
        guard let cdApodData = getCDApodData(by: apodData.date) else { return false }

        cdApodData.title = apodData.title
        cdApodData.explanation = apodData.explanation
        cdApodData.mediaType = apodData.mediaType
        cdApodData.copyright = apodData.copyright ?? ""
        cdApodData.date = apodData.date
        cdApodData.imagePath = apodData.imagePath ?? ""

        PersistentStorage.shared.saveContext()
        return true
    }

    func isDataAvailable(for date: String) -> Bool {
        return getCDApodData(by: date) != nil
    }
}
