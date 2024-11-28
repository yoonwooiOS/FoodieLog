//
//  ChartView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/27/24.
//

import SwiftUI
import Charts

import SwiftUI
import Charts

struct ChartView: View {
    @StateObject private var viewModel = ChartViewModel()
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            ColorSet.primary.color.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // 상단 제목
                    HStack {
                        Text("푸디 리포트")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    monthSelectorView()
                    chartView()
                    reviewListView()
                    
                    Spacer()
                }
            }
        }
        .task {
            viewModel.action(.onAppear)
        }
    }
}

extension ChartView {
    func monthSelectorView() -> some View {
        HStack {
            Text("\(viewModel.output.formattedYear)년 \(viewModel.output.selectedMonth)월 최애 음식은 ")
                .foregroundColor(.black) +
            Text(viewModel.output.resultCategory)
                .foregroundColor(ColorSet.accent.color)
                .foregroundColor(.black) +// 강조 색상 설정
            Text(" !")
                .foregroundColor(.black)
            Spacer()
        }
        .font(.system(size: 20, weight: .bold))
        .padding()
        
    }
    func chartView() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white)
            .overlay {
                if viewModel.output.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if viewModel.output.filteredCategoryData.isEmpty {
                    VStack {
                        Spacer()
                        Text("등록한 리뷰가 없습니다.")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    if #available(iOS 17.0, *) {
                        piechart()
                    } else {
                        barChartView()
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: height * 0.4)
    }
    
    // 개별 월에 해당하는 차트
    func barChartView() -> some View {
        Chart(viewModel.output.filteredCategoryData) { data in
            BarMark(
                x: .value("횟수", data.count),
                y: .value("카테고리", data.category)
            )
            .annotation(position: .trailing) {
                Text("\(data.count)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .foregroundStyle(
                data.count == viewModel.output.filteredCategoryData.max(by: { $0.count < $1.count })?.count ?
                ColorSet.accent.color : ColorSet.accent.color.opacity(0.2)
            )
        }
        .chartXAxis {
            AxisMarks { _ in }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
            }
        }
        .padding(.horizontal, 12)
        .frame(width: width * 0.9, height: height * 0.3)
        
        
        .padding(.horizontal, 8)
    }
    
    
    @available(iOS 17.0, *)
    func piechart() -> some View {
        // 고정된 색상 배열
        let colors: [Color] = [
            Color(hex: "#FF8F11").opacity(1.0), // 가장 높은 횟수
            Color(hex: "#F58F02").opacity(0.7),
            Color(hex: "#FD990D").opacity(0.6),
            Color(hex: "#FDB321").opacity(0.5),
            Color.gray.opacity(0.4) // 기본 색상
        ]
        
        // 카테고리별 색상 매핑
        var categoryColorMap: [String: Color] = [:]
        let sortedCategories = viewModel.output.filteredCategoryData.sorted { $0.count > $1.count }
        for (index, categoryData) in sortedCategories.enumerated() {
            let color = index < colors.count ? colors[index] : colors.last ?? Color.gray.opacity(0.4)
            categoryColorMap[categoryData.category] = color
        }
        
        return Chart(viewModel.output.filteredCategoryData) { data in
            let color = categoryColorMap[data.category] ?? Color.gray.opacity(0.4) // 기본 색상 처리
            
            SectorMark(
                angle: .value("횟수", data.count),
                innerRadius: .ratio(0.5),
                outerRadius: .ratio(1.0), // 일반적인 파이 차트 비율
                angularInset: 3
            )
            .foregroundStyle(color) // 섹터 색상 지정
            .annotation(position: .overlay) {
                VStack(spacing: 2) {
                    Text("\(data.count)")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "423642"))
                }
            }
        }
        .chartLegend(position: .bottom) // 범례 위치 설정
        .chartLegend(spacing: 32)
        .chartForegroundStyleScale(
            domain: sortedCategories.map { $0.category },
            range: sortedCategories.map { categoryColorMap[$0.category]! } // 범례 색상 매핑
        )
        .padding(.leading, 12)
        .padding(.horizontal, 8)
        .frame(width: width * 0.9, height: height * 0.3)
    }
}
extension ChartView {
    func reviewListView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // 헤더 텍스트
            if let topCategory = viewModel.output.filteredCategoryData.first {
                Text("\(viewModel.output.selectedMonth)월 \(topCategory.category) 리뷰")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading, 16)
            }
            
            // 리뷰 카드 리스트
            if let topCategory = viewModel.output.filteredCategoryData.first {
                let reviews = viewModel.reviewsForCategory(
                    topCategory.category,
                    month: viewModel.output.selectedMonth,
                    year: viewModel.output.selectedYear
                )
                
                if reviews.isEmpty {
                    Text("해당 카테고리의 리뷰가 없습니다.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 16)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(reviews.map { ReviewData(from: $0) }, id: \.id) { review in
                                ReviewCardView(review: review)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            } else {
                Text("이번 달 리뷰 데이터가 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading, 16)
            }
        }
        .padding(.top)
    }
}
