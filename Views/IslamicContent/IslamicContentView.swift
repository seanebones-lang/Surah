//
//  IslamicContentView.swift
//  Seemi's Spiritual Companion
//
//  Islamic content library with 8 items
//

import SwiftUI

struct IslamicContentView: View {
    @State private var islamicItems: [IslamicContentItem] = IslamicContentItem.allItems
    @State private var expandedItemID: UUID? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#F1F8E9"),
                        Color(hex: "#DCEDC8")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Seemi's Spiritual Collection")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundStyle(Color(hex: "#2E7D32"))
                            
                            Text("8 Sacred Duas & Surahs")
                                .font(.system(size: 16, weight: .light))
                                .foregroundStyle(Color(hex: "#558B2F"))
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        // 8 Cards
                        ForEach(islamicItems) { item in
                            DuaCardView(
                                item: item,
                                isExpanded: expandedItemID == item.id
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    expandedItemID = expandedItemID == item.id ? nil : item.id
                                }
                                
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    IslamicContentView()
        .environment(AppState())
}
