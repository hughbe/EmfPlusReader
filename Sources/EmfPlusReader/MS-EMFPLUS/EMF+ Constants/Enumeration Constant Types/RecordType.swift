//
//  RecordType.swift
//  
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.1.1 RecordType Enumeration
/// The RecordType enumeration defines record types used in EMF+ metafiles.
/// typedef enum
/// {
///  EmfPlusHeader = 0x4001,
///  EmfPlusEndOfFile = 0x4002,
///  EmfPlusComment = 0x4003,
///  EmfPlusGetDC = 0x4004,
///  EmfPlusMultiFormatStart = 0x4005,
///  EmfPlusMultiFormatSection = 0x4006,
///  EmfPlusMultiFormatEnd = 0x4007,
///  EmfPlusObject = 0x4008,
///  EmfPlusClear = 0x4009,
///  EmfPlusFillRects = 0x400A,
///  EmfPlusDrawRects = 0x400B,
///  EmfPlusFillPolygon = 0x400C,
///  EmfPlusDrawLines = 0x400D,
///  EmfPlusFillEllipse = 0x400E,
///  EmfPlusDrawEllipse = 0x400F,
///  EmfPlusFillPie = 0x4010,
///  EmfPlusDrawPie = 0x4011,
///  EmfPlusDrawArc = 0x4012,
///  EmfPlusFillRegion = 0x4013,
///  EmfPlusFillPath = 0x4014,
///  EmfPlusDrawPath = 0x4015,
///  EmfPlusFillClosedCurve = 0x4016,
///  EmfPlusDrawClosedCurve = 0x4017,
///  EmfPlusDrawCurve = 0x4018,
///  EmfPlusDrawBeziers = 0x4019,
///  EmfPlusDrawImage = 0x401A,
///  EmfPlusDrawImagePoints = 0x401B,
///  EmfPlusDrawString = 0x401C,
///  EmfPlusSetRenderingOrigin = 0x401D,
///  EmfPlusSetAntiAliasMode = 0x401E,
///  EmfPlusSetTextRenderingHint = 0x401F,
///  EmfPlusSetTextContrast = 0x4020,
///  EmfPlusSetInterpolationMode = 0x4021,
///  EmfPlusSetPixelOffsetMode = 0x4022,
///  EmfPlusSetCompositingMode = 0x4023,
///  EmfPlusSetCompositingQuality = 0x4024,
///  EmfPlusSave = 0x4025,
///  EmfPlusRestore = 0x4026,
///  EmfPlusBeginContainer = 0x4027,
///  EmfPlusBeginContainerNoParams = 0x4028,
///  EmfPlusEndContainer = 0x4029,
///  EmfPlusSetWorldTransform = 0x402A,
///  EmfPlusResetWorldTransform = 0x402B,
///  EmfPlusMultiplyWorldTransform = 0x402C,
///  EmfPlusTranslateWorldTransform = 0x402D,
///  EmfPlusScaleWorldTransform = 0x402E,
///  EmfPlusRotateWorldTransform = 0x402F,
///  EmfPlusSetPageTransform = 0x4030,
///  EmfPlusResetClip = 0x4031,
///  EmfPlusSetClipRect = 0x4032,
///  EmfPlusSetClipPath = 0x4033,
///  EmfPlusSetClipRegion = 0x4034,
///  EmfPlusOffsetClip = 0x4035,
///  EmfPlusDrawDriverstring = 0x4036,
///  EmfPlusStrokeFillPath = 0x4037,
///  EmfPlusSerializableObject = 0x4038,
///  EmfPlusSetTSGraphics = 0x4039,
///  EmfPlusSetTSClip = 0x403A
/// } RecordType;
/// See section 2.1.1 for the specification of additional enumerations.
public enum RecordType: UInt16, DataStreamCreatable {
    /// EmfPlusHeader: This record specifies the start of EMF+ data in the metafile. It MUST be embedded in the first EMF record
    /// after the EMF Header record.
    case header = 0x4001

    /// EmfPlusEndOfFile: This record specifies the end of EMF+ data in the metafile.
    case endOfFile = 0x4002

    /// EmfPlusComment: This record specifies arbitrary private data.
    case comment = 0x4003

    /// EmfPlusGetDC: This record specifies that subsequent EMF records ([MS-EMF] section 2.3) encountered in the metafile
    /// SHOULD be processed. EMF records cease being processed when the next EMF+ record is encountered.
    case getDC = 0x4004

