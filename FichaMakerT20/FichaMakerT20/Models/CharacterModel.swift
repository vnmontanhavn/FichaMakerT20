//
//  CharacterModel.swift
//  FichaMakerT20
//
//  Created by Vinicius Soares Lima on 06/07/23.
//

import Foundation

struct CharacterModel {
    let name: String
    let age: String
    var maxLife: Int
    var life: Int
    var maxMana: Int
    var mana: Int
    var defence: Int
    let attributes: Attributes
    let origin: Origin
    let divinity: Divinity
    let race: Race
    let characterClass: [CharacterClass]
    let powers: [Power]
    var skills: Skills = Skills()
    var knowSkills: [SkillList]
    
    mutating func setupSkills() {
        for item in knowSkills {
            skills.skillList[item]?.train = true
        }
    }
}

struct Attributes {
    var forca: AttValue = AttValue(name: .forca, value: 0)
    var destreza: AttValue = AttValue(name: .desteza, value: 0)
    var constituicao: AttValue = AttValue(name: .constituicao, value: 0)
    var inteligencia: AttValue = AttValue(name: .inteligencia, value: 0)
    var sabedoria: AttValue = AttValue(name: .sabedoria, value: 0)
    var carisma: AttValue = AttValue(name: .carisma, value: 0)
    
    init(forca: Int, destreza: Int, constituicao: Int, inteligencia: Int, sabedoria: Int , carisma: Int) {
        self.forca.value = forca
        self.destreza.value = destreza
        self.constituicao.value = constituicao
        self.inteligencia.value = inteligencia
        self.sabedoria.value = sabedoria
        self.carisma.value = carisma
    }
}

struct CharacterClass {
    let characterClass: CharacterClassEnum
    var lvl: Int
}

struct AttValue {
    let name: AttList
    var value: Int
}


struct Power {
    let name: String
    let description: String
    let type: PowerType
    let subType: PowerSubType
    let effects:[Effect]
}

struct Effect {
    let name: String
    let value: Int
    let target: EffectTarget
    var skill: SkillList?
    let repet: RepetEffect
    let effect: EffectType
}
//TODO: tratar a percia de oficio para permitir que seja incluido variações
//TODO: Organizar código separando funções, Structs e Enums
func isOnlyTrain(skill: SkillList) -> Bool {
    switch skill {
    case .adestramento, .conhecimento, .guerra, .jogatina, .ladinagem, .misticismo, .nobreza, .oficio, .pilotagem, .religião:
        return true
    default:
        return false
    }
}
func isArmorPenal(skill: SkillList) -> Bool {
    switch skill {
    case .acrobacia, .furtividade, .ladinagem:
        return true
    default:
        return false
    }
}

struct Skills {
    var skillList: [SkillList: SkillValue]
    init() {
        var list: [SkillList: SkillValue] = [:]
        for item in SkillList.allCases {
            switch item {
            case .acrobacia, .cavalgar, .furtividade, .iniciativa, .ladinagem, .pilotagem, .pontaria, .reflexos:
                list[item] = SkillValue(skillAtt: .desteza, armorPenal: isArmorPenal(skill: item), onlyTrain: isOnlyTrain(skill: item))
            case .adestramento, .atuacao, .diplomacia, .enganacao, .intimidacao, .jogatina:
                list[item] = SkillValue(skillAtt: .carisma, armorPenal: isArmorPenal(skill: item), onlyTrain: isOnlyTrain(skill: item))
            case .atletismo, .luta:
                list[item] = SkillValue(skillAtt: .forca, armorPenal: isArmorPenal(skill: item), onlyTrain: isOnlyTrain(skill: item))
            case .conhecimento, .guerra, .investigacao, .misticismo, .nobreza, .oficio:
                list[item] = SkillValue(skillAtt: .inteligencia, armorPenal: isArmorPenal(skill: item), onlyTrain: isOnlyTrain(skill: item))
            case .cura, .intuicao, .percepção, .religião, .sobrevivência, .vontade:
                list[item] = SkillValue(skillAtt: .sabedoria, armorPenal: isArmorPenal(skill: item), onlyTrain: isOnlyTrain(skill: item))
            case .fortitude:
                list[item] = SkillValue(skillAtt: .constituicao, armorPenal: isArmorPenal(skill: item), onlyTrain: isOnlyTrain(skill: item))
            }
        }
        skillList = list
    }
}

