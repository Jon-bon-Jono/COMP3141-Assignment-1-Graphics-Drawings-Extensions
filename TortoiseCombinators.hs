--Written by Jonathan Williams (z5162987), June 2020
module TortoiseCombinators
       ( andThen 
       , loop 
       , invisibly 
       , retrace 
       , overlay 
       ) where

import Tortoise

-- See Tests.hs or the assignment spec for specifications for each
-- of these combinators.

andThen :: Instructions -> Instructions -> Instructions
andThen Stop i2 = i2
andThen (Move d i1) i2 = Move d $ andThen i1 i2
andThen (Turn a i1) i2 = Turn a $ andThen i1 i2
andThen (SetStyle s i1) i2 = SetStyle s $ andThen i1 i2
andThen (SetColour c i1) i2 = SetColour c $ andThen i1 i2
andThen (PenDown i1) i2 = PenDown $ andThen i1 i2
andThen (PenUp i1) i2 = PenUp $ andThen i1 i2

loop :: Int -> Instructions -> Instructions
loop n i = foldr andThen Stop $ replicate n i

invisibly :: Instructions -> Instructions
invisibly Stop = Stop
invisibly i = PenUp $ rm_pendown i True
       where 
              rm_pendown :: Instructions -> Bool -> Instructions
              rm_pendown (Move d i') pendown = Move d $ rm_pendown i' pendown 
              rm_pendown (Turn a i') pendown = Turn a $ rm_pendown i' pendown
              rm_pendown (SetStyle s i') pendown = SetStyle s $ rm_pendown i' pendown
              rm_pendown (SetColour c i') pendown = SetColour c $ rm_pendown i' pendown
              rm_pendown (PenDown i') pendown = rm_pendown i' True
              rm_pendown (PenUp i') pendown = PenUp $ rm_pendown i' False
              rm_pendown Stop pendown
                     | pendown = PenDown Stop
                     | otherwise = Stop
retrace :: Instructions -> Instructions
retrace i = reverse_ins start i Stop
       where
              --traverse through instructions i1
              --keep track of state s, where instructions are applied moving forward
              reverse_ins :: TortoiseState -> Instructions -> Instructions -> Instructions
              reverse_ins s (Move d i1) i2 = reverse_ins (snd (tortoise (Move d Stop) s)) i1 (Move (-d) i2)
              reverse_ins s (Turn a i1) i2 = reverse_ins (snd (tortoise (Turn a Stop) s)) i1 (Turn (-a) i2)
              reverse_ins s (SetStyle st i1) i2 = reverse_ins (snd (tortoise (SetStyle st Stop) s)) i1 (SetStyle (style s) i2)
              reverse_ins s (SetColour c i1) i2 = reverse_ins (snd (tortoise (SetColour c Stop) s)) i1 (SetColour (colour s) i2)
              --if a Pen instruction is applied with no effect moving forward, ensure it has no effect when reversed
              --check state to see if the pen instruction had effect moving forward
              reverse_ins s (PenDown i1) i2 
                     | (penDown s) == True = reverse_ins (snd (tortoise (PenDown Stop) s)) i1 (PenDown i2)
                     | otherwise = reverse_ins (snd (tortoise (PenDown Stop) s)) i1 (PenUp i2)
              reverse_ins s (PenUp i1) i2 
                     | (penDown s) == True = reverse_ins (snd (tortoise (PenUp Stop) s)) i1 (PenDown i2)
                     | otherwise = reverse_ins (snd (tortoise (PenUp Stop) s)) i1 (PenUp i2)
              reverse_ins s (Stop) i2 = i2

overlay :: [Instructions] -> Instructions
overlay [] = Stop
overlay (i:is) = andThen (andThen i (invisibly (retrace i))) (overlay is)

