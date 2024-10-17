//
//  ViewModelType.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/5/24.
//

import Combine

protocol ViewModelType: AnyObject, ObservableObject {
    associatedtype Input
    associatedtype Output
    var cancellables: Set<AnyCancellable> { get set }
    var input: Input { get set }
    var output: Output { get }
    
    func transform()
}
