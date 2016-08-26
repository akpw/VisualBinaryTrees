import Foundation

/// Base DI protocol
public protocol DependencyInjectable {
    associatedtype Dependency
    func inject(_: Dependency)
    func validateDependencies()
}
extension DependencyInjectable {
    /// default implementation
    public func validateDependencies() { fatalError("The dependencies have not been properly set") }
}
