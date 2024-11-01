# GesellschaftProtocol

[![Build Status](https://github.com/Syx/GesellschaftProtocol.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/Syx/GesellschaftProtocol.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This is a rewrite of [Obiter Dicta](https://github.com/SyxP/ObiterDicta.jl). The previous versions have proven to unwieldy and unextensible. The goals (in order of priority) are:

1. Better data management and querying features.
2. Improved style in imports and exports. 
3. Rewrite of the interactive parser and allow for more interactivity with the user.
4. Attempt at maintaining historical data, but this is less of a focus as with ObiterDicta.
5. The goal would mostly be to access current game information rather than historical game information.
6. Reaching feature parity with wiki sites and Obiter Dicta. This is less of a priority as it once was with currently better data sources.
There will be 2 key differences. We will not be maintaining the Steam News search (This was in practice very cumbersome to use and barely useful).
Second, rather than maintaining 2 different scripts for user and the developer updating tools, they will instead be merged.
The tradeoff is that GesellshchaftProtocol is significantly larger to install.

## Installation



1. Download Julia.
2. In Julia, enter `]add https://github.com/SyxP/GesellschaftProtocol.jl`
3. This has not yet been implemented yet! To run, in Julia mode (you should see `julia>`, if not press Backspace), enter `using ObiterDicta`. 
4. You can now freely access the `Limbus Query>` mode via `)`. Use `help` to see the list of commands and 
for each command `_command_ help` would access the command specific help.
5. In the future, when updates have been made, you can use `]up` to update the package directly. 

## Updating Steps

This is meant for updating the data source in Limbus, and not meant for updating the package.

## Other Sources

Chinese translations are from https://github.com/LocalizeLimbusCompany/LocalizeLimbusCompany

Russian translations are from https://github.com/Crescent-Corporation/LimbusCompanyBusRUS

## Features
