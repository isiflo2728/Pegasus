//
//  CustomTabBar.swift
//  Pegasus
//
//  Created by Isidoro Flores on 3/12/26.
//

import SwiftUI

// Tab is now generic — any enum that has String raw values and lists all its cases works here
struct CustomTabBar<Tab: RawRepresentable & CaseIterable & Hashable, TabItemView: View>: UIViewRepresentable where Tab.RawValue == String {

    var size: CGSize
    var activeTint: Color = .blue
    var barTint: Color = .gray.opacity(0.15)

    @Binding var activeTab: Tab
    @ViewBuilder var tabItemview: (Tab) -> TabItemView

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UISegmentedControl {
        let items = Tab.allCases.map(\.rawValue)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0

        for (index, tab) in Tab.allCases.enumerated() {
            let renderer = ImageRenderer(content: tabItemview(tab))
            renderer.scale = 2
            control.setImage(renderer.uiImage, forSegmentAt: index)
        }

        DispatchQueue.main.async {
            for subview in control.subviews {
                if subview is UIImageView && subview != control.subviews.last {
                    subview.alpha = 0
                }
            }
        }
        control.selectedSegmentTintColor = UIColor(barTint)
        control.setTitleTextAttributes([.foregroundColor: UIColor(activeTint)], for: .selected)
        control.addTarget(context.coordinator, action: #selector(Coordinator.tabSelected(_:)), for: .valueChanged)
        return control
    }

    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        UIView.performWithoutAnimation {
            uiView.selectedSegmentIndex = Array(Tab.allCases).firstIndex(of: activeTab) ?? 0
            uiView.layoutIfNeeded()
        }
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
        return size
    }

    class Coordinator: NSObject {
        var parent: CustomTabBar

        init(parent: CustomTabBar) {
            self.parent = parent
        }

        @objc func tabSelected(_ control: UISegmentedControl) {
            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                parent.activeTab = Array(Tab.allCases)[control.selectedSegmentIndex]
            }
        }
    }
}

#Preview {
    HomeView()
}
