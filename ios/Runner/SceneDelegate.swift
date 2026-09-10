import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(
      scene,
      willConnectTo: session,
      options: connectionOptions
    )

    // public_file_saver 1.1.0 looks for the root view
    // controller through AppDelegate.window. Flutter's
    // scene lifecycle normally stores it in SceneDelegate.
    guard
      let appDelegate =
        UIApplication.shared.delegate as? AppDelegate,
      let windowScene = scene as? UIWindowScene
    else {
      return
    }

    appDelegate.window =
      window ??
      windowScene.windows.first(
        where: { $0.isKeyWindow }
      ) ??
      windowScene.windows.first
  }
}