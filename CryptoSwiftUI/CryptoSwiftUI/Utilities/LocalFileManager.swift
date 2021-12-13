//
//  LocalFileManager.swift
//  CryptoSwiftUI
//
//  Created by Valery Kavaleuski on 13.12.21.
//

import Foundation
import SwiftUI

final class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    func saveImage(image: UIImage,
                   imageName: String,
                   folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            debugPrint("error saving image: \(imageName), \(error)")
        }
    }
    
    func getImage(imageName: String,
                  folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(
                    at: url,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch let error {
                debugPrint("error creating directory ", error.localizedDescription, "; Folder name: \(folderName)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getURLForImage(
        imageName: String,
        folderName: String) -> URL? {
        getURLForFolder(folderName: folderName)?
            .appendingPathComponent(imageName + ".png")
    }
}
