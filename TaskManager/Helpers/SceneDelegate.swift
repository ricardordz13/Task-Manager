//
//  SceneDelegate.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 03/04/24.
//

import UIKit
import SwiftUI
import CloudKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let persistenceController = PersistenceController.shared
    var sharedUsers: [CKUserIdentity] = []

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Create the SwiftUI view and set the context on the content view
        let contentView = ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        
        // Use a UIHostingController as window root view controller
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
        // Fetch shared users if app was launched via CloudKit sharing
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let incomingURL = userActivity.webpageURL {
            handleIncomingShare(with: incomingURL)
        }
    }
    
    func handleIncomingShare(with url: URL) {
        let container = CKContainer.default()
        container.sharedCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: url.lastPathComponent)) { record, error in
            if let record = record, let share = record.object(forKey: CKRecord.SystemFieldKey.share) as? CKShare {
                DispatchQueue.main.async {
                    self.fetchSharedUsers(for: share)
                }
            } else {
                print("Error fetching record: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchSharedUsers(for share: CKShare) {
        for participant in share.participants ?? [] {
            let userIdentity = participant.userIdentity
            CKContainer.default().discoverUserIdentity(withUserRecordID: userIdentity.userRecordID!) { userIdentity, error in
                if let userIdentity = userIdentity {
                    self.sharedUsers.append(userIdentity)
                } else {
                    print("Error discovering user identity: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }



    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the managed object context when the application transitions to the background.
        try? PersistenceController.shared.container.viewContext.save()
    }

}
