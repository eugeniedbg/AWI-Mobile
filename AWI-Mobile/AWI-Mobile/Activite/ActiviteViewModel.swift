import Foundation
import Combine

class ActiviteViewModel: ObservableObject {
    @Published private(set) var state = ActiviteState(activites: [], postes: [], isLoading: false, hasActivities: false, selectedPoste: "", userId: "", error: nil)
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPostes(idFestival: String) {
        guard let url = URL(string: "https://awi-api-2.onrender.com/employer-module/festival/\(idFestival)") else {
            self.state.error = "Invalid URL for fetching postes"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Poste].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.state.error = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { postes in
                self.state.postes = postes
            })
            .store(in: &cancellables)
    }

func fetchActivites(userId: String) {
    guard let url = URL(string: "https://awi-api-2.onrender.com/inscription-module/volunteer/\(userId)") else {
        self.state.error = "Invalid URL for fetching activites"
        return
    }

    URLSession.shared.dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: [Inscription].self, decoder: JSONDecoder())
        .flatMap { inscriptions in
            Publishers.Sequence(sequence: inscriptions)
        }
        .flatMap { inscription in
            URLSession.shared.dataTaskPublisher(for: URL(string: "https://awi-api-2.onrender.com/employer-module/position/\(inscription.idPoste)")!)
                .map { $0.data }
                .decode(type: [Employer].self, decoder: JSONDecoder())
                .map { ($0, inscription) }
        }
        .compactMap { (employers, inscription) -> AnyPublisher<(Employer, Inscription), Error>? in
            guard let employer = employers.first(where: { $0.idFestival == idFestival }), employer.idFestival == idFestival else {
                return nil
            }
            return URLSession.shared.dataTaskPublisher(for: URL(string: "https://awi-api-2.onrender.com/position-module/\(inscription.idPoste)")!)
                .map { $0.data }
                .decode(type: Poste.self, decoder: JSONDecoder())
                .map { poste in
                    (poste, inscription)
                }
                .eraseToAnyPublisher()
        }
        .collect()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                self.state.error = error.localizedDescription
            case .finished:
                break
            }
        }, receiveValue: { activites in
            self.state.activites = activites
            self.state.hasActivities = !activites.isEmpty
        })
        .store(in: &cancellables)
}

    
    func handlePosteChange(_ poste: String) {
        // Implémentez la logique pour gérer le changement de poste sélectionné
    }
    
    func handleUnsubscribe(inscriptionId: String, idZoneBenevole: String, creneau: String, jour: String) {
        // Implémentez la logique pour gérer la désinscription à une activité
    }
}
