//
//  EmfPlusRecord.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

public enum EmfPlusRecord {
    case header(_: EmfPlusHeader)
    case endOfFile(_: EmfPlusEndOfFile)
    case comment(_: EmfPlusComment)
    case getDC(_: EmfPlusGetDC)
    case object(_: EmfPlusObject)
    case clear(_: EmfPlusClear)
    case fillRects(_: EmfPlusFillRects)
    case drawRects(_: EmfPlusDrawRects)
    case fillPolygon(_: EmfPlusFillPolygon)
    case drawLines(_: EmfPlusDrawLines)
    case fillEllipse(_: EmfPlusFillEllipse)
    case drawEllipse(_: EmfPlusDrawEllipse)
    case fillPie(_: EmfPlusFillPie)
    case drawPie(_: EmfPlusDrawPie)
    case drawArc(_: EmfPlusDrawArc)
    case fillRegion(_: EmfPlusFillRegion)
    case fillPath(_: EmfPlusFillPath)
    case drawPath(_: EmfPlusDrawPath)
    case fillClosedCurve(_: EmfPlusFillClosedCurve)
    case drawClosedCurve(_: EmfPlusDrawClosedCurve)
    case drawCurve(_: EmfPlusDrawCurve)
    case drawBeziers(_: EmfPlusDrawBeziers)
    case drawImage(_: EmfPlusDrawImage)
    case drawImagePoints(_: EmfPlusDrawImagePoints)
    case drawString(_: EmfPlusDrawString)
    case setRenderingOrigin(_: EmfPlusSetRenderingOrigin)
    case setAntiAliasMode(_: EmfPlusSetAntiAliasMode)
    case setTextRenderingHint(_: EmfPlusSetTextRenderingHint)
    case setTextContrast(_: EmfPlusSetTextContrast)
    case setInterpolationMode(_: EmfPlusSetInterpolationMode)
    case setPixelOffsetMode(_: EmfPlusSetPixelOffsetMode)
    case setCompositingMode(_: EmfPlusSetCompositingMode)
    case setCompositingQuality(_: EmfPlusSetCompositingQuality)
    case save(_: EmfPlusSave)
    case restore(_: EmfPlusRestore)
    case beginContainer(_: EmfPlusBeginContainer)
    case beginContainerNoParams(_: EmfPlusBeginContainerNoParams)
    case endContainer(_: EmfPlusEndContainer)
    case setWorldTransform(_: EmfPlusSetWorldTransform)
    case resetWorldTransform(_: EmfPlusResetWorldTransform)
    case multiplyWorldTransform(_: EmfPlusMultiplyWorldTransform)
    case translateWorldTransform(_: EmfPlusTranslateWorldTransform)
    case scaleWorldTransform(_: EmfPlusScaleWorldTransform)
    case rotateWorldTransform(_: EmfPlusRotateWorldTransform)
    case setPageTransform(_: EmfPlusSetPageTransform)
    case resetClip(_: EmfPlusResetClip)
    case setClipRect(_: EmfPlusSetClipRect)
    case setClipPath(_: EmfPlusSetClipPath)
    case setClipRegion(_: EmfPlusSetClipRegion)
    case offsetClip(_: EmfPlusOffsetClip)
    case drawDriverString(_: EmfPlusDrawDriverString)
    case serializableObject(_: EmfPlusSerializableObject)
    case setTSGraphics(_: EmfPlusSetTSGraphics)
    case setTSClip(_: EmfPlusSetTSClip)
    case unknown(_: EmfPlusUnknownRecord)

