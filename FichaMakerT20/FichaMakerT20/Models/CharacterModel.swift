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
    let knowSkills: [Skill]
}

struct Attributes {
    var forca: AttValue = AttValue(name: "Força", value: 0)
    var destreza: AttValue = AttValue(name: "Destreza", value: 0)
    var constituicao: AttValue = AttValue(name: "Constituição", value: 0)
    var inteligencia: AttValue = AttValue(name: "Inteligencia", value: 0)
    var sabedoria: AttValue = AttValue(name: "Sabedoria", value: 0)
    var carisma: AttValue = AttValue(name: "Carisma", value: 0)
    
    init(forca: Int, destreza: Int, constituicao: Int, inteligencia: Int, sabedoria: Int , carisma: Int) {
        self.forca.value = forca
        self.destreza.value = destreza
        self.constituicao.value = constituicao
        self.inteligencia.value = inteligencia
        self.sabedoria.value = sabedoria
        self.carisma.value = carisma
    }
}

struct AttValue {
    let name: String
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
    var skill: Skill?
    let repet: RepetEffect
    let effect: EffectType
}

enum EffectType: String {
    case sum
    case subitract
    case train
}

enum Race: String {
    case humano = "Humano"
    case anao
    case dahllan
    case elfo
    case goblin
    case lefou
    case minotauro
    case qareen
    case golem
    case hynne
    case kliren
    case medusa
    case osteon
    case sereia
    case sílfide
    case suraggelAggelus
    case suraggelSulfure
    case trog
}

struct CharacterClass {
    let characterClass: CharacterClassEnum
    var lvl: Int
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

enum Skill: String {
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

