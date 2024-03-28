import SwiftUI

struct PlanningView: View {
    
    @ObservedObject var viewModel: PlanningViewModel
    var jours: [String] {
            guard let startDate = viewModel.state.festival?.dateDebut,
                  let endDate = viewModel.state.festival?.dateFin
        else {
                return []
            }
            return joursEntreDeuxDates(startDate: startDate, endDate: endDate)
        }
    let creneaux: [String] = ["09-11", "11-14", "14-17", "17-20", "20-22"] // Liste des créneaux
    //let inscriptions: [Inscription] = viewModel.state.inscription
    
    
    var body: some View {
        VStack{
            if let festival = viewModel.festival{
                Text("Planning du festival \(viewModel.festival?.nomFestival ?? "probleme")")
                    .font(.title)
                .padding(.top, -115)
                listCreneau()
            }
            else{
                Text("Chargement en cours ...")
            }
        }
        .onAppear{
            self.viewModel.send(intent: .getFestivalData)
        }
    }
    
    private func joursEntreDeuxDates(startDate: Date, endDate: Date) -> [String] {
    var days: [String] = []
    var currentDate = startDate
        let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM"
    
    while currentDate <= endDate {
        days.append(dateFormatter.string(from: currentDate))
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
        return days
    }
    
    
    private func crenau(horaire: String, couleur: Color) -> some View {
        ZStack {
            Rectangle()
                .fill(couleur)
                .cornerRadius(10)
            Text(horaire)
                .font(.body)
                .foregroundColor(.black)
        }
        .frame(height: 50)
    }
    struct LegendItem {
        let name: String
        let color: Color
    }
    
    let legend:
    [LegendItem] = [
                LegendItem(name: "Accueil", color: Color(red: 0.235, green: 0.796, blue: 0.957)),
                LegendItem(name: "Buvette", color: Color(red: 0.067, green: 0.498, blue: 0.271)),
                LegendItem(name: "Animation Jeux", color: Color(red: 0.063, green: 0.361, blue: 0.624)),
                LegendItem(name: "Cuisine", color: Color(red: 0.2, green: 0.769, blue: 0.506)),
                LegendItem(name: "Flexible", color: Color(red: 0.9921568627450981, green: 0.30980392156862746, blue: 0.30980392156862746))
                ]
    

    private func listCreneau() -> some View {
        let result = matchCreneauColor()
        var days = Array(Set(result.map { $0.0 })) // récupère les jours uniques
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        days = days.sorted {
            dateFormatter.date(from: $0)! < dateFormatter.date(from: $1)!
        }
        print("days\(days)")
        
            //if let poste = postes.first(where: { $0.id == inscription.idPoste }) {
        
        
        
        let creneaux = ["09-11", "11-14", "14-17", "17-20", "20-22"]
        
        return
        VStack{
            LazyHGrid(rows: [GridItem(.adaptive(minimum: 100))], spacing: 5) {
                HStack(alignment: .center, spacing: 5) {
                    ForEach(days, id: \.self) { day in
                        VStack(alignment: .center, spacing: 5){
                            Text(day)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(10)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                                .frame(width: 400)
                            ForEach(creneaux, id: \.self) { creneau in
                                let timeSlot = "\(creneau)h"
                                if let postName = result.first(where: { $0.0 == day && $0.1 == timeSlot })?.2 {
                                    let legendItem = legend.first(where: { $0.name == postName })
                                    crenau(horaire: timeSlot, couleur: legendItem?.color ?? .gray)
                                } else {
                                    crenau(horaire: timeSlot, couleur: .white)
                                }
                            }
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width / CGFloat(days.count)-20)
                        
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 20)
            
                HStack(alignment: .center){
                    ForEach(legend, id: \.name) { item in
                        ZStack {
                            Rectangle()
                                .fill(item.color)
                            Text(item.name)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width/5 - 10 , height: 90)
                        .cornerRadius(10)
                    }
            }
        }
    }
    
    private func matchCreneauColor() -> [(String, String, String)] {
        let inscriptions : [Inscription] = viewModel.state.inscription
        print(inscriptions)
        let postes : [Poste] = viewModel.state.poste
        
        
        let days2 = joursEntreDeuxDates(startDate: viewModel.state.festival!.dateDebut, endDate: viewModel.state.festival!.dateFin)

        var result: [(String, String, String)] = []

        for inscription in inscriptions {
            if let poste = postes.first(where: { $0.id == inscription.idPoste }) {
                let dateFormatter = DateFormatter()
                var formattedDate = inscription.Jour
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")

                if let date = dateFormatter.date(from: inscription.Jour) {
                    dateFormatter.dateFormat = "dd MMM"
                    formattedDate = dateFormatter.string(from: date)
                }
                let day = "\(formattedDate)"
                let timeSlot = "\(inscription.Creneau)h"
                let postName = poste.nomPoste
                result.append((day, timeSlot, postName))
            }
        }
        
        
        for day in days2 {
            if !result.contains(where: { $0.0 == day }) {
                let timeSlot = ""
                let postName = ""
                result.append((day, timeSlot, postName))
            }
        }
        print("List des inscription : \(result)")
        
        return result
    }
}

#Preview{
    PlanningView(viewModel:PlanningViewModel())
}
    
