import Foundation

extension String {
    func removingFilenameExtension() -> Self {
        var filenameComponents = components(separatedBy: ".")
        guard filenameComponents.count > 1 else { return self }
        filenameComponents.removeLast()
        // handle multiple dots in paths e.g. "image.tree.jpp" -> image.tree
        return filenameComponents.joined(separator: ".")
    }
}
