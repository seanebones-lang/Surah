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
                // Background gradient - adapts to dark mode
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor.systemGroupedBackground),
                        Color(UIColor.secondarySystemGroupedBackground)
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
                                .font(.largeTitle.bold())
                                .foregroundStyle(Color(hex: "#2E7D32"))
                                .dynamicTypeSize(.large)
                            
                            Text("8 Sacred Duas & Surahs")
                                .font(.subheadline)
                                .foregroundStyle(Color(hex: "#558B2F"))
                                .dynamicTypeSize(.large)
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
                                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.4)) {
                                    expandedItemID = expandedItemID == item.id ? nil : item.id
                                }
                                
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                            }
                            .accessibilityLabel(item.title)
                            .accessibilityHint(expandedItemID == item.id ? "Double tap to collapse" : "Double tap to expand and view full content")
                            .accessibilityAddTraits(.isButton)
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
