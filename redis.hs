{-# LANGUAGE OverloadedStrings #-}

module Redis where

import           Control.Applicative
import           Data.ByteString as B
import qualified Data.Attoparsec.Char8 as AC
import           Data.Attoparsec.Lazy as AL
import qualified Data.ByteString.Lazy as BL

type Request = [ByteString]

parseRequest :: BL.ByteString -> Request
parseRequest request = do
    case parse parseCount request of
      Fail {} -> error "Invalid argument count"
      Done request' n -> parseArguments n request'

parseCount :: Parser Int
parseCount = string "*" *> AC.decimal <* crlf

parseArguments :: Int -> BL.ByteString -> Request
parseArguments n request
    | n == 0    = []
    | otherwise =
      case parse parseArgument request of
        Fail {} -> error "Invalid request argument"
        Done request' argument -> argument : parseArguments (n - 1) request'

parseArgument :: Parser ByteString
parseArgument = string "$" *> getArgument <* crlf
  where getArgument = AC.decimal <* crlf >>= AL.take

crlf :: Parser ByteString
crlf = string "\r\n"
