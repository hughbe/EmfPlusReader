//
//  CompositingQuality.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.6 CompositingQuality Enumeration
/// The CompositingQuality enumeration defines levels of quality for creating composite images.<2>
/// typedef enum
/// {
///  CompositingQualityDefault = 0x01,
///  CompositingQualityHighSpeed = 0x02,
///  CompositingQualityHighQuality = 0x03,
///  CompositingQualityGammaCorrected = 0x04,
///  CompositingQualityAssumeLinear = 0x05
/// } CompositingQuality;
/// Graphics colors are specified by EmfPlusARGB objects.
/// Compositing is done during rendering when source pixels are combined with destination pixels. The compositing quality directly relates
/// to the visual quality of the output and is inversely proportional to the time required for rendering. The higher the quality, the more
/// surrounding pixels need to be taken into account during the compositing operation; hence, the slower the render time.
/// See section 2.1.1 for the specification of additional enumerations.
public enum CompositingQuality: UInt8, DataStreamCreatable {
    /// CompositingQualityDefault: No gamma correction is performed. Gamma correction controls the overall brightness and contrast
    /// of an image. Without gamma correction, composited images can appear too light or too dark.
    case `default` = 0x01
    
    /// CompositingQualityHighSpeed: No gamma correction is performed. Compositing speed is favored at the expense of quality.
    /// In terms of the result, there is no difference between this value and CompositingQualityDefault.
    case highSpeed = 0x02
    
    /// CompositingQualityHighQuality: Gamma correction is performed. Compositing quality is favored at the expense of speed.
    case highQuality = 0x03
    
    /// CompositingQualityGammaCorrected: Enable gamma correction for higher-quality compositing with lower speed. In terms of
    /// the result, there is no difference between this value and CompositingQualityHighQuality.
    case gammaCorrected = 0x04
    
    /// CompositingQualityAssumeLinear: No gamma correction is performed; however, using linear values results in better quality
    /// than the default at a slightly lower speed.
    case assumeLinear = 0x05
}
