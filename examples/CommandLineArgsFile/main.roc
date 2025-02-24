# Run with `roc ./examples/CommandLineArgsFile/main.roc -- examples/CommandLineArgsFile/input.txt`
# This currently does not work in combination with --linker=legacy, see https://github.com/roc-lang/basic-cli/issues/82
app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br",
}

import pf.Stdout
import pf.Path exposing [Path]
import pf.Arg

main! = \raw_args ->

    # read all command line arguments
    args = List.map raw_args Arg.display

    # get the second argument, the first is the executable's path
    arg_result = List.get args 1 |> Result.mapErr \_ -> ZeroArgsGiven

    when arg_result is
        Ok arg ->
            file_content_str = try read_file_to_str! (Path.from_str arg)

            Stdout.line! "file content: $(file_content_str)"

        Err ZeroArgsGiven ->
            Err (Exit 1 "Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- path/to/input.txt`")

# reads a file and puts all lines in one Str
read_file_to_str! : Path => Result Str [ReadFileErr Str]_
read_file_to_str! = \path ->

    path
    |> Path.read_utf8!
    |> Result.mapErr \file_read_err ->
        path_str = Path.display path

        when file_read_err is
            FileReadErr _ read_err ->
                read_err_str = Inspect.toStr read_err

                ReadFileErr "Failed to read file:\n\t$(path_str)\nWith error:\n\t$(read_err_str)"

            FileReadUtf8Err _ _ ->
                ReadFileErr "I could not read the file:\n\t$(path_str)\nIt contains charcaters that are not valid UTF-8:\n\t- Check if the file is encoded using a different format and convert it to UTF-8.\n\t- Check if the file is corrupted.\n\t- Find the characters that are not valid UTF-8 and fix or remove them."
