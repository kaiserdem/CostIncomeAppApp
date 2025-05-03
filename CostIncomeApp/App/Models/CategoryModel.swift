import SwiftUI
import Combine

class CategoryModel: ObservableObject {
    @Published var categories: [String] = UserDefaults.standard.stringArray(forKey: "categories") ?? []
    
    func addCategory(_ name: String) {
        categories.append(name)
        UserDefaults.standard.set(categories, forKey: "categories")
    }
} 