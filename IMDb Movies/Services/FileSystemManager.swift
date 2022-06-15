//
//  FileSystemManager.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 15.06.2022.
//

import SwiftUI

final class FileSystemManager {
    enum FileSystemErrors: Error {
        case invalidSystemRoot
        case readingError
        case savingError
        case deletingError
        case imageCompressingError
    }
    
    private let baseURLs = FileManager.default.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
    
    func saveImage(image: UIImage, imageName: String) throws -> String {
        guard let baseURL = baseURLs.first else {
            throw FileSystemErrors.invalidSystemRoot
        }
        let name = "\(imageName).jpg"
        let url = baseURL.appendingPathComponent(name)
        try saveImageInFS(image: image, path: url)
        return name
    }
    
    private func saveImageInFS(image: UIImage, path: URL) throws {
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            throw FileSystemErrors.imageCompressingError
        }
        do {
            try data.write(to: path)
        } catch {
            throw FileSystemErrors.savingError
        }
    }
    
    func readImage(imagePath: String) throws -> UIImage {
        guard let baseURL = baseURLs.first else {
            throw FileSystemErrors.invalidSystemRoot
        }
        let url = baseURL.appendingPathComponent(imagePath)
        if let data = FileManager.default.contents(atPath: url.path),
           let image = UIImage(data: data) {
            return image
        } else {
            throw FileSystemErrors.readingError
        }
    }
    
    func deleteFile(fileName: String) throws {
        guard let baseURL = baseURLs.first else {
            throw FileSystemErrors.invalidSystemRoot
        }
        let url = baseURL.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(atPath: url.path)
        } catch {
            throw FileSystemErrors.deletingError
        }
    }
}
