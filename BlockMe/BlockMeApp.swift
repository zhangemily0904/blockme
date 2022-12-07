//
//  BlockMeApp.swift
//  BlockMe
//
//  Created by Brian Chou on 10/23/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct BlockMeApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
      WindowGroup {
          let appViewModel = AppViewModel()
          AppView()
          .environmentObject(appViewModel)
          .preferredColorScheme(.light)
      }
  }
}
