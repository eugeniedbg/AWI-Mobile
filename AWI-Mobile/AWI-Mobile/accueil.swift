//
//  accueil.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 19/03/2024.
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case home
    case inscription
    case profil

    var title: String {
        switch self {
        case .home: return "Accueil"
        case .inscription: return "Inscription"
        case .profil: return "Profil"
        }
    }

    var image: String {
        switch self {
        case .home: return "house"
        case .inscription: return "pencil"
        case .profil: return "person"
        }
    }
}

struct AccueilView: View {
    @State private var selectedTab = Tab.home
    @State  var currentFestival : Int

        var body: some View {
            TabView(selection: $selectedTab) {
                FestivalView()
                    .tag(Tab.home)
                    .tabItem {
                        Image(systemName: Tab.home.image)
                        Text(Tab.home.title)
                    }
                PlanningView(viewModel: PlanningViewModel())
                    .tag(Tab.inscription)
                    .tabItem {
                        Image(systemName: Tab.inscription.image)
                        Text(Tab.inscription.title)
                    }

                InscriptionView()
                    .tag(Tab.profil)
                    .tabItem {
                        Image(systemName: Tab.profil.image)
                        Text(Tab.profil.title)
                    }
            }
        }
    }


#Preview {
    AccueilView( currentFestival:1)
}


    


