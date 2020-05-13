import Foundation

protocol Camera: CustomStringConvertible {
    var price: Float { get }
}

class Mirrorless: Camera {
    var price: Float { return 500 }
    var description: String { "Mirrorless" }
}

class Compact: Camera {
    var price: Float = 200
    var description: String = "Mirrorless"
}

class DSLR: Camera {
    var price: Float = 1500
    var description: String = "Mirrorless"
}

struct FeaturePrice {
    static let viewFinder: Float = 75
    static let lcd: Float = 50
    static let videoCapture: Float = 100
}

protocol CameraDecorator: Camera {
    var wrapped: Camera { get }
    init(wrapped: Camera)
}

extension CameraDecorator {
    var price: Float { wrapped.price }
    var description: String { wrapped.description }
}

struct LCDDecorator: CameraDecorator {
    var wrapped: Camera
    
    init(wrapped: Camera) {
        self.wrapped = wrapped
    }
    
    var price: Float {
        wrapped.price + FeaturePrice.lcd
    }
    
    var description: String {
        wrapped.description + ", LCD"
    }
}

struct VideoCaptureDecorator: CameraDecorator {
    var wrapped: Camera
    
    init(wrapped: Camera) {
        self.wrapped = wrapped
    }
    
    var price: Float {
        wrapped.price + FeaturePrice.videoCapture
    }
    
    var description: String {
        wrapped.description + ", Video Recording"
    }
}

struct ViewFinderDecorator: CameraDecorator {
    var wrapped: Camera
    
    init(wrapped: Camera) {
        self.wrapped = wrapped
    }
    
    var price: Float {
        wrapped.price + FeaturePrice.viewFinder
    }
    
    var description: String {
        wrapped.description + ", View finder"
    }
}


var camera: Camera = Mirrorless()
print("\(camera)\n\t$\(camera.price)")

camera = LCDDecorator(wrapped: camera)
print("\(camera)\n\t$\(camera.price)")

camera = ViewFinderDecorator(wrapped: camera)
print("\(camera)\n\t$\(camera.price)")

camera = VideoCaptureDecorator(wrapped: camera)
print("\(camera)\n\t$\(camera.price)")

camera = LCDDecorator(wrapped: camera)
print("\(camera)\n\t$\(camera.price)")
