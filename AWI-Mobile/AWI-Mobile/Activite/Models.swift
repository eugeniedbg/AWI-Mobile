// Mock data structures
struct Activite: Hashable {
    let poste: Poste
    let zone: Zone?
    let inscription: Inscription
    let referents: [Referent]
}

struct Poste: Hashable {
    let nomPoste: String
    let description: String
}

struct Zone: Hashable {
    let nomZoneBenevole: String
}

struct Inscription: Hashable {
    let Creneau: String
}

struct Referent: Hashable {
    l