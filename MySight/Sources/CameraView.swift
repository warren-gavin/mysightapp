//
//  CameraView.swift
//  MySight
//
//  Created by Warren Gavin on 08/11/2021.
//

import SwiftUI
import BBMetalImage

/// Embeds a BBMetal camera view with a CVD filter in a SwiftUI view
struct CameraView: UIViewRepresentable {
    private let frame: CGRect
    
    // The view is refreshed if there are changes to the cvd
    // parameters, as the user changes the type of CVD or
    // adjusts the severity.
    @Binding private var cvd: CVD
    @Binding private var severity: Float
    @Binding private var backCamera: Bool
    
    /// Initializer for the camera view
    ///
    /// - Parameters:
    ///   - frame: The view frame
    ///   - cvd: The type of color vision deficiency, either deutan, protan or tritan
    ///   - severity: Normalized value of how much of the deficiency to apply. Dichromats have a severity
    ///               of 1.0, while anomalous trichromats can have any value in the range 0 - 0.9999
    init(frame: CGRect,
         simulating cvd: Binding<CVD>,
         severity: Binding<Float>,
         backCamera: Binding<Bool>) {
        self.frame = frame
        self._cvd = cvd
        self._severity = severity
        self._backCamera = backCamera
    }
    
    func makeUIView(context: Context) -> UIView {
        CVDCameraUIView(frame: frame,
                        cvd: cvd,
                        severity: severity,
                        backCamera: backCamera)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let cameraView = (uiView as! CVDCameraUIView)

        cameraView.frame = frame
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.updateView(frame: frame, cvd: cvd, severity: severity, backCamera: backCamera)
    }
}

/// It's not possible to make the CameraView above the owner of the BBMetal camera
/// or view, as the camera & view will be destroyed and re-created every time a binding
/// changes, which will freeze the app.
///
/// Instead this view persists the camera and its applied filter. and is the UIVew wrapped in
/// CameraView using UIRepresentable. When updateUIView is called on CameraView this
/// class updates the filter with the new filtering parameters, which allows realtime updates
/// of the CVD simulation
private final class CVDCameraUIView: UIView {
    // We must persist the camera for the lifetime of this view
    private let camera: BBMetalCamera
    private let metalView: BBMetalView
    
    // The filter to apply to the camera
    private let filter: CVDFilter
    
    private var isShowingBackCamera: Bool
    
    init(frame frameRect: CGRect, cvd: CVD, severity: Float, backCamera: Bool) {
        guard let camera = BBMetalCamera(sessionPreset: .hd1920x1080,
                                         position: backCamera ? .back : .front) else {
            fatalError("Metal camera view not available")
        }
        
        self.camera = camera
        self.filter = CVDFilter(cvd: cvd, severity: severity)
        self.isShowingBackCamera = backCamera
        self.metalView = BBMetalView(frame: frameRect)

        super.init(frame: frameRect)
        
        addSubview(metalView)
        
        camera
            .add(consumer: filter)
            .add(consumer: metalView)
        
        camera.start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var orientation: AVCaptureVideoOrientation {
        let windowScenes = UIApplication.shared.connectedScenes.compactMap {
            $0 as? UIWindowScene
        }
        
        switch windowScenes.first!.interfaceOrientation {
        case .unknown:
            fatalError()

        case .portrait:
            return .portrait

        case  .portraitUpsideDown:
            return .portraitUpsideDown

        case .landscapeLeft:
            return .landscapeLeft

        case .landscapeRight:
            return .landscapeRight

        @unknown default:
            fatalError()
        }
    }
    
    func updateView(frame: CGRect, cvd: CVD, severity: Float, backCamera: Bool) {
        metalView.frame = frame
        camera.videoOrientation = orientation

        filter.cvd = cvd
        filter.severity = severity
        
        if isShowingBackCamera != backCamera {
            camera.switchCameraPosition()
            isShowingBackCamera = backCamera
        }
    }
}
