//
//  AppConstants.swift
//  hanoi-towers-api
//
//  Created by Lord Jose Lopez on 29/10/24.
//

enum AppConstants {
    
    enum Hanoi {
        
        static let sourceRod = "A"
        static let destinationRod = "C"
        static let auxiliaryRod = "B"
        static let queueName = "hanoi.queue"
        
        enum Algorithm {
            static let recursive = "rec"
            static let iterative = "iter"
            static let sequential = "seq"
        }
        
        enum Routes {
            static let solve = "solve"
        }
        
        enum Parameters {
            static let algorithm = "algorithm"
            static let numberOfDisks = "disks"
        }
        enum Screens {
            static let welcomeMessage = "The Hanoi Towers Problem Solver API. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }"
        }
        
        enum ErrorMessages {
            static let missingAlgorithParameter = "Missing solution algorithm query parameter. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }"
            static let missingDisksParameter = "Missing number of discs parameter. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }"
            static let exceedsMaxDisks = "Wo wo wo!!! Don't be too greedy! 13 is the max number of Disks."
        }
        
    }
}
