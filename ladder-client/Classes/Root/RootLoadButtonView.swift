//
//  RootLoadButtonView.swift
//  ladder-client
//
//  Created by Kenzan Hase on 5/30/24.
//  Copyright © 2024 kenzan8000. All rights reserved.
//

import SwiftUI

// MARK: - RootLoadButtonView

struct RootLoadButtonView: View {
    // MARK: - Private properties
    
    @EnvironmentObject private var viewModel: RootLoadButtonViewModel

    @State private var isLoading = false
    
    /// Action when presenting sign in view
    private let action: () -> Void
    
    // MARK: - Public properties

    var body: some View {
        if isLoading {
            HStack {
                Text("Loading")
                    .foregroundStyle(.secondary)
                Spacer().frame(width: Spacing.small)
                ProgressView()
            }
        } else {
            Button(action: action) {
                Text("Reload")
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    // MARK: - Init
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
}
