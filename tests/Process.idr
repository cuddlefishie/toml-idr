-- SPDX-FileCopyrightText: 2022 The toml-idr developers
--
-- SPDX-License-Identifier: CC0-1.0

module Process

import Tester

import Data.List.Quantifiers
import Language.TOML
import Language.TOML.Processing

basicUnordered : Test
basicUnordered = test "process unordered table" $ assert $ check result
    where
        Spec : TableTy
        Spec = [("name", TString), ("age", TInteger)]

        table : Table
        table = fromList [("age", VInteger 999), ("name", VString "John Doe")]

        result : Either TableError (TableOf Spec)
        result = processTable Spec table

        check : Either TableError (TableOf Spec) -> Bool
        check (Left x) = False
        check (Right [name, age]) = name == "John Doe" && age == 999

basicNested : Test
basicNested = test "process nested table" $ assert $ check result
    where
        Spec : TableTy
        Spec = [("name", TString),
                ("age", TInteger),
                ("skills", TTable
                    [("running", TInteger),
                     ("programming", TInteger)])]

        table : Table
        table = fromList [("age", VInteger 999),
                          ("name", VString "John Doe"),
                          ("skills", VTable $ fromList
                              [("running", VInteger 5),
                               ("programming", VInteger 8)])]

        result : Either TableError (TableOf Spec)
        result = processTable Spec table

        check : Either TableError (TableOf Spec) -> Bool
        check (Left x) = False
        check (Right [name, age, [running, programming]]) =
            name == "John Doe" && age == 999 && running == 5 && programming == 8


export
tests : List Test
tests = [basicUnordered, basicNested]