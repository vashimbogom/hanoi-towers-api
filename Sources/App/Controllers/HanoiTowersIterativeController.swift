//
//  HanoiTowersIterativeController.swift
//  hanoi-towers-api
//
//  Created by Lord Jose Lopez on 28/10/24.
//

import Foundation

class HanoiTowersIterativeController: HanoiTowersController {
    
    func solve(disks: Int) -> [SolutionStep] {
        solve(disks: disks, source: AppConstants.Hanoi.sourceRod, auxiliary: AppConstants.Hanoi.auxiliaryRod, destination: AppConstants.Hanoi.destinationRod)
    }
    
    private func solve(disks: Int, source: String, auxiliary: String, destination: String) -> [SolutionStep] {
        
        var steps: [SolutionStep] = []
        let rods = [source, destination, auxiliary]
        
        let moves = 1 << disks // 2^n moves for n disks
        for i in 1..<moves {
            // Determine which disk to move
            let disk = Int(log2(Double(i & -i))) + 1
            
            // Calculate the source and destination rods
            let fromRod = rods[(i & i - 1) % 3]
            let toRod = rods[((i | i - 1) + 1) % 3]
            
            steps.append(SolutionStep(disk: disk, sourceRod: fromRod, destinationRod: toRod))
        }
        
        return steps
    }
}
