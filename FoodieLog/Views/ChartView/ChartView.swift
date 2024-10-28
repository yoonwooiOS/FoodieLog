//
//  ChartView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/27/24.
//

import SwiftUI
import Charts

struct SalesData: Identifiable {
    let id = UUID()
    let month: String
    let sales: Double
}

struct ChartView: View {
    let data = [
            SalesData(month: "1월", sales: 200),
            SalesData(month: "2월", sales: 350),
            SalesData(month: "3월", sales: 280),
            SalesData(month: "4월", sales: 450),
            SalesData(month: "5월", sales: 380),
            SalesData(month: "6월", sales: 520)
        ]
        
        var body: some View {
            VStack {
                Text("월별 매출")
                    .font(.title)
                    .padding()
                
                Chart(data) { item in
                    LineMark(
                        x: .value("Month", item.month),
                        y: .value("Sales", item.sales)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Month", item.month),
                        y: .value("Sales", item.sales)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 300)
                .padding()
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
            }
            .padding()
        }
    }

#Preview {
    ChartView()
}
