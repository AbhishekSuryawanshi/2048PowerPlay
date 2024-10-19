//
//  HeaderView.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 17/10/24.
//

import SwiftUI

// Modifier for the primary text style
struct PrimaryTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .bold()
            .foregroundColor(.white)
            .padding()
            .frame(width: 120, height: 120)
            .background(Color.yellow)
            .cornerRadius(8)
            .minimumScaleFactor(0.5)
            .lineLimit(3)
            .multilineTextAlignment(.center)
    }
}

struct HeaderView: View {
    
    @Binding var currentScore: Int
    @Binding var bestScore: Int
    
    var body: some View {
        // Header with 2048, score, and best score
        HStack {
            Text("2048 Power play")
                .modifier(PrimaryTextStyle())
            
            Spacer(minLength: 8)
            
            ScoreView(title: "SCORE", score: currentScore)
            
            Spacer(minLength: 8)
            
            ScoreView(title: "BEST", score: bestScore)
        }
        .padding(.horizontal)
    }
}

// Reusable view for score display
struct ScoreView: View {
    let title: String
    let score: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.white)
            Text("\(score)")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
        }
        .frame(width: 80, height: 70)
        .padding()
        .background(Color(red: 0.68, green: 0.62, blue: 0.56))
        .cornerRadius(8)
    }
}

#Preview {
    HeaderView(currentScore: .constant(0), bestScore: .constant(0))
}
