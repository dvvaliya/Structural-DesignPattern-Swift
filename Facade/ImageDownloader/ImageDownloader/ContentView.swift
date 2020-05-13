//
//  ContentView.swift
//  ImageDownloader
//
//  Created by Dharmendra Valiya on 05/13/20
//

import SwiftUI
import Downloader

struct ContentView: View {
    @State private var input: String = ""
    @ObservedObject var imageProvider = ImageProvider()
    
    var body: some View {
        VStack {
            TextField("Enter url", text: $input, onEditingChanged: { (_) in
            }) {
                if !self.input.isEmpty {
                    // download image
                    if let url = URL(string: self.input) {
                        self.imageProvider.getImage(at: url)
                    }
                }
            }
            .font(.title)
            
            Divider()
            
            Image(uiImage: imageProvider.image ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ImageProvider: ObservableObject {
    @Published var image: UIImage?
    
    func getImage(at url: URL) {
        DownloaderFacade.fetchData(from: url) { (result) in
            switch result {
            case .success(let url):
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                    }
                }
            case .failure(let error):
                print(error)
            }
            
        }
        /*
        let downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            guard error == nil else {
                print("\(error!)")
                return
            }
            
            guard let tempFileURL = url else {
                print("No file URL returned.")
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
                
                if let imageData = try? Data(contentsOf: permanentFileURL) {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                    }
                }
            } catch {
                print("\(error)")
            }
        }
        
        downloadTask.resume()
 */
    }
}
