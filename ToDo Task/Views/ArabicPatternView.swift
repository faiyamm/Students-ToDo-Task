//
//  ArabicPatternView.swift
//  ToDo Task
//
//  Created by fai on 04/27/26.
//

import SwiftUI

// A subtle geometric pattern inspired by Islamic art, used as a
// decorative overlay when the Arabic locale is selected.

struct ArabicPatternView: View {
    let color: Color
    let opacity: Double

    init(color: Color = TaskGroupColor.teal.vivid, opacity: Double = 0.06) {
        self.color = color
        self.opacity = opacity
    }

    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 32
            let radius: CGFloat = 10

            for row in stride(from: 0, through: size.height, by: spacing) {
                for col in stride(from: 0, through: size.width, by: spacing) {
                    let center = CGPoint(x: col, y: row)
                    drawStar(in: &context, at: center, radius: radius)
                }
            }
        }
        .foregroundStyle(color.opacity(opacity))
        .allowsHitTesting(false)
    }

    private func drawStar(in context: inout GraphicsContext, at center: CGPoint, radius: CGFloat) {
        let points = 8
        var path = Path()
        for i in 0..<points {
            let angle = (Double(i) / Double(points)) * 2 * .pi - .pi / 2
            let r = i % 2 == 0 ? radius : radius * 0.4
            let x = center.x + CGFloat(cos(angle)) * r
            let y = center.y + CGFloat(sin(angle)) * r
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        context.fill(path, with: .foreground)
    }
}
