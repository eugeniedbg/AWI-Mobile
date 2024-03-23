//
//  PlanningView.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import SwiftUI

struct PlanningView: View {
    let planning = PlanningViewModel()
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .onAppear {
            planning.getPlanning()
        }
    }
}

struct PlanningView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningView()
    }
}