    /// EmfPlusMultiFormatStart: This record is reserved and MUST NOT be used.
    case multiFormatStart = 0x4005

    /// EmfPlusMultiFormatSection: This record is reserved and MUST NOT be used.
    case multiFormatSection = 0x4006

    /// EmfPlusMultiFormatEnd: This record is reserved and MUST NOT be used.
    case multiFormatEnd = 0x4007

    /// EmfPlusObject: This record specifies an object for use in graphics operations.
    case object = 0x4008

    /// EmfPlusClear: This record clears the output coordinate space and initializes it with a specified background color and transparency.
    case clear = 0x4009

    /// EmfPlusFillRects: This record defines how to fill the interiors of a series of rectangles, using a specified brush.
    case fillRects = 0x400A

    /// EmfPlusDrawRects: This record defines the pen strokes for drawing a series of rectangles.
    case drawRects = 0x400B

    /// EmfPlusFillPolygon: This record defines the data to fill the interior of a polygon, using a specified brush.
    case fillPolygon = 0x400C

    /// EmfPlusDrawLines: This record defines the pen strokes for drawing a series of connected lines.
    case drawLines = 0x400D

    /// EmfPlusFillEllipse: This record defines how to fill the interiors of an ellipse, using a specified brush.
    case fillEllipse = 0x400E

    /// EmfPlusFillPie: This record defines how to fill a section of an interior section of an ellipse using a specified brush.
    case drawEllipse = 0x400F

    /// EmfPlusFillPie: This record defines how to fill a section of an interior section of an ellipse using a specified brush.
    case fillPie = 0x4010

    /// EmfPlusDrawPie: This record defines pen strokes for drawing a section of an ellipse.
    case drawPie = 0x4011

    /// EmfPlusDrawArc: The record defines pen strokes for drawing an arc of an ellipse.
    case drawArc = 0x4012

    /// EmfPlusFillRegion: This record defines how to fill the interior of a region using a specified brush.
    case fillRegion = 0x4013
    
    /// EmfPlusFillPath: The record defines how to fill the interiors of the figures defined in a graphics path with a specified brush.
    /// A path is an object that defines an arbitrary sequence of lines, curves, and shapes.
    case fillPath = 0x4014

    /// EmfPlusDrawPath: The record defines the pen strokes to draw the figures in a graphics path. A path is an object that defines
    /// an arbitrary sequence of lines, curves, and shapes.
    case drawPath = 0x4015

    /// EmfPlusFillClosedCurve: This record defines how to fill the interior of a closed cardinal spline using a specified brush.
    case fillClosedCurve = 0x4016

    /// EmfPlusDrawClosedCurve: This record defines the pen and strokes for drawing a closed cardinal spline.
    case drawClosedCurve = 0x4017

    /// EmfPlusDrawCurve: This record defines the pen strokes for drawing a cardinal spline.
    case drawCurve = 0x4018

    /// EmfPlusDrawBeziers: This record defines the pen strokes for drawing a Bezier spline.
    case drawBeziers = 0x4019

    /// EmfPlusDrawImage: This record defines a scaled EmfPlusImage object. An image can consist of either bitmap or metafile data.
    case drawImage = 0x401A

    /// EmfPlusDrawImagePoints: This record defines a scaled EmfPlusImage object inside a parallelogram. An image can consist of
    /// either bitmap or metafile data.
    case drawImagePoints = 0x401B

    /// EmfPlusDrawString: This record defines a text string based on a font, a layout rectangle, and a format.
    case drawString = 0x401C

    /// EmfPlusSetRenderingOrigin: This record sets the origin of rendering to the specified horizontal and vertical coordinates.
    /// This applies to hatch brushes and to 8 and 16 bits per pixel dither patterns.
    case setRenderingOrigin = 0x401D

    /// EmfPlusSetAntiAliasMode: This record defines whether to enable or disable text anti-aliasing. Text anti-aliasing is a method
    /// of making lines and edges of character glyphs appear smoother when drawn on an output surface.
    case setAntiAliasMode = 0x401E

    /// EmfPlusSetTextRenderingHint: This record defines the process used for rendering text.
    case setTextRenderingHint = 0x401F

    /// EmfPlusSetTextContrast: This record sets text contrast according to the specified text gamma value.
    case setTextContrast = 0x4020

