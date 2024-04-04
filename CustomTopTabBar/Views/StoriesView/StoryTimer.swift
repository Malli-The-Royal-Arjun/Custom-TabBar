//
//  StoryTimer.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 08/03/23.
//

import Combine
import Foundation
import SwiftUI

class StoryTimer: ObservableObject {
    
    @Published var progress: Double
    private var interval: TimeInterval
    private var max: Int
    private let publisher: Timer.TimerPublisher
    private var cancellable: Cancellable?
    @Binding var isStoryTrip : Bool
    
    
    init(items: Int, interval: TimeInterval, isStoryTrip: Binding<Bool>) {
        self.max = items
        self.progress = 0
        self.interval = interval
        self.publisher = Timer.publish(every: 0.1, on: .main, in: .default)
        self._isStoryTrip = isStoryTrip
    }
    
    func start() {
        self.cancellable = self.publisher.autoconnect().sink(receiveValue: {  _ in
            var newProgress = self.progress + (0.1 / self.interval)
            if Int(newProgress) >= self.max { newProgress = 0 }
            self.progress = newProgress
            if Float(self.max) == Float(self.progress){
                self.isStoryTrip = false
            }
        })
    }

    func cancel() {
        self.cancellable?.cancel()
    }
    
    func advance(by number: Int) {
        if self.max-1 == Int(self.progress){
            self.isStoryTrip = false
        }else{
            let newProgress = Swift.max((Int(self.progress) + number) % self.max , 0)
            self.progress = Double(newProgress)
        }
    }
    
}

