# COMP3141-Assignment-1-Graphics-Drawings-Extensions
COMP3141 (Software System Design and Implementation) Assignment 1, implement a variety of combinators for a graphics drawing library in haskell. It intends to give experience writing Haskell programs, functional programming idioms, programming to algebraic specifications expressed as QuickCheck properties and concepts such as monoids, the distinction between syntax and semantics, and various notions of composition. 

- Main.hs: a main function to save an example image to ‘tortoise.png’. It also includes a series of example graphics of increasing complexity
- Tests.hs: QuickCheck specifications for all combinator functions to implement, as well as any support code to run the tests
- TestSupport.hs: support code such as Arbitrary instances and alternative test data generation strategies
- Tortoise.hs: definitions for the syntax and semantics of the TortoiseGraphics Language
- TortoiseGraphics.hs: graphical backend (using the rasterific library) for the Tortoise Graphics Language, to actually visualise gaphics
- TortoiseCombinators.hs: stubs for the additional functions you are requiredto implement 

## Combinators:
Sequential composition
- `andThen :: Instructions -> Instructions -> Instructions`
- `Stop ‘andThen‘ i = i`
- `i ‘andThen‘ Stop = i`
- `i1 ‘andThen‘ (i2 ‘andThen‘ i3) = (i1 ‘andThen‘ i2) ‘andThen‘ i3`

Bounded Looping
- `loop :: Int -> Instructions -> Instructions`
- `tortoise (loop n i) start = foldr comp nop (replicate n (tortoise i)) start`

Invisibility 
- `invisibly :: Instructions -> Instructions`
- `tortoise (invisibly i) start = ([],finalState i)`

Retracing Backwards
- `retrace :: Instructions -> Instructions`
- `tortoise (retrace i) (finalState i) = (reverse (tortoisePic i), start)`

Overlaying Images
- `overlay :: [Instructions] -> Instructions`
- `finalState (overlay is) = start`
- `tortoisePic (overlay is) = concatMap tortoisePic is`

## Usage:
Build:
- `stack build`

Run the program from‘Main.hs’, which saves an image tortoise.png:
- `stack exec Tortoise`

Test against all quickCheck properties:
- `stack exec TortoiseTests`


