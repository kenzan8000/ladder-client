//
//  PinRowViewModel.swift
//  ladder-client
//
//  Created by Kenzan Hase on 6/6/24.
//  Copyright © 2024 kenzan8000. All rights reserved.
//

import Foundation

// MARK: - PinRowViewModel

@Observable
final class PinRowViewModel {
    // MARK: - Private properties
    
    private let pin: Pin
    
    // MARK: - Public properties
    
    var title: String { pin.title }
    
    // MARK: - Init
    
    init(pin: Pin) {
        self.pin = pin
    }
}
