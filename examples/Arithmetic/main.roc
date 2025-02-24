app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br" }

import pf.Stdout
import pf.Arg exposing [Arg]

main! : List Arg.Arg => Result {} _
main! = \raw_args ->

    args : { a : I32, b : I32 }
    args = try read_args raw_args

    result =
        [
            ("sum", args.a + args.b),
            ("difference", args.a - args.b),
            ("product", args.a * args.b),
            ("integer quotient", args.a // args.b),
            ("remainder", args.a % args.b),
            ("exponentiation", Num.powInt args.a args.b),
        ]
        |> List.map \(operation, answer) ->
            answer_str = Num.toStr answer

            "$(operation): $(answer_str)"
        |> Str.joinWith "\n"

    Stdout.line! result

## Reads two command-line arguments, attempts to parse them as `I32` numbers,
## and returns a task containing a record with two fields, `a` and `b`, holding
## the parsed `I32` values.
##
## If the arguments are missing, if there's an issue with parsing the arguments
## as `I32` numbers, or if the parsed numbers are outside the expected range
## (-1000 to 1000), the function will return a task that fails with an
## error `InvalidArg` or `InvalidNumStr`.
read_args : List Arg -> Result { a : I32, b : I32 } [Exit I32 Str]
read_args = \raw_args ->

    invalid_args = Exit 1 "Error: Please provide two integers between -1000 and 1000 as arguments."
    invalid_num_str = Exit 1 "Error: Invalid number format. Please provide integers between -1000 and 1000."

    args =
        if List.len raw_args != 3 then
            return Err invalid_args
        else
            List.map raw_args Arg.display

    a_result = List.get args 1 |> Result.try Str.toI32
    b_result = List.get args 2 |> Result.try Str.toI32

    when (a_result, b_result) is
        (Ok a, Ok b) ->
            if a < -1000 || a > 1000 || b < -1000 || b > 1000 then
                Err invalid_num_str
            else
                Ok { a, b }

        _ -> Err invalid_num_str
