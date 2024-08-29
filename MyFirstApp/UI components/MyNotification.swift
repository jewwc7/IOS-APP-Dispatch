//
//  MyNotification.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/15/24.
//

import SwiftUI

// https://www.youtube.com/watch?v=MPp7b9bIUPY
// https://youtu.be/MPp7b9bIUPY?t=918 explains how to make it prettier with the status bar, I didn;t implement this
extension UIApplication {
    func inAppNotification<Content: View>(adaptForDynmaicIsland: Bool = false, timeout: CGFloat = 5, swipeToClose: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        /// Fetcgug Active Window Via WindowScene. The current window excepting input, thus the window that the user is on
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) {
            // Frame and SafeArea Values
            let frame = activeWindow.frame
            let safeArea = activeWindow.safeAreaInsets
            
            var tag = 1009
            let checkForDynamicIsland = adaptForDynmaicIsland && safeArea.top >= 51
            
            // After animation is finsihed view must be removed from the window https://youtu.be/MPp7b9bIUPY?t=446
            if let previousTag = UserDefaults.standard.value(forKey: "in_app_notification_tag") as? Int {
                tag = previousTag + 1
            }
            
            UserDefaults.standard.setValue(tag, forKey: "in_app_notification_tag")
            /// Creating UIView from from swiftUIView using UIHosting Config
            let config = UIHostingConfiguration {
                AnimatedNotificationView(content: content(), safeArea: safeArea, tag: tag, adaptForDynamicIsalnd: checkForDynamicIsland, timeout: timeout, swipeToClose: swipeToClose).frame(width: frame.width - (checkForDynamicIsland ? 20 : 30), height: 120, alignment: .top).contentShape(.capsule)
            }
            /// Creating UIView
            let view = config.makeContentView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = tag
            
            if let rootView = activeWindow.rootViewController?.view {
                // Adding View to the window
                rootView.addSubview(view)
                
                // Layout Contraints
                view.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: rootView.centerYAnchor, constant: (-(frame.height - safeArea.top) / 2) + (checkForDynamicIsland ? 11 : safeArea.top)).isActive = true
            }
        }
    }
}

private struct AnimatedNotificationView<Content: View>: View {
    var content: Content
    var safeArea: UIEdgeInsets
    var tag: Int
    var adaptForDynamicIsalnd: Bool
    var timeout: CGFloat
    var swipeToClose: Bool
    @State private var animateNotification: Bool = false
    
    var body: some View {
        content // this is like passing childrent in react
            .blur(radius: animateNotification ? 0 : 10)
            .disabled(!animateNotification)
            .mask {
                if adaptForDynamicIsalnd {
                    RoundedRectangle(cornerRadius: 50, style: /*@START_MENU_TOKEN@*/ .continuous/*@END_MENU_TOKEN@*/)
                } else {
                    Rectangle()
                }
            }
            // SCaling animation only for Dynamic Island Notification
            .scaleEffect(adaptForDynamicIsalnd ? (animateNotification ? 1 : 0.01) : 1, anchor: .init(x: 0.5, y: 0.01))
            // Offset for non Dynamic Island Notifcation
            .offset(y: offsetY)
            .gesture(
                DragGesture().onEnded { value in
                    if -value.translation.height > 50, swipeToClose {
                        goAway()
                    }
                }
            )
            .onAppear(perform: {
                Task {
                    guard !animateNotification else { return }
                    withAnimation(.smooth) {
                        animateNotification = true
                    }
                    
                    // Timeout for Notifcation
                    try await Task.sleep(for: .seconds(timeout < 1 ? 1 : timeout))
                    
                    guard animateNotification else { return }
                    
                    goAway()
                }
            })
    }
    
    var offsetY: CGFloat {
        if adaptForDynamicIsalnd {
            return 0
        }
        return animateNotification ? 10 : -(safeArea.top + 130)
    }
    
    func goAway() {
        return withAnimation(.smooth, completionCriteria: .logicallyComplete) {
            animateNotification = false
        } completion: {
            removeNotifcationViewFromWindow()
        }
    }

    func removeNotifcationViewFromWindow() {
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) {
            if let view = activeWindow.viewWithTag(tag) {
                print("Removed View with \(tag)")
                view.removeFromSuperview()
            }
        }
    }
}

#Preview {
    ContentView()
}
