//
//  FileManager+Extension.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import Foundation

enum Folder {
    static let ApodImages = "ApodImages"
}

extension FileManager {
    static var documentDirectoryURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    static func createDirectory(atURL url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: createIntermediates)
    }

    static func fileExists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }

    static func removeFile(at path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }

    static func createFolder(at url: URL) throws {
        try FileManager.createDirectory(atURL: url, withIntermediateDirectories: true)
    }

    static func saveImage(with data: Data, in folder: String, with filename: String) throws -> URL? {
        guard let url = FileManager.documentDirectoryURL else { return nil }
        let folderUrl = url.appendingPathComponent(folder)

        if !FileManager.fileExists(at: folderUrl.path) {
            try FileManager.createFolder(at: folderUrl)
        }

        let saveImageUrl = folderUrl.appendingPathComponent(filename)

        if !FileManager.fileExists(at: saveImageUrl.path) {
            try data.write(to: saveImageUrl)
        }

        return saveImageUrl
    }
}
