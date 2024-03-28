import Foundation

enum ActiviteIntent {
    case fetchActivites
    case fetchPostes
    case handlePosteChange(String)
    case handleUnsubscribe(inscriptionId: String, idZoneBenevole: String, creneau: String, jour: String)
}
