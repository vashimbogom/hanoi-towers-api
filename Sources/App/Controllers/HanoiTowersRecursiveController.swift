//
//  HanoiTowersRecursiveController.swift
//  hanoi-towers-api
//
//  Created by Lord Jose Lopez on 28/10/24.
//

import Foundation

class HanoiTowersRecursiveController: HanoiTowersController, @unchecked Sendable {
    
    func solve(disks: Int) -> [SolutionStep] {
        var steps: [SolutionStep] = []
        solve(disks: disks, source: AppConstants.Hanoi.sourceRod, auxiliary: AppConstants.Hanoi.auxiliaryRod, destination: AppConstants.Hanoi.destinationRod, steps: &steps)
        return steps
        
        //solveParallel(disks: disks, source: AppConstants.Hanoi.sourceRod, auxiliary: AppConstants.Hanoi.auxiliaryRod, destination: AppConstants.Hanoi.destinationRod)
    }
    
    private func solve(disks: Int, source: String, auxiliary: String, destination: String, steps: inout [SolutionStep]) {
        
        //Base case
        if disks == 1 {
            steps.append(SolutionStep(disk: 1, sourceRod: source, destinationRod: destination))
            return
        }
        
        // Take (n-1) disks from source to auxiliary
        solve(disks: disks - 1, source: source, auxiliary: destination, destination: auxiliary, steps: &steps)
        
        // Take the n-th disk from source to destination
        steps.append(SolutionStep(disk: disks, sourceRod: source, destinationRod: destination))
        
        // Take the (n-1) disks from auxiliary to destination
        solve(disks: disks - 1, source: auxiliary, auxiliary: source, destination: destination, steps: &steps)
    }
    
    var leftSteps: [SolutionStep] = []
    var rightSteps: [SolutionStep] = []
    
    @Sendable func solveParallel(disks: Int, source: String, auxiliary: String, destination: String) -> [SolutionStep] {
        let queue = DispatchQueue(label: AppConstants.Hanoi.queueName, attributes: .concurrent)
        let group = DispatchGroup()
        
        @Sendable func hanoi(_ n: Int, from source: String, to destination: String, aux: String) -> [SolutionStep] {
            if n == 1 {
                // Base case: only one move required
                return [SolutionStep(disk: n, sourceRod: source, destinationRod: destination)]
            }

            let moveStep = SolutionStep(disk: n, sourceRod: source, destinationRod: destination)

            group.enter()
            queue.async(group: group) { [weak self] in
                guard let self else { return }
                self.leftSteps = hanoi(n - 1, from: source, to: aux, aux: destination)
                group.leave()
            }

            group.enter()
            queue.async(group: group) { [weak self] in
                guard let self else { return }
                self.rightSteps = hanoi(n - 1, from: aux, to: destination, aux: source)
                group.leave()
            }
            
            group.wait() // Wait for left and right recursive calls to complete
            return leftSteps + [moveStep] + rightSteps
        }
        
        return hanoi(disks, from: source, to: destination, aux: auxiliary)
    }
}
