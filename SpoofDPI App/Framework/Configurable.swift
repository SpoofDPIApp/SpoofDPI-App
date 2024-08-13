//
//  Configurable.swift
//  SpoofDPI App
//

protocol Configurable { }

extension Configurable {
    func with(
        _ configuration: (Self) -> Void
    ) -> Self {
        configuration(self)
        return self
    }
}