struct SkillValue {
    var skillAtt: AttList
    var effects: [Effect]
    var armorPenal: Bool
    var onlyTrain: Bool
    var others: Int
    var train: Bool
    
    init(skillAtt: AttList, effects: [Effect] = [], others: Int = 0, train: Bool = false, armorPenal: Bool = false, onlyTrain: Bool = false) {
        self.skillAtt = skillAtt
        self.effects = effects
        self.others = others
        self.train = train
        self.armorPenal = armorPenal
        self.onlyTrain = onlyTrain
    }
}

enum AttList: String {
    case forca = "Força"
    case desteza = "Desteza"
    case constituicao = "Constituição"
    case inteligencia = "Inteligencia"
    case sabedoria = "Sabedoria"
    case carisma = "Carisma"
}

enum EffectType: String {
    case sum
    case subitract
    case train
}

enum Race: String {
    case humano = "Humano"
    case anao = "Anão"
    case dahllan = "Dahllan"
    case elfo = "Elfo"
    case goblin = "Goblin"
    case lefou = "Lefou"
    case minotauro = "Minotauro"
    case qareen = "Qareen"
    case golem = "Golem"
    case hynne = "Hynne"
    case kliren = "Kliren"
    case medusa = "Medusa"
    case osteon = "Osteon"
    case sereia = "Sereia"
    case tritao = "Tritão"
    case silfide = "Sílfide"
    case suraggelAggelus = "Suraggel - Aggelus"
    case suraggelSulfure = "Suraggel - Sulfure"
    case trog = "Trog"
}

enum CharacterClassEnum: String {
    case arcanista = "Arcanista"
    case barbaro
    case bardo
    case bucaneiro
    case cacador
    case cavaleiro
    case clerigo
    case druida
    case guerreiro
    case inventor
    case ladino
    case lutador
    case nobre = "Nobre"
    case paladino
}

enum RepetEffect: String {
    case eachLvl
    case elevnLvl
    case oddLvl
    case once
    case custom
}

enum SkillList: String, CaseIterable {
    case acrobacia
    case adestramento
    case atletismo
    case atuacao
    case cavalgar
    case conhecimento
    case cura
    case diplomacia
    case enganacao
    case fortitude
    case furtividade
    case guerra
    case iniciativa
    case intimidacao
    case intuicao
    case investigacao
    case jogatina
    case ladinagem
    case luta
    case misticismo
    case nobreza
    case oficio
    case percepção
    case pilotagem
    case pontaria
    case reflexos
    case religião
    case sobrevivência
    case vontade
}

enum EffectTarget: String {
    case life
    case mana
    case defence
    case atack
    case damage
    case skill
    case attribute
}

enum PowerType: String {
    case generic
    case visibleClass
    case invisibleClass
    case origin
}
enum PowerSubType: String {
    case combat
    case skills
    case destiny
    case divinity
    case Torment
    case none
}

enum Divinity: String {
    case aharadak
    case allihanna
    case arsenal
    case azgher
    case hyninn
    case kallyadranoch
    case khalmyr
    case lena
    case linWu
    case marah
    case megalokk
    case nimb
    case oceano
    case sszzaas
    case tannaToh
    case tenebra
    case thwor
    case thyatis
    case valkaria
    case wynna
    case none
}

enum Origin: String {
    case acolito = "Acolito"
    case amigoDosAnimais
    case amnesico
    case artesao
    case artista
    case assistenteDeLaboratorio
    case batedor
    case capanga
    case charlatao
    case circense
    case criminoso
    case curandeiro
    case eremita
    case escravo
    case estudioso
    case fazendeiro
    case forasteiro
    case gladiador
    case guarda
    case herdeiro
    case heroiCampones = "Heroi Camponês"
    case marujo
    case mateiro
    case membroDeGuilda
    case mercador
    case minerador
    case nomade
    case pivete
    case refugiado
    case seguidor
    case selvagem
    case soldado
    case taverneiro
    case trabalhador
    case none
}

