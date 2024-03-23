//
//  PlanningState.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import Foundation

class PlanningState: ObservableObject{
    @Published var festival: Festival? = nil
    @Published var poste: [Poste] = []
    @Published var employers: [Employer] = []
    @Published var inscription: [Inscription] = []
    @Published var creneau: [String] = ["09-11", "11-14", "14-17", "17-20", "20-22"]
}
