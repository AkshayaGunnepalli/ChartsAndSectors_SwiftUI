//
//  DonutChartView.swift
//  Charts_SwiftUI
//
//  Created by Akshaya Gunnepalli on 06/04/25.
//

import SwiftUI
import Charts

struct DonutChartView: View {
    @State private var products: [Product] = [
        .init(title: "Apples", ratio: 0.7, productType: .apple),
        .init(title: "Grapes", ratio: 0.2, productType: .grapes),
        .init(title: "Watermelon", ratio: 0.1, productType: .watermelon)
    ]

    @State private var selectedProductTitle: String? = nil
    @State private var innerRadius: CGFloat = 0.5
    @State private var apples: Int = 7
    @State private var grapes: Int = 2
    @State private var watermelon: Int = 1

    var body: some View {
        VStack(spacing: 20) {
            // Donut Chart
            Chart(products) { product in
                SectorMark(
                    angle: .value(product.title, product.ratio),
                    innerRadius: .ratio(innerRadius),
                    angularInset: 1
                )
                .foregroundStyle(by: .value("Product", product.title))
            }
            .frame(height: 200)

            // Slider for inner radius
            HStack {
                Text("Inner Radius: \(String(format: "%.2f", innerRadius))")
                    .font(.caption)
                Slider(value: $innerRadius, in: 0...1)
            }
            .padding(.vertical, 20)
            .frame(height: 50)

            // Input for values
            HStack {
                InputValue(title: "Apples", value: $apples) { _ in
                    calculateRatios()
                }
                InputValue(title: "Grapes", value: $grapes) { _ in
                    calculateRatios()
                }
                InputValue(title: "Watermelon", value: $watermelon) { _ in
                    calculateRatios()
                }
            }
        }
        .padding()
    }

    func calculateRatios() {
        let total = Double(apples + grapes + watermelon)
        guard total > 0 else { return }

        let updatedProducts = products.map { product -> Product in
            var ratio = 0.0
            switch product.productType {
            case .apple:
                ratio = Double(apples) / total
            case .grapes:
                ratio = Double(grapes) / total
            case .watermelon:
                ratio = Double(watermelon) / total
            }
            return Product(title: product.title, ratio: ratio, productType: product.productType)
        }

        withAnimation(.smooth) {
            products = updatedProducts
        }
    }
}


// MARK: - Input Component

struct InputValue: View {
    var title: String
    @Binding var value: Int
    var onChange: (_ newValue: Int) -> Void

    var body: some View {
        VStack(alignment: .center) {
            Text("\(title): \(value)")
                .font(.system(size: 12))
            Stepper(value: $value, in: 0...100) {
                EmptyView()
            }
        }
        .onChange(of: value) { newValue in
            onChange(newValue)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Supporting Models

struct Product: Identifiable {
    var id = UUID()
    var title: String
    var ratio: Double
    var productType: ProductType
}

enum ProductType: Equatable {
    case apple
    case grapes
    case watermelon
}


// MARK: - Preview

#Preview {
    DonutChartView()
}
