//
//  SwiftBetaCanvas.swift
//  SwiftBetaPaint
//
//  Created by Home on 22/6/23.
//

import Foundation
import SwiftUI
import Observation

public struct SwiftBetaCanvas: View {
    @ObservedObject var canvasConfiguration: CanvasConfiguration
    
    @State var points: [Point] = []
    @State var currentLine: Int = 0
    
    public init(canvasConfiguration: CanvasConfiguration) {
        self.canvasConfiguration = canvasConfiguration
    }
    
    public var body: some View {
        Canvas { context, _ in
            createNewPath(context: context, lines: canvasConfiguration.lines)
        }
        .gesture(
            DragGesture()
                .onChanged({ value in
                    let point = value.location
                    let lastPoint = points.isEmpty ? point : points.last!.currentPoint
                    let currentLinePoints = Point(currentPoint: point, lastPoint: lastPoint)
                    points.append(currentLinePoints)
                    
                    if canvasConfiguration.lines.isEmpty {
                        let line = Line(points: [currentLinePoints],
                                        color: canvasConfiguration.currentLineColor,
                                        width: canvasConfiguration.currentLineWidth)
                        canvasConfiguration.lines.append(line)
                    } else {
                        var line: Line?
                        
                        if currentLine >= canvasConfiguration.lines.count {
                            line = Line(points: [currentLinePoints],
                                        color: canvasConfiguration.currentLineColor,
                                        width: canvasConfiguration.currentLineWidth)
                            canvasConfiguration.lines.append(line!)
                        } else {
                            line = canvasConfiguration.lines[currentLine]
                            line?.points = points
                            line?.color = canvasConfiguration.currentLineColor
                        }
                        
                        if currentLine < canvasConfiguration.lines.count {
                            canvasConfiguration.lines[currentLine] = line!
                        }
                    }
                })
                .onEnded({ value in
                    currentLine += 1
                    points.removeAll()
                })
        )
        .background(Color.clear)
    }
    
    private func createNewPath(context: GraphicsContext,
                               lines: [Line]) {
        
        guard !lines.isEmpty else { return }
        
        for line in lines {
            var newPath = Path()
            for point in line.points {
                newPath.move(to: point.lastPoint)
                newPath.addLine(to: point.currentPoint)
            }
            context.stroke(newPath,
                           with: .color(line.color),
                           style: .init(lineWidth: CGFloat(line.width),
                                        lineCap: .round,
                                        lineJoin: .round)
            )
        }
    }
}