    /// EmfPlusSetInterpolationMode: This record defines the interpolation mode of an object according to the specified type of
    /// image filtering. The interpolation mode influences how scaling (stretching and shrinking) is performed.
    case setInterpolationMode = 0x4021

    /// EmfPlusSetPixelOffsetMode: This record defines the pixel offset mode according to the specified pixel centering value.
    case setPixelOffsetMode = 0x4022

    /// EmfPlusSetCompositingMode: This record defines the compositing mode according to the state of alpha blending, which
    /// specifies how source colors are combined with background colors.
    case setCompositingMode = 0x4023

    /// EmfPlusSetCompositingQuality: This record defines the compositing quality, which describes the desired level of quality
    /// for creating composite images from multiple objects.
    case setCompositingQuality = 0x4024

    /// EmfPlusSave: This record saves the graphics state, identified by a specified index, on a stack of saved graphics states.
    /// Each stack index is associated with a particular saved state, and the index is used by an EmfPlusRestore record to restore
    /// the state.
    case save = 0x4025

    /// EmfPlusRestore: This record restores the graphics state, identified by a specified index, from a stack of saved graphics states.
    /// Each stack index is associated with a particular saved state, and the index is defined by an EmfPlusSave record to save the state.
    case restore = 0x4026

    /// EmfPlusBeginContainer: This record opens a new graphics state container and specifies a transform for it. Graphics containers
    /// are used to retain elements of the graphics state.
    case beginContainer = 0x4027

    /// EmfPlusBeginContainerNoParams: This record opens a new graphics state container.
    case beginContainerNoParams = 0x4028

    /// EmfPlusEndContainer: This record closes a graphics state container that was previously opened by a begin container operation.
    case endContainer = 0x4029

    /// EmfPlusSetWorldTransform: This record defines the current world space transform in the playback device context, according to
    /// a specified transform matrix.
    case setWorldTransform = 0x402A

    /// EmfPlusResetWorldTransform: This record resets the current world space transform to the identify matrix.
    case resetWorldTransform = 0x402B

    /// EmfPlusMultiplyWorldTransform: This record multiplies the current world space by a specified transform matrix.
    case multiplyWorldTransform = 0x402C

    /// EmfPlusTranslateWorldTransform: This record applies a translation transform to the current world space by specified horizontal
    /// and vertical distances.
    case translateWorldTransform = 0x402D

    /// EmfPlusScaleWorldTransform: This record applies a scaling transform to the current world space by specified horizontal and
    /// vertical scale factors.
    case scaleWorldTransform = 0x402E

    /// EmfPlusRotateWorldTransform: This record rotates the current world space by a specified angle.
    case rotateWorldTransform = 0x402F

    /// EmfPlusSetPageTransform: This record specifies extra scaling factors for the current world space transform.
    case setPageTransform = 0x4030

    /// EmfPlusResetClip: This record resets the current clipping region for the world space to infinity.
    case resetClip = 0x4031

    /// EmfPlusSetClipRect: This record combines the current clipping region with a rectangle.
    case setClipRect = 0x4032

    /// EmfPlusSetClipPath: This record combines the current clipping region with a graphics path.
    case setClipPath = 0x4033

    /// EmfPlusSetClipRegion: This record combines the current clipping region with another graphics region.
    case setClipRegion = 0x4034

    /// EmfPlusOffsetClip: This record applies a translation transform on the current clipping region of the world space.
    case offsetClip = 0x4035

    /// EmfPlusDrawDriverString: This record specifies text output with character positions.
    case drawDriverString = 0x4036

    /// EmfPlusStrokeFillPath: This record closes any open figures in a path, strokes the outline of the path by using the current pen,
    /// and fills its interior by using the current brush.
    case strokeFillPath = 0x4037

    /// EmfPlusSerializableObject: This record defines an image effects parameter block that has been serialized into a data buffer.
    case serializableObject = 0x4038

    /// EmfPlusSetTSGraphics: This record specifies the state of a graphics device context for a terminal server.
    case setTSGraphics = 0x4039

    /// EmfPlusSetTSClip: This record specifies clipping areas in the graphics device context for a terminal server.
    case setTSClip = 0x403
    
    case unknown = 0xFFFF
    
    public init(dataStream: inout DataStream) throws {
        let rawValue: UInt16 = try dataStream.read(endianess: .littleEndian)
        guard let value = Self(rawValue: rawValue) else {
            self = .unknown
            return
        }
        
        self = value
    }
}
