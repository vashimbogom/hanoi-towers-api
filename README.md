# Tower of Hanoi API

A Swift Vapor API to solve the Hanoi Towers Puzzle 

## Usage
The API has exposed the `solve` route to invoke the solution.

You can choose between three algorithms to solve the puzzle:
- Recursive
- Iterative
- Sequential

In order to get solution steps for a given number of disks you need to perform a `get` call following this scheme: 

`/solve/{ rec | iter | seq }/{ number_of_discs }`

where:
- `rec` stands for `recursive`
- `íter` stands for `iterative`
- `seq` stands for `sequential`

### JSON Response
The json response you get from the API is an array of steps to solve the puzzle, following the next convention:
```json
[{"disk":1,"sourceRod":"A","destinationRod":"C"},{"destinationRod":"B","disk":2,"sourceRod":"A"},{"sourceRod":"C","destinationRod":"B","disk":1},{"sourceRod":"A","destinationRod":"C","disk":3},{"disk":1,"sourceRod":"B","destinationRod":"A"},{"sourceRod":"B","destinationRod":"C","disk":2},{"sourceRod":"A","disk":1,"destinationRod":"C"}]
```


### Restrictions
To avoid computing overhead, the API is limited to give the solution for a maximum number of `13 disks`.

## Instalation
In order to run locally the solution you need to have pre-installed the ´vapor´ framework. Follow the instructions on https://docs.vapor.codes/install/macos/ to get started.

Once ready, open the `Package.swift` in Xcode, use SPM to download the dependencies and run the project. It will start a localserver on: 127.0.0.1:8080

## Testing Coverage
<img width="1138" alt="coverage" src="https://github.com/user-attachments/assets/f4eb8f33-014b-4147-af30-38df11ed2240">

## Deployment
This package can be easily deployed to any docker container. I recommend using fly.io since it is the easiest way to get it published. Please visit https://fly.io for more information.
