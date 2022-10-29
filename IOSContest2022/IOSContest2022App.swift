//
//  IOSContest2022App.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 25.10.2022.
//

import SwiftUI

@main
struct MainApp {
    static func main() {
        if #available(iOS 14.0, *) {
            IOSContest2022App.main()
        } else {
            UIApplicationMain(
                CommandLine.argc,
                CommandLine.unsafeArgv,
                nil,
                NSStringFromClass(AppDelegate.self))
        }
    }
}

@available(iOS 14.0, *)
struct IOSContest2022App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
