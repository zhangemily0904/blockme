//
//  StorageViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 11/3/22.
//

import Foundation
import FirebaseStorage
import SwiftUI

// This viewmodel is responsible for interacting with cloud storage to upload / download profile images
class StorageViewModel {
  static private let MAX_DOWNLOAD_IMAGE_SIZE: Int64 = 5 * 1024 * 1024
  
  static func retrieveProfileImage(imagePath: String, completion: @escaping (UIImage?) -> Void) {
    let storageRef = Storage.storage().reference()
    let fileRef = storageRef.child(imagePath)

    fileRef.getData(maxSize:  MAX_DOWNLOAD_IMAGE_SIZE) { data, error in
      if error == nil && data != nil {
        completion(UIImage(data: data!))
        return
      }
      
      print("Error fetching image of path \(imagePath) \(error!.localizedDescription)")
      completion(nil)
    }
  }
  
  static func uploadImageToCloud(uid: String, image: UIImage, completion: @escaping (String?, Error?) -> Void) {
    let path = "images/\(uid).jpeg"
    let storageRef = Storage.storage().reference().child(path)
    let data = image.jpegData(compressionQuality: 0.1)
    
    guard let data = data else {
      completion(nil, nil)
      return
    }
    let metadata = StorageMetadata()
    metadata.contentType = "images/jpeg"
    storageRef.putData(data, metadata: metadata) { (metadata, error)  in
      guard error == nil else {
        completion(nil, error)
        return
      }
      completion(path, error)
    }
  }
}
