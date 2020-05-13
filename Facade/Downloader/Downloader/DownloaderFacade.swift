//
//  DownloaderFacade.swift
//  Downloader
//
//  Created by Dharmendra Valiya on 05/13/20
//

import Foundation

public enum DownloaderError: Error {
    case forwarded(Error)
    case invalidLocation
}

public struct DownloaderFacade {
    public static func fetchData(from url: URL,
                                 completionHandler: @escaping (Result<URL, DownloaderError>) -> Void) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            guard error == nil else {
                completionHandler( .failure(.forwarded(error!)))
                return
            }
            
            guard let tempFileURL = url else {
                completionHandler( .failure(.invalidLocation) )
                return
            }
            
            do {
                let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                               in: .userDomainMask,
                                                               appropriateFor: nil,
                                                               create: false)
                // create a permanent file URL and move the dowloaded file
                let permanentFileURL = documentsURL.appendingPathComponent(tempFileURL.lastPathComponent)
                
                try FileManager.default.moveItem(at: tempFileURL, to: permanentFileURL)
                
                completionHandler( .success(permanentFileURL))
            } catch {
                completionHandler( .failure(.forwarded(error)) )
            }
        }
        
        downloadTask.resume()
    }
}
