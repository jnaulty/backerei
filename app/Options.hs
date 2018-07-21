module Options where

import qualified Data.Text           as T
import           Foundation
import           Options.Applicative
import qualified Prelude             as P

data Context = Context {
  contextHomeDirectory :: P.FilePath
}

data Options = Options {
  optionsConfigPath :: P.FilePath,
  optionsCommand    :: Command
}

data Command =
  Version |
  Init T.Text T.Text Int |
  Status |
  Monitor |
  Payout

options ∷ Context → Parser Options
options ctx = Options <$> configOptions ctx <*> commandOptions

configOptions ∷ Context → Parser P.FilePath
configOptions ctx = strOption (long "config" <> metavar "FILE" <> help "Path to YAML configuration file" <> showDefault <> value (contextHomeDirectory ctx <> "/.backerei.yaml"))

commandOptions ∷ Parser Command
commandOptions = subparser (
  command "version" (info versionOptions (progDesc "Display program version information")) <>
  command "init" (info initOptions (progDesc "Initialize configuration file")) <>
  command "status" (info statusOptions (progDesc "Display delegate status")) <>
  command "monitor" (info monitorOptions (progDesc "Monitor baking & endorsing status")) <>
  command "payout" (info payoutOptions (progDesc "Calculate payouts"))
  )

versionOptions ∷ Parser Command
versionOptions = pure Version

initOptions ∷ Parser Command
initOptions = Init <$> addrOptions <*> hostOptions <*> portOptions

addrOptions ∷ Parser T.Text
addrOptions = T.pack <$> strOption (long "tz1" <> metavar "tz1" <> help "tz1 address of baker implicit account")

hostOptions ∷ Parser T.Text
hostOptions = T.pack <$> strOption (long "host" <> metavar "HOST" <> help "Tezos node RPC hostname" <> showDefault <> value "127.0.0.1")

portOptions ∷ Parser Int
portOptions = option auto (long "port" <> metavar "PORT" <> help "Tezos node RPC port" <> showDefault <> value 8732)

statusOptions ∷ Parser Command
statusOptions = pure Status

monitorOptions ∷ Parser Command
monitorOptions = pure Monitor

payoutOptions ∷ Parser Command
payoutOptions = pure Payout