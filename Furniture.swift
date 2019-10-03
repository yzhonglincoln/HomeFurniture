
import Foundation

class Furniture {
    let name: String
    let description: String
    // change let to var to allow change on imageData
    var imageData: Data?
    
    init(name: String, description: String, imageData: Data? = nil) {
        self.name = name
        self.description = description
        self.imageData = imageData
    }
}
