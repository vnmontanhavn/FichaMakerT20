//
//  SheetBuilder.swift
//  FichaMakerT20
//
//  Created by Vinicius Soares Lima on 13/07/23.
//

import Foundation

class SheetBuilder {
    func crateSheetData() -> CharacterModel {
        let att = Attributes(forca: 10, destreza: 11, constituicao: 12, inteligencia: 13, sabedoria: 14, carisma: 15)
        let eff = Effect(name: "AttDexGoblin", value: 2, target: .attribute, repet: .once, effect: .sum)
        let power = Power(name: "Peste Esguia", description: "Seu tamanho é Pequeno (veja a página 106), mas seu deslocamento se mantém 9m. Apesar de pequenos, goblins são rápidos", type: .visibleClass, subType: .none, effects: [eff])
        let charClass = CharacterClass(characterClass: .nobre, lvl: 2)
        return CharacterModel(name: "Mia", age: "20", maxLife: 20, life: 20, maxMana: 10, mana: 10, defence: 10, attributes: att, origin: .heroiCampones, divinity: .khalmyr, race: .goblin, characterClass: [charClass, charClass, charClass, charClass, charClass, charClass, charClass], powers: [power], knowSkills: [.enganacao, .atuacao, .fortitude, .diplomacia])
    }
}
