import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "The Hanoi Towers Problem Solver API. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }"
    }
    
    app.get("solve", ":algorithm", ":discs") { req async throws -> [SolutionStep] in
        
        guard let alg = req.parameters.get("algorithm", as: String.self),
              alg == "rec" || alg == "iter" || alg == "seq"
        else {
            throw Abort(.badRequest, reason: "Missing solution algorithm query parameter. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }")
        }
        
        guard let discs = req.parameters.get("discs", as: Int.self) else {
            throw Abort(.badRequest, reason: "Missing number of discs parameter. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }")
        }
        
        if discs > 13 {
            throw Abort(.payloadTooLarge, reason: "Wo wo wo!!! Don't be too greedy! 13 is the max number of Disks.")
        }
        
        var controller: HanoiTowersController
        
        // Choose controller to solve the problem
        if alg == "rec" {
            controller = HanoiTowersRecursiveController()
        } else if alg == "iter" {
            controller = HanoiTowersIterativeController()
        } else {
            controller = HanoiTowersSequenceController()
        }
        // Solve the Hanoi Towers problem
        controller = HanoiTowersRecursiveController()
        return controller.solve(disks: discs)
    }
}
