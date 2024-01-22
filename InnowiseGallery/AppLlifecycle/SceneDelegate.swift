//
//  SceneDelegate.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/17/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: scene)

        let rootViewController = ImageGalleryDIContainer().viewController

        window?.rootViewController = UINavigationController(rootViewController: rootViewController)

        window?.makeKeyAndVisible()

        Task {
            await ImageStorage.shared.loadImageIds()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        Task {
            await ImageStorage.shared.saveFavoriteImages()
        }
    }
}
