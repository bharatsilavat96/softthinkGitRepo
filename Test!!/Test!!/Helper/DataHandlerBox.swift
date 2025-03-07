//
//  DataHandleBox.swift
//  Test!!
//
//  Created by Bharat Shilavat on 04/03/25.
//

import Foundation


class DataHanlderBox<T> {
typealias Listener = (T) -> Void
var listener: Listener?
func bind(listener: Listener?) {
    self.listener = listener
}
func bindAndFire(listener: Listener?) {
    self.listener = listener
    listener?(value)
}
var value: T {
    didSet {
        listener?(value)
    }
}
init(_ v: T) {
    value = v
}}
