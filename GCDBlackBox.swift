//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Michael Doroff on 2/26/17.
//
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

