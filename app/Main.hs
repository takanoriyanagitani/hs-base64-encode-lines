module Main (main) where

import Data.ByteString as B
import Data.ByteString.Base64 (encode)
import Data.ByteString.Char8 as C8
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.Text.IO as TIO
import System.IO (isEOF)

newtype IsEOF = IsEOF Bool

lineFeed :: T.Text
lineFeed = T.singleton '\n'

type InputModifier = T.Text -> T.Text

createModifier :: T.Text -> InputModifier
createModifier txtToAppend originalTxt = T.append originalTxt txtToAppend

appendNewlineModifier :: InputModifier
appendNewlineModifier = createModifier lineFeed

-- Helper functions for each step of the encoding process
text2utf8 :: T.Text -> B.ByteString
text2utf8 = TE.encodeUtf8

bytes2base64 :: B.ByteString -> B.ByteString
bytes2base64 = encode

-- Pure function composed of well-named helpers, using the InputModifier
textToBase64WithNewline :: T.Text -> B.ByteString
textToBase64WithNewline = bytes2base64 . text2utf8 . appendNewlineModifier

-- Impure function for processing a line
processLine :: T.Text -> IO ()
processLine = C8.putStrLn . textToBase64WithNewline

-- The main IO loop, using top-level pattern matching for termination
processInput :: IsEOF -> IO ()
processInput (IsEOF True) = return ()
processInput (IsEOF False) = do
    line <- TIO.getLine -- Strips the newline
    processLine line
    eof <- isEOF
    processInput (IsEOF eof)

main :: IO ()
main = do
    eof <- isEOF
    processInput (IsEOF eof)
