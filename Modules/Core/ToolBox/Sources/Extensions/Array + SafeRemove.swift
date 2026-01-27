import Foundation

// MARK: - Safe remove

public extension Array {
    
    /// Выполняет попытку безопасного удаления элемента массива по индексу.
    ///
    /// В случае попыткки удаления элемента по индексу,
    /// выходящему за пределы массива, ничего не произойдет.
    /// - Parameter index: индекс удаляемого элемента.
    /// - Returns: удаленный элемент.
    @discardableResult
    mutating func remove(safe index: Int) -> Element? {
        guard
            0 <= index,
            index < count,
            !isEmpty
        else { return nil }
        
        return remove(at: index)
    }
}
