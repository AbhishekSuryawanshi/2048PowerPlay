
//
//  ButtonViews.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 16/10/24.
//

import SwiftUI

// Reusable button style modifier
struct ButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .bold()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

// Reusable HStackButtonView with customizable titles and actions
struct HStackButtonView: View {
    let titles: [String]
    let actions: [() -> Void]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(titles.enumerated()), id: \.element) { index, title in
                Button(title) {
                    actions[index]()
                }
                .modifier(ButtonStyleModifier())
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    HStackButtonView(
//        titles: ["MENU", "LEADERBOARD"],
//        actions: [
//            { print("Menu clicked") },
//            { print("Leaderboard clicked") }
//        ]
//    )
//}


