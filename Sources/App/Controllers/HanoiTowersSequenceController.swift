//
//  HanoiTowersSequenceController.swift
//  hanoi-towers-api
//
//  Created by Lord Jose Lopez on 28/10/24.
//

import Foundation

class HanoiTowersSequenceController: HanoiTowersController {
    
    func solve(disks: Int) -> [SolutionStep] {
        Array(HanoiSequence(disks: disks, source: AppConstants.Hanoi.sourceRod, auxiliary: AppConstants.Hanoi.auxiliaryRod, destination: AppConstants.Hanoi.destinationRod))
    }
}

struct HanoiIterator: IteratorProtocol {
    let disks: Int
    let rods: [String]
    private var currentMove = 1
    private let moves: Int
    
    init(disks: Int, source: String, auxiliary: String, destination: String) {
        self.disks = disks
        self.rods = [source, destination, auxiliary]
        self.moves = 1 << disks
    }
    
    mutating func next() -> SolutionStep? {
        guard currentMove < moves else { return nil }
        
        let disk = Int(log2(Double(currentMove & -currentMove))) + 1
        let fromRod = rods[(currentMove & currentMove - 1) % 3]
        let toRod = rods[((currentMove | currentMove - 1) + 1) % 3]
        
        currentMove += 1
        return SolutionStep(disk: disk, sourceRod: fromRod, destinationRod: toRod)
    }
}

struct HanoiSequence: Sequence {
    let disks: Int
    let source: String
    let auxiliary: String
    let destination: String
    
    func makeIterator() -> HanoiIterator {
        return HanoiIterator(disks: disks, source: source, auxiliary: auxiliary, destination: destination)
    }
}
