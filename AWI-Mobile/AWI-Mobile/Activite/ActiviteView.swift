import SwiftUI

struct ActiviteView: View {
    @ObservedObject var viewModel: ActiviteViewModel
    
    private let legendItems: [LegendItem] = [
        LegendItem(name: "Accueil", color: Color(red: 0.235, green: 0.796, blue: 0.957)),
        LegendItem(name: "Buvette", color: Color(red: 0.067, green: 0.498, blue: 0.271)),
        LegendItem(name: "Animation Jeux", color: Color(red: 0.063, green: 0.361, blue: 0.624)),
        LegendItem(name: "Cuisine", color: Color(red: 0.2, green: 0.769, blue: 0.506))
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Mes Activités")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                
                ForEach(viewModel.state.activites, id: \.self) { activite in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(activite.poste.nomPoste)
                            .font(.headline)
                            .padding()
                            .background(legendColor(for: activite.poste.nomPoste))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Text("Zone: \(activite.zone != nil ? activite.zone!.nomZoneBenevole : "Zone non disponible")")
                            .padding(.horizontal)
                        
                        Text("Créneau: \(activite.inscription.Creneau != nil ? activite.inscription.Creneau : "Créneau non disponible")")
                            .padding(.horizontal)
                        
                        Text("Description: \(activite.poste.description)")
                            .padding(.horizontal)
                        
                        Text("Référents: \(activite.referents.map { $0.prenomReferent }.joined(separator: ", "))")
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private func legendColor(for poste: String) -> Color {
        if let legendItem = legendItems.first(where: { $0.name == poste }) {
            return legendItem.color
        } else {
            return Color.gray
        }
    }
}

struct LegendItem {
    let name: String
    let color: Color
}

struct ActiviteView_Previews: PreviewProvider {
    static var previews: some View {
        let activites = [Activite(poste: Poste(nomPoste: "Accueil", description: "Description de l'accueil"), zone: Zone(nomZoneBenevole: "Zone 1"), inscription: Inscription(Creneau: "Matin"), referents: [])]
        let viewModel = ActiviteViewModel()
        viewModel.state.activites = activites
        return ActiviteView(viewModel: viewModel)
    }
}

