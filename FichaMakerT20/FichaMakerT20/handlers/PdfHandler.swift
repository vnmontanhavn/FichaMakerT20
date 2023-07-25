//
//  PdfHandler.swift
//  FichaMaker
//
//  Created by Vinicius Soares Lima on 04/07/23.
//

import Foundation
import PDFKit


class PdfHandler {
    func generatePDF(characterSheet: CharacterModel) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [ kCGPDFContextAuthor as String : "Montanha" ]
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageYStartPosition: Double = 20
        let pageXStartPosition: Double = 20
        let graphc = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        let data = graphc.pdfData { (context) in
            context.beginPage()
            var point = CGPoint(x: pageXStartPosition, y: pageYStartPosition)
            var skillStartWidth = pageWidth/3
            point.y = sheetFirstLine(point: point, width: pageWidth - (pageXStartPosition * 2), characterSheet: characterSheet)
            point.y = sheetSecondLine(point: point, width: pageWidth - (pageXStartPosition * 2), characterSheet: characterSheet)
            point.y = sheetAttElement(point: point, width: pageWidth - (pageXStartPosition * 2), characterSheet: characterSheet)
            point.y = point.y + pageYStartPosition
            point.x = skillStartWidth * 2 - pageXStartPosition
            let skillheightEnd = createSkillList(point: point, width: skillStartWidth, characterSheet: characterSheet)
            drawBorder(rect: CGRect(x: point.x - 10, y: point.y - 10, width: skillStartWidth + 20, height: skillheightEnd - point.y + 20))
            point.x = pageXStartPosition
            createImage(rect: CGRect(x: pageWidth / 2, y: point.y, width: 30, height: 30))
// --------------xxxxxx---------------
            
            context.beginPage()
            var yPosition: Double = 10
            let width = pageWidth / 2 - 24
            let label = UILabel()
            let textFont = UIFont.boldSystemFont(ofSize: 12)
            label.font = textFont
            let text = "batata"
            label.text = text
            while yPosition < pageHeight {
                var height = text.height(withConstrainedWidth: width, font: textFont)
                if yPosition + height >= pageHeight {
                    break
                }
                label.drawText(in: CGRect(x: 12, y: yPosition, width: width, height: height))
                yPosition = yPosition + height
            }
            
            let border = PDFBorder()
            border.lineWidth = 10
            border.draw(in: CGRect(x: 0, y: 0, width: pageWidth / 2, height: pageHeight))
        }
        return data
    }
    
    func drawBorder(rect: CGRect) {
        let border = PDFBorder()
        border.lineWidth = 5
        border.draw(in: rect)
    }
    
    func sheetFirstLine(point: CGPoint, width: Double, characterSheet: CharacterModel) -> Double {
        let textFont = UIFont.boldSystemFont(ofSize: 12)
        let text = "Nome: \(characterSheet.name)    Idade: \(characterSheet.age)"
        var height = text.height(withConstrainedWidth: width, font: textFont)
        let label = UILabel()
        label.text = text
        label.font = textFont
        label.numberOfLines = 0
        let yPosition: Double = point.y
        height = text.height(withConstrainedWidth: width, font: textFont)
        label.drawText(in: CGRect(x: point.x, y: point.y, width: width, height: height))
        
        return yPosition + height
    }
    func sheetSecondLine(point: CGPoint, width: Double, characterSheet: CharacterModel) -> Double {
        let textFont = UIFont.boldSystemFont(ofSize: 12)
        let text = "Raça: \(characterSheet.race.rawValue)    Origem: \(characterSheet.origin.rawValue)   "
        var height = text.height(withConstrainedWidth: width, font: textFont)
        let localWidth = text.width(withConstrainedHeight: height, font: textFont)
        let label = UILabel()
        label.text = text
        label.font = textFont
        label.numberOfLines = 0
        let yPosition: Double = point.y
        height = text.height(withConstrainedWidth: width, font: textFont)
        label.drawText(in: CGRect(x: point.x, y: point.y, width: width, height: height))
        var classStr = "Classe: "
        var lvl = 0
        for item in characterSheet.characterClass {
            classStr = classStr + "\(item.characterClass.rawValue)\(item.lvl) "
            lvl = lvl + item.lvl
        }
        classStr = classStr + "Nivel: \(lvl)"
        height = classStr.height(withConstrainedWidth: width - localWidth, font: textFont)
        label.text = classStr
        label.drawText(in: CGRect(x: point.x + localWidth, y: point.y, width: width - localWidth, height: height))
        return yPosition + height
    }
    
    func sheetAttElement(point: CGPoint, width: Double, characterSheet: CharacterModel) -> Double {
        let textFont = UIFont.boldSystemFont(ofSize: 12)
        let attFont = UIFont.boldSystemFont(ofSize: 16)
        let sheetAtt = characterSheet.attributes
        let att = [sheetAtt.forca, sheetAtt.destreza, sheetAtt.constituicao, sheetAtt.inteligencia, sheetAtt.sabedoria, sheetAtt.carisma]
        var text = ""
        var textValue = ""
        var heightTitle = text.height(withConstrainedWidth: width, font: textFont)
        var widthTitle = text.width(withConstrainedHeight: heightTitle, font: textFont)
        var heighValue = textValue.height(withConstrainedWidth: width, font: attFont)
        var widthValue = textValue.width(withConstrainedHeight: heighValue, font: attFont)
        let label = UILabel()
        let valueLabel = UILabel()
        let yPosition: Double = point.y
        var xPointText: Double = point.x
        var xPointValue: Double = xPointText + (widthTitle / 2) - (widthValue / 2)
        for item in att {
            text = item.name.rawValue
            textValue = "\(item.value)"
            heightTitle = text.height(withConstrainedWidth: width, font: textFont)
            widthTitle = text.width(withConstrainedHeight: heightTitle, font: textFont)
            heighValue = textValue.height(withConstrainedWidth: width, font: attFont)
            widthValue = textValue.width(withConstrainedHeight: heighValue, font: attFont)
            
            label.text = text
            label.font = textFont
            valueLabel.text = textValue
            valueLabel.font = attFont
            
            xPointValue = xPointText + (widthTitle / 2) - (widthValue / 2)
            label.drawText(in: CGRect(x: xPointText, y: point.y, width: width, height: heightTitle))
            valueLabel.drawText(in: CGRect(x: xPointValue, y: point.y + heightTitle, width: widthValue, height: heighValue))
            xPointText = xPointText + widthTitle + point.x
        }
        
        
        
        
        let height = heightTitle + heighValue
        return yPosition + height
    }
    
    func createImage(rect: CGRect){
        let image = UIImage(named: "erro")
        image?.draw(in: rect)
    }
    
    func createSkillList(point: CGPoint, width: Double, characterSheet: CharacterModel) -> Double {
        var localPoint = point
        for item in SkillList.allCases {
            if item == .none {
                break
            }
            localPoint.y = drawSkill(skill: item, characterSheet: characterSheet, width: width, point: localPoint)
        }
        return localPoint.y
    }
    
    func drawSkill(skill: SkillList, characterSheet: CharacterModel, width: Double, point: CGPoint) -> Double {
        let textFont = UIFont.boldSystemFont(ofSize: 12)
        let label = UILabel()
        label.font = textFont
        label.numberOfLines = 0
        label.textAlignment = .right
        var text = skillValue(skill: skill, characterSheet: characterSheet)
        let height = text.height(withConstrainedWidth: width, font: textFont)
        label.text = text
        label.drawText(in: CGRect(x: point.x, y: point.y, width: width, height: height))
        return point.y + height
    }
    
    func pdfPreview(pdfData: Data?, view: inout PDFView) {
        if let data = pdfData {
            view.document = PDFDocument(data: data)
            view.autoScales = true
        }
    }
    
    
    func skillValue(skill: SkillList, characterSheet: CharacterModel) -> String {
        guard let skillTarget = characterSheet.skills.skillList[skill] else {
            return "skill não cadastrada"
        }
        let lvl = characterSheet.characterClass.reduce(0, {$0 + $1.lvl})
        let attValue = attValue(att: skillTarget.skillAtt, characterSheet: characterSheet)
        var textName = "\(skill.rawValue) "
        var textValue = "\(lvl/2) + \(attValue) + "
        var profBonus = 0
        var other = 0
        var total = lvl/2 + attValue
        if skillTarget.train {
            textName = "*" + textName
            profBonus = 2
            if lvl >= 7 && lvl < 15 {
                profBonus = 4
            } else if lvl >= 15 {
                profBonus = 6
            }
        }
        textValue = textValue + "\(profBonus) + "
        for item in skillTarget.effects {
            if item.target == .skill && item.skill == skill {
                var value = item.value
                if item.effect == .subitract {
                    value = -value
                }
                other = other + value
            }
        }
        total = total + profBonus + other
        var value = skillTarget.onlyTrain && !skillTarget.train ? "ND" : "\(total)"
        textValue = value + " = " + textValue + "\(other)"
        return "\(textName)  \(textValue)"
    }
    func attValue(att: AttList, characterSheet: CharacterModel) -> Int {
        var value = 0
        switch att {
        case .forca:
            value = characterSheet.attributes.forca.value
        case .desteza:
            value = characterSheet.attributes.destreza.value
        case .constituicao:
            value = characterSheet.attributes.constituicao.value
        case .inteligencia:
            value = characterSheet.attributes.inteligencia.value
        case .sabedoria:
            value = characterSheet.attributes.sabedoria.value
        case .carisma:
            value = characterSheet.attributes.carisma.value
        }
        return value
    }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
