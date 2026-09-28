//  Spot3DPin.swift
//  Map marker for Spot3D pins. When selected it grows and shows a live 3D mini-preview bubble above.

import SwiftUI

struct Spot3DPin: View {
    let spot: Spot3D
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            if isSelected {
                Image(uiImage: SpotSceneFactory.snapshot(for: spot, size: CGSize(width: 240, height: 160)))
                    .resizable().scaledToFill()
                    .frame(width: 150, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white, lineWidth: 3))
                    .shadow(radius: 6, y: 3)
                    .transition(.scale(scale: 0.3, anchor: .bottom).combined(with: .opacity))
            }
            ZStack {
                Circle().fill(spot.category.tint)
                    .frame(width: isSelected ? 44 : 32, height: isSelected ? 44 : 32)
                    .overlay(Circle().stroke(.white, lineWidth: 2.5))
                    .shadow(color: .black.opacity(0.3), radius: 3, y: 2)
                Image(systemName: spot.category.symbol)
                    .font(.system(size: isSelected ? 20 : 15, weight: .bold))
                    .foregroundStyle(.white)
            }
            .opacity(spot.isGhost ? 0.55 : 1)
            Spot3DPinTriangle().fill(spot.category.tint).frame(width: 12, height: 7).offset(y: -5)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
}

private struct Spot3DPinTriangle: Shape {
    func path(in r: CGRect) -> Path {
        Path { p in
            p.move(to: .init(x: r.minX, y: r.minY))
            p.addLine(to: .init(x: r.maxX, y: r.minY))
            p.addLine(to: .init(x: r.midX, y: r.maxY))
            p.closeSubpath()
        }
    }
}
