import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        AppConstants.Hanoi.Screens.welcomeMessage
    }
    
    app.get(
        "solve",
        ":\(AppConstants.Hanoi.Parameters.algorithm)",
        ":\(AppConstants.Hanoi.Parameters.numberOfDisks)")
    { req async throws -> [SolutionStep] in
        
        guard let alg = req.parameters.get(AppConstants.Hanoi.Parameters.algorithm, as: String.self),
              alg == AppConstants.Hanoi.Algorithm.recursive
                || alg == AppConstants.Hanoi.Algorithm.iterative
                || alg == AppConstants.Hanoi.Algorithm.sequential
        else {
            throw Abort(.badRequest, reason: AppConstants.Hanoi.ErrorMessages.missingAlgorithParameter)
        }
        
        guard let discs = req.parameters.get(AppConstants.Hanoi.Parameters.numberOfDisks, as: Int.self) else {
            throw Abort(.badRequest, reason: AppConstants.Hanoi.ErrorMessages.missingDisksParameter)
        }
        
        if discs > 13 {
            throw Abort(.payloadTooLarge, reason: AppConstants.Hanoi.ErrorMessages.exceedsMaxDisks)
        }
        
        var controller: HanoiTowersController
        
        // Choose controller to solve the problem
        if alg == AppConstants.Hanoi.Algorithm.recursive {
            controller = HanoiTowersRecursiveController()
        } else if alg == AppConstants.Hanoi.Algorithm.iterative {
            controller = HanoiTowersIterativeController()
        } else {
            controller = HanoiTowersSequenceController()
        }
        // Solve the Hanoi Towers problem
        return controller.solve(disks: discs)
    }
}
