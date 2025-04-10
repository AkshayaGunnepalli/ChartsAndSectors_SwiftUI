//
//  BarGraph.swift
//  Charts_SwiftUI
//
//  Created by Akshaya Gunnepalli on 07/04/25.
//

import SwiftUI
import Charts

// MARK: - Main View
struct BarGraph: View {
    
    // MARK: - State Variables
    @State private var stackedBarData: [GraphModel] = []
    @State private var singleValueBarData: [GraphModel] = []
    @State private var selectedType: BarGraphType = .barMark
    @State private var barMarkStyle: BarMarkStyle = .singleValue

    // MARK: - Computed Properties
    private var uniqueStageValues: [GraphModel] {
        var seen = Set<String>()
        return stackedBarData.filter { item in
            guard !seen.contains(item.stage) else { return false }
            seen.insert(item.stage)
            return true
        }
    }
    
    private var uniqueTypes: [GraphModel] {
        var seen = Set<String>()
        return stackedBarData.filter { item in
            guard !seen.contains(item.type) else { return false }
            seen.insert(item.type)
            return true
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            renderChart()
                .frame(height: 250)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: selectedType)
            
            if selectedType == .barMark {
                renderLegend()
                    .padding(.top, 20)
            }

            renderGraphTypeSelector()
                .padding(.top, 20)

            if selectedType == .barMark || selectedType == .areaMark {
                renderBarStyleSelector()
                    .padding(.top, 20)
            }
        }
        .padding()
        .onAppear(perform: loadData)
    }
}

// MARK: - Subviews
extension BarGraph {
    private func renderChart() -> some View {
        Chart {
            if barMarkStyle == .multiple && (selectedType == .barMark || selectedType == .areaMark)  {
                ForEach(stackedBarData) { data in
                    if selectedType == .barMark {
                        BarMark(
                            x: .value("x axis title", data.type) ,
                            y: .value("y axis title",  data.count),
                            width: 40
                        )
                        .foregroundStyle(data.color)
                        .opacity(1)
                        .cornerRadius(10)
                    } else if selectedType == .areaMark {
                        AreaMark(
                            x: .value("x axis title", data.type),
                            y: .value("y axis title", data.count)
                        )
                        .foregroundStyle(by: .value("", data.stage))
                        .interpolationMethod(.catmullRom)
                    }
                }
            } else {
                ForEach(singleValueBarData) { data in
                    if selectedType == .barMark {
                        BarMark(
                            x: .value("x axis title", data.type) ,
                            y: .value("y axis title",  data.count),
                            width: 40
                        )
                        .foregroundStyle(data.color)
                        .opacity(1)
                        .cornerRadius(10)
                        .interpolationMethod(.catmullRom)
                    } else if selectedType == .lineMark {
                        LineMark(
                            x: .value("x axis title", data.type) ,
                            y: .value("y axis title",  data.count)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.blue)
                    } else if selectedType == .areaMark {
                        AreaMark(
                            x: .value("x axis title", data.type),
                            y: .value("y axis title", data.count)
                        )
                        .foregroundStyle(.green.opacity(0.7))
                        .interpolationMethod(.catmullRom)
                    } else if selectedType == .pointMark {
                        PointMark(
                            x: .value("x axis title", data.type),
                            y: .value("y axis title", data.count)
                        )
                        .foregroundStyle(.red)
                        .symbolSize(100)
                        .interpolationMethod(.catmullRom)
                        
                    }  else if selectedType == .rectagularMark {
                        RectangleMark(
                            xStart: .value("x axis title", data.count - 0.25),
                            xEnd: .value("x axis title", data.count + 0.25),
                            yStart: .value("y axis title",  data.count - 0.25),
                            yEnd: .value("y axis title",  data.count + 0.25)
                        )
                        .opacity(0.5)
                        .interpolationMethod(.catmullRom)
                        
                    }
                }
                
            }
        }
        .frame(height: 250)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: selectedType)
        }

    private func renderLegend() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(uniqueStageValues) { data in
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(data.color)
                            .frame(width: 15, height: 8)
                        Text(data.stage)
                            .font(.system(size: 9, weight: .semibold))
                    }
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
                }
            }
        }
    }

    private func renderGraphTypeSelector() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(BarGraphType.allCases) { type in
                    Text(type.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(selectedType == type ? .blue.opacity(0.5) : .blue.opacity(0.2))
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedType = type
                            }
                        }
                }
            }
        }
    }

    private func renderBarStyleSelector() -> some View {
        HStack {
            ForEach(BarMarkStyle.allCases) { style in
                Text(style.rawValue)
                    .font(.system(size: 12, weight: .semibold))
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(barMarkStyle == style ? .green.opacity(0.5) : .green.opacity(0.2))
                    )
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.5)) {
                            barMarkStyle = style
                        }
                    }
            }
        }
    }

    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.6)) {
                stackedBarData = [
                    .init(color: .red, type: "Cube", count: 3, stage: "Failed"),
                    .init(color: .red, type: "Sphere", count: 4, stage: "Failed"),
                    .init(color: .red, type: "Pyramid", count: 2, stage: "Failed"),
                    
                    .init(color: .blue, type: "Cube", count: 5, stage: "In Progress"),
                    .init(color: .blue, type: "Sphere", count: 3, stage: "In Progress"),
                    .init(color: .blue, type: "Pyramid", count: 2, stage: "In Progress"),
                    
                    .init(color: .green, type: "Cube", count: 2, stage: "Completed"),
                    .init(color: .green, type: "Sphere", count: 5, stage: "Completed"),
                    .init(color: .green, type: "Pyramid", count: 4, stage: "Completed"),
                    
                    .init(color: .gray, type: "Cube", count: 1, stage: "Reset"),
                    .init(color: .gray, type: "Sphere", count: 1, stage: "Reset"),
                    .init(color: .gray, type: "Pyramid", count: 1, stage: "Reset")
                ]
                
                singleValueBarData = [
                    .init(color: .red, type: "Failed", count: 6, stage: ""),
                    .init(color: .green, type: "Completed", count: 2, stage: ""),
                    .init(color: .blue, type: "Inprogress", count: 9, stage: ""),
                    .init(color: .gray, type: "Reset", count: 3, stage: "")
                ]
            }
        }
    }
}

// MARK: - Preview
#Preview {
    BarGraph()
}

// MARK: - Supporting Models
struct GraphModel: Identifiable, Hashable {
    let id = UUID()
    var color: Color
    var type: String
    var count: Double
    var stage: String
    
    static func == (lhs: GraphModel, rhs: GraphModel) -> Bool {
        lhs.id == rhs.id
    }
}

enum BarGraphType: String, CaseIterable, Identifiable {
    case barMark = "Bar Mark"
    case lineMark = "Line Mark"
    case areaMark = "Area Mark"
    case pointMark = "Point Mark"
    case rectagularMark = "Rectangular Mark"

    var id: String { self.rawValue }
}

enum BarMarkStyle: String, CaseIterable, Identifiable {
    case singleValue = "Single Value"
    case multiple = "Multiple Value"

    var id: UUID { UUID() } // Different every time to support repeated style changes
}
