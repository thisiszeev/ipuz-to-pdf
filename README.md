# ipuz-to-pdf

Convert ipuz files into PDF so you can easily import into a print publication.

These scripts can be used for once off conversion as well as batch conversion by calling from another script.

## codeword-maker.sh

This script is for converting ipuz files for crosswords into PDF files as CodeWord puzzles.

A CodeWord puzzle is a word puzzle where instead of written clues, each letter is replaced with a number. The numbers are filled in across the puzzle in the top left of each corner. Three letters are given (at random) as the starting clues. You then try and solve the puzzles by using logic to work out what letters belong to what numbers.

### Usage

```
$ bash codeword-maker {filename}.ipuz
```

### Sample Files for Testing

    cwsample1.ipuz
    cwsample2.ipuz
    cwsample3.ipuz

### Output Files are as Follows

#### CodeWord.{filename}.legendbottom.pdf

This is an importable version of the puzzle legend for use when layout position is desired for the top or bottom of the puzzle.

#### CodeWord.{filename}.legendside.pdf

This is an importable version of the puzzle legend for use when layout position is desired for the side of the puzzle.

#### CodeWord.{filename}.puzzle.pdf

This is an importable version of the actual puzzle. The font has been converted to paths, so you do not need the font installed on the computer used for publishing the puzzle to print.

#### CodeWord.{filename}.solution.pdf

This is an importable version of the puzzle solution. The font has been converted to paths, so you do not need the font installed on the computer used for publishing the puzzle to print.

## crossword-maker.sh

This script is for converting ipuz files for crosswords into PDF files.

A CrossWord is a word puzzle, where you are given a blank grid and a set of clues divided into Across and Down. The top or left block for where the word(s) starts in the grid is numbered, and the clues are numbered accordingly. You try and solve the puzzle by using the clues to identifiy the possible word(s), taking into account the amount of squares available for the word(s) and any intersecting letters from other solved words.

### Usage

```
$ bash crossword-maker {filename}.ipuz
```

### Sample Files for Testing

    cwsample1.ipuz
    cwsample2.ipuz
    cwsample3.ipuz

### Output Files are as Follows

#### CrossWord.{filename}.clues.txt

This is a text file containing the clues for the puzzle.

#### CrossWord.{filename}.puzzle.pdf

This is an importable version of the actual puzzle. The font has been converted to paths, so you do not need the font installed on the computer used for publishing the puzzle to print.

#### CrossWord.{filename}.solution.pdf

This is an importable version of the puzzle solution. The font has been converted to paths, so you do not need the font installed on the computer used for publishing the puzzle to print.

## Coming soon: Sudoku, Mathdoku and Samurai Sudoku.

Hit me up on Reddit for any requested puzzles to add to future versions.

[u/thisiszeev](https://reddit.com/u/thisiszeev)

# List of Software that can be Used to Create ipuz Files.

## Linux

- Crosswords : https://gitlab.gnome.org/jrb/crosswords
- kSudoku : https://invent.kde.org/games/ksudoku

> If you know of any other software that can create ipuz files, please let me know and I will add it here.

# Donations

Please consider making me small donation. Even though my scripts are open source and free to use, I still need to eat. And the occasional bottle of wine also goes down well.

    $5 buys me a cup of coffee
    $10 buys me a nice burger
    $20 buys me a bottle of wine
    Anything above that will be awesome as well.

For commercial users, you are free to use these scripts for your publications. But I urge you to please consider making a donation of $50. In return I will provide you direct email/WhatsApp support for a period of 12 months.

You can send me a donation via Paypal https://www.paypal.com/paypalme/thisiszeev

Drop me a message on Reddit if you do make a donation. u/thisiszeev

Support is only offered freely to those who donate $20 or more.

Your donation contributes to further development.

If you need a custom script, contact me on Reddit for pricing.