    public init(dataStream: inout DataStream) throws {
        let remainingCount = dataStream.remainingCount
        let position = dataStream.position
        let type = try RecordType(dataStream: &dataStream)
        let _: UInt16 = try dataStream.read(endianess: .littleEndian)

        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 12 &&
                size % 4 == 0 &&
                size <= remainingCount else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize == size - 0x0000000C &&
                dataSize % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        dataStream.position = position

        switch type {
        case .header:
            self = .header(try EmfPlusHeader(dataStream: &dataStream))
        case .endOfFile:
            self = .endOfFile(try EmfPlusEndOfFile(dataStream: &dataStream))
        case .comment:
            self = .comment(try EmfPlusComment(dataStream: &dataStream))
        case .getDC:
            self = .getDC(try EmfPlusGetDC(dataStream: &dataStream))
        case .multiFormatStart:
            self = .unknown(try EmfPlusUnknownRecord(dataStream: &dataStream))
        case .multiFormatSection:
            self = .unknown(try EmfPlusUnknownRecord(dataStream: &dataStream))
        case .multiFormatEnd:
            self = .unknown(try EmfPlusUnknownRecord(dataStream: &dataStream))
        case .object:
            self = .object(try EmfPlusObject(dataStream: &dataStream))
        case .clear:
            self = .clear(try EmfPlusClear(dataStream: &dataStream))
        case .fillRects:
            self = .fillRects(try EmfPlusFillRects(dataStream: &dataStream))
        case .drawRects:
            self = .drawRects(try EmfPlusDrawRects(dataStream: &dataStream))
        case .fillPolygon:
            self = .fillPolygon(try EmfPlusFillPolygon(dataStream: &dataStream))
        case .drawLines:
            self = .drawLines(try EmfPlusDrawLines(dataStream: &dataStream))
        case .fillEllipse:
            self = .fillEllipse(try EmfPlusFillEllipse(dataStream: &dataStream))
        case .drawEllipse:
            self = .drawEllipse(try EmfPlusDrawEllipse(dataStream: &dataStream))
        case .fillPie:
            self = .fillPie(try EmfPlusFillPie(dataStream: &dataStream))
        case .drawPie:
            self = .drawPie(try EmfPlusDrawPie(dataStream: &dataStream))
        case .drawArc:
            self = .drawArc(try EmfPlusDrawArc(dataStream: &dataStream))
        case .fillRegion:
            self = .fillRegion(try EmfPlusFillRegion(dataStream: &dataStream))
        case .fillPath:
            self = .fillPath(try EmfPlusFillPath(dataStream: &dataStream))
        case .drawPath:
            self = .drawPath(try EmfPlusDrawPath(dataStream: &dataStream))
        case .fillClosedCurve:
            self = .fillClosedCurve(try EmfPlusFillClosedCurve(dataStream: &dataStream))
        case .drawClosedCurve:
            self = .drawClosedCurve(try EmfPlusDrawClosedCurve(dataStream: &dataStream))
        case .drawCurve:
            self = .drawCurve(try EmfPlusDrawCurve(dataStream: &dataStream))
        case .drawBeziers:
            self = .drawBeziers(try EmfPlusDrawBeziers(dataStream: &dataStream))
        case .drawImage:
            self = .drawImage(try EmfPlusDrawImage(dataStream: &dataStream))
        case .drawImagePoints:
            self = .drawImagePoints(try EmfPlusDrawImagePoints(dataStream: &dataStream))
        case .drawString:
            self = .drawString(try EmfPlusDrawString(dataStream: &dataStream))
        case .setRenderingOrigin:
            self = .setRenderingOrigin(try EmfPlusSetRenderingOrigin(dataStream: &dataStream))
        case .setAntiAliasMode:
            self = .setAntiAliasMode(try EmfPlusSetAntiAliasMode(dataStream: &dataStream))
        case .setTextRenderingHint:
            self = .setTextRenderingHint(try EmfPlusSetTextRenderingHint(dataStream: &dataStream))
        case .setTextContrast:
            self = .setTextContrast(try EmfPlusSetTextContrast(dataStream: &dataStream))
        case .setInterpolationMode:
            self = .setInterpolationMode(try EmfPlusSetInterpolationMode(dataStream: &dataStream))
        case .setPixelOffsetMode:
            self = .setPixelOffsetMode(try EmfPlusSetPixelOffsetMode(dataStream: &dataStream))
        case .setCompositingMode:
            self = .setCompositingMode(try EmfPlusSetCompositingMode(dataStream: &dataStream))
        case .setCompositingQuality:
            self = .setCompositingQuality(try EmfPlusSetCompositingQuality(dataStream: &dataStream))
        case .save:
            self = .save(try EmfPlusSave(dataStream: &dataStream))
        case .restore:
            self = .restore(try EmfPlusRestore(dataStream: &dataStream))
        case .beginContainer:
            self = .beginContainer(try EmfPlusBeginContainer(dataStream: &dataStream))
        case .beginContainerNoParams:
            self = .beginContainerNoParams(try EmfPlusBeginContainerNoParams(dataStream: &dataStream))
        case .endContainer:
            self = .endContainer(try EmfPlusEndContainer(dataStream: &dataStream))
        case .setWorldTransform:
            self = .setWorldTransform(try EmfPlusSetWorldTransform(dataStream: &dataStream))
        case .resetWorldTransform:
            self = .resetWorldTransform(try EmfPlusResetWorldTransform(dataStream: &dataStream))
        case .multiplyWorldTransform:
            self = .multiplyWorldTransform(try EmfPlusMultiplyWorldTransform(dataStream: &dataStream))
        case .translateWorldTransform:
            self = .translateWorldTransform(try EmfPlusTranslateWorldTransform(dataStream: &dataStream))
        case .scaleWorldTransform:
            self = .scaleWorldTransform(try EmfPlusScaleWorldTransform(dataStream: &dataStream))
        case .rotateWorldTransform:
            self = .rotateWorldTransform(try EmfPlusRotateWorldTransform(dataStream: &dataStream))
        case .setPageTransform:
            self = .setPageTransform(try EmfPlusSetPageTransform(dataStream: &dataStream))
        case .resetClip:
            self = .resetClip(try EmfPlusResetClip(dataStream: &dataStream))
        case .setClipRect:
            self = .setClipRect(try EmfPlusSetClipRect(dataStream: &dataStream))
        case .setClipPath:
            self = .setClipPath(try EmfPlusSetClipPath(dataStream: &dataStream))
        case .setClipRegion:
            self = .setClipRegion(try EmfPlusSetClipRegion(dataStream: &dataStream))
        case .offsetClip:
            self = .offsetClip(try EmfPlusOffsetClip(dataStream: &dataStream))
        case .drawDriverString:
            self = .drawDriverString(try EmfPlusDrawDriverString(dataStream: &dataStream))
        case .strokeFillPath:
            self = .unknown(try EmfPlusUnknownRecord(dataStream: &dataStream))
        case .serializableObject:
            self = .serializableObject(try EmfPlusSerializableObject(dataStream: &dataStream))
        case .setTSGraphics:
            self = .setTSGraphics(try EmfPlusSetTSGraphics(dataStream: &dataStream))
        case .setTSClip:
            self = .setTSClip(try EmfPlusSetTSClip(dataStream: &dataStream))
        case .unknown:
            self = .unknown(try EmfPlusUnknownRecord(dataStream: &dataStream))
        }
        
        guard dataStream.position - dataStartPosition == dataSize &&
                dataStream.position - position == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
