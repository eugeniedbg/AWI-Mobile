import Foundation

struct ActiviteState {
    let activites: [Activite] // Liste des activités
    let postes: [Poste] // Liste des postes
    let isLoading: Bool // Indicateur de chargement
    let hasActivities: Bool // Indicateur d'activités existantes
    let selectedPoste: String // Poste sélectionné
    let userId: String // Identifiant de l'utilisateur connecté
    let error: Error? // Erreur éventuelle
}
