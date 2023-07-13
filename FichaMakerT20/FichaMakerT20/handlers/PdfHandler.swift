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
            point.y = sheetFirstLine(point: point, width: pageWidth - (pageXStartPosition * 2), characterSheet: characterSheet)
            point.y = sheetSecondLine(point: point, width: pageWidth - (pageXStartPosition * 2), characterSheet: characterSheet)
            point.y = sheetAttElement(point: point, width: pageWidth - (pageXStartPosition * 2), characterSheet: characterSheet)
            
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
    func sheetFirstLine(point: CGPoint, width: Double, characterSheet: CharacterModel) -> Double {
        let textFont = UIFont.boldSystemFont(ofSize: 12)
        let text = "Nome: \(characterSheet.name)  Idade: \(characterSheet.age)"
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
        let text = "Raça: \(characterSheet.race.rawValue)  Origem: \(characterSheet.origin.rawValue) "
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
            text = item.name
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
    
    func pdfPreview(pdfData: Data?, view: inout PDFView) {
        if let data = pdfData {
            view.document = PDFDocument(data: data)
            view.autoScales = true
        }
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
