//
//  EmfPlusFile.swift
//  
//
//  Created by Hugh Bellamy on 30/11/2020.
//

import DataStream
import Foundation

/// [MS-EMF] 1.3.1 Metafile Structure
/// EMF+ defines a set of graphical images and text using commands, objects, and properties similar to Windows GDI+ [MSDN-GDI+].
/// EMF+ metafiles are portable, device-independent containers for graphical images, and they are used for sending commands and
/// objects to output devices, such as displays and printers, which support the drawing of images and text. The device or media that
/// receives such a metafile can be located on a network, or it can be connected directly to the computer running the operating system
/// on which the metafile is created.
/// EMF+ metafiles are actually a form of EMF metafile in which EMF+ records are embedded in EMF records ([MS-EMF] section 2.3).
/// Embedding EMF+ records in EMF metafiles is possible because of the EMF capability to embed arbitrary private data in certain
/// types of records. This is illustrated by the figure that follows. Note that multiple EMF+ records can be embedded in a single EMF
/// record.
/// The EMF record in which arbitrary private data can be embedded is called an EMF "Comment" record.
/// The form of EMF comment record that contains embedded EMF+ records is called EMR_COMMENT_EMFPLUS.
/// As shown in the following figure, the first EMF+ record in the metafile, the EMF+ Header record (section 2.3.3.3), is embedded within
/// the first EMF record following the EMF Header record ([MSEMF] section 2.3.4.2); and the last EMF+ record, the EMF+ End of File
/// record (section 2.3.3.1), is embedded within the EMF record immediately preceding the EMF End of File record.
/// In the EMF metafile in this figure, Case I shows a group of EMF+ records, followed by some EMF records, followed by another group
/// of EMF+ records; and Case II shows a group of EMF+ records terminated by a Get Device Context record (section 2.3.3.2), followed
/// by some EMF records, followed by another group of EMF+ records. The presence or absence of the Get Device Context record can
/// determine how the metafile is processed.
/// The structure of an EMF+ metafile is such that EMF+ records are embedded in EMF records, meaning that some outer EMF records
/// are always present, namely EMF control records, and EMF records that contain EMF+ records:
///  EMR_HEADER - required for all types of metafiles
///  EMR_COMMENT – required to contain EMF+ records
///  EMR_EOF - required to terminate all types of metafiles
/// The EMF+ Header record contains flags that distinguish between two different types of EMF+ metafile.<1>
///  Metafiles identified as EMF+ Only can contain both EMF+ records and EMF records. All EMF+ records are used to render the
/// image. The EMF records that are part of the drawing are those preceded by a Get Device Context record—case II in the figure above.
/// EMF record processing stops when the next EMF+ record of any type is encountered.
/// If a system that cannot play back EMF+ records attempts to play the metafile by using only EMF records, the drawing might be
/// incomplete. If a system performs EMF+ playback mode as expected, then no EMF drawing records are processed unless they are
/// preceded by a Get Device Context record. For example, in case I, an EMF+ Only playback mode would process the EMF control
/// records and none of the EMF drawing records. As a result, EMF records alone do not suffice to render the drawing that was recorded
/// in an EMF+ Only metafile.
///  Metafiles identified as EMF+ Dual can also contain both EMF+ records and EMF records. The EMF+ Dual flag indicates that the
/// metafile contains a complete set of EMF records sufficient to correctly render the entire drawing on a system that cannot playback
/// EMF+ records. This feature makes it possible to render an image with different levels of graphics support in the operating system.
/// However, only one or the other type of records is processed. All records are enumerated sequentially. For EMF playback, the
/// metafile player only uses EMF records and ignores EMF+ records. For EMF+ playback, the metafile is played as if it is EMF+ Only.
/// For either type of EMF+ metafile, the EMF records that follow an EmfPlusGetDC record are played, until the next EMF+ record,
/// EMF_HEADER, or EMF_EOF (), regardless of the EMF+ Dual flag setting.
/// Note: EMF+ is not considered an extension to the EMF feature set; that is, EMF+ does not define new EMF records. EMF+ is
/// semantically a completely separate, independent format. EMF+ records define graphical images and text using commands, objects,
/// and properties of GDI+.
public struct EmfPlusFile {
    public let header: EmfPlusHeader
    private let data: DataStream
    
    public init(data: Data) throws {
        var dataStream = DataStream(data)
        try self.init(dataStream: &dataStream)
    }
    
    public init(dataStream: inout DataStream) throws {
        self.header = try EmfPlusHeader(dataStream: &dataStream)
        self.data = DataStream(slicing: dataStream, startIndex: dataStream.position, count: dataStream.remainingCount)
    }
    
    public func enumerateRecords(proc: (EmfPlusRecord) throws -> MetafileEnumerationStatus) throws {
        var dataStream = self.data
        while dataStream.position < dataStream.count {
            let record = try EmfPlusRecord(dataStream: &dataStream)
            if case .endOfFile = record {
                break
            }

            let result = try proc(record)
            if result == .break {
                break
            }
        }
    }
    
    public enum MetafileEnumerationStatus {
        case `continue`
        case `break`
    }
}
