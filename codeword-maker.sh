#!/bin/bash

## Title: CodeWord Maker 1.01
## Author: Ze'ev Schurmann
## License: This project is licensed under the GNU General Public License v3.0 only.
## License: URL
## Git: https://git.zaks.web.za/thisiszeev/ipuz-to-pdf
##      https://github.com/thisiszeev/ipuz-to-pdf

## What is this script?
## This script will convert a ipuz crossword file into set of PDF files.

## Why did I make this script?
## I needed to create vector file of various ipuz files as per the defined ipuz standard.
## These vector files are for use in print publications. So I need a script, that can be
## run in batch jobs. Thus the script can be executed as:
##    $ bash codeword-maker.sh {filename}.ipuz

## Where can I get software to create ipuz files?
## Crosswords: https://gitlab.gnome.org/jrb/crosswords

## Where I can learn more about the ipuz format?
## ipuz is essentially a JSON format designed for storing puzzles.
## Website: https://libipuz.org/ipuz-spec.html

## What must I do first?
## First you need to install FontConfig, Inkscape, JQ and the Ubuntu Font Family or this
## script will not run.
## FontConfig: https://www.baeldung.com/linux/find-installed-fonts-command-line
## Inkscape: https://inkscape.org/
## JQ: https://jqlang.github.io/jq/
## Ubuntu Font Family: https://design.ubuntu.com/font

## Donations & Support:
## Left for last, as usual. If you want support, you can hit me up on Reddit u/thisiszeev.
## I will try help out when I get time. But donations are a major source of my income, as
## I need to eat.

## Paypal: https://paypal.me/thisiszeev
## $5 buys me a coffee
## $10 buys me a a nice burger
## $20 buys me a bottle of wine

## If you plan to use this script for commercial use, you are free to do so, but please
## remember I put a lot of work and effort into these scripts. I kindly urge you to
## please make a donation of at least $50. You will then get priority support for a
## period of 12 months.

## SVGHEADER ARRAY
svgheader=("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<!-- Created with Crossword Maker - Copyright 2024 GypsyWolf Trading (https://gwpuzzles.co.za) -->\n\n<svg\n   width=\"" "mm\"\n   height=\"" "mm\"\n   viewBox=\"0 0 " "\"\n   version=\"1.1\"\n   id=\"crossword\"\n   xmlns=\"http://www.w3.org/2000/svg\"\n   xmlns:svg=\"http://www.w3.org/2000/svg\">")

## SVGFOOTER
svgfooter="</svg>"

## SVGCELL ARRAY AND START POSITION
svgcell=("  <rect\n     style=\"fill:" ";stroke:#000000;stroke-width:1.5;stroke-linecap:round;stroke-linejoin:round;stroke-opacity:1\"\n     width=\"20\"\n     height=\"20\"\n     x=\"" "\"\n     y=\"" "\"\n     id=\"cell" "\" />")
svgcellx="20"
svgcelly="20"

## SVGVAL ARRAY AND START POSITION
svgval=("  <text\n     style=\"font-weight:bold;font-size:15.4799px;font-family:'Ubuntu Mono';-inkscape-font-specification:'Ubuntu Mono Bold';text-align:center;text-anchor:middle;fill:#000000;stroke:none\"\n     x=\"" "\"\n     y=\"" "\"\n     id=\"val" "\">" "</text>")
svgvalx="30"
svgvaly="35"

## SVGNUM ARRAY AND START POSITION
svgnum=("  <text\n     style=\"font-weight:bold;font-size:5.52401px;font-family:'Ubuntu Condensed';text-align:left;fill:#000000;stroke:none\"\n     x=\"" "\"\n     y=\"" "\"\n     id=\"num" "\">" "</text>")
svgnumx="21"
svgnumxdec=".25"
svgnumy="25"
svgnumydec=".5"

## COLOUR PALETTE FOR FILLING CELLS
colblack="#000000"
colwhite="#FFFFFF"

## OFFSETS
offsetx="20"
offsety="20"

errorcode=""

temp=($(whereis inkscape))

if [[ $? != 0 ]]; then
  echo "Unexpected Error: whereis not found?"
  exit 3
fi

if [[ ${#temp[@]} == 1 ]]; then
  echo "Please install Inscape : https://inkscape.org/"
  errorcode="${errorcode}I"
fi

temp=($(whereis jq))

if [[ ${#temp[@]} == 1 ]]; then
  echo "Please install JQ : https://jqlang.github.io/jq/"
  errorcode="${errorcode}J"
fi

temp=($(whereis fc-match))

if [[ ${#temp[@]} == 1 ]]; then
  echo "Please install FontConfig : https://www.baeldung.com/linux/find-installed-fonts-command-line"
  errorcode="${errorcode}F"
else
  temp2=$(fc-match "Ubuntu Mono")
  if [[ $temp2 != 'UbuntuMono-R.ttf: "Ubuntu Mono" "Regular"' ]]; then
    echo "Please install Ubuntu Font Family : https://design.ubuntu.com/font"
    errorcode="${errorcode}U"
  fi
fi

if [[ ! -z $errorcode ]] || [[ $errorcode != "" ]]; then
  exit 2
fi

if [[ -z $1 ]] || [[ $1 == "" ]]; then
  echo "Usage:"
  echo "    $ bash codeword-maker.sh {puzzlefile}.ipuz"
  exit 1
fi

puzzlename="$1"

width=$(jq -r ".dimensions.width" "$puzzlename")
height=$(jq -r ".dimensions.height" "$puzzlename")
block=$(jq -r ".block" "$puzzlename")
empty=$(jq -r ".empty" "$puzzlename")

echo "Puzzle is $width by $height in size!"

declare -A gridarray
declare -A valuearray

echo "Loading Grid..."

for ((y=0; y<$height; y++)); do
  for ((x=0; x<$width; x++)); do
    #gridarray[$x,$y]=$(jq -r ".puzzle[$y][$x]" "$puzzlename")
    valuearray[$x,$y]=$(jq -r ".solution[$y][$x]" "$puzzlename")
    #echo "$x, $y = ${gridarray[$x,$y]} = ${valuearray[$x,$y]}"
  done
done

echo "Puzzle Data:"

for ((y=0; y<$height; y++)); do
  for ((x=0; x<$width; x++)); do
    if [[ ${valuearray[$x,$y]} == "null" ]]; then
      echo -n "  "
    else
      echo -n " ${valuearray[$x,$y]}"
    fi
  done
  echo
done

echo "Converting letters to numbers..."

string=""

for ((y=0; y<$height; y++)); do
  for ((x=0; x<$width; x++)); do
    if [[ ${valuearray[$x,$y]} != "null" ]]; then
      test=$(echo "$string" | grep ${valuearray[$x,$y]})
      if [[ -z $test ]] || [[ $test == "" ]]; then
        string=$string${valuearray[$x,$y]}
      fi
      gridarray[$x,$y]=$(expr index "$string" ${valuearray[$x,$y]})
    else
      gridarray[$x,$y]=$block
    fi
  done
done

ongrid=${#string}

echo "$ongrid - $string"

randnum[0]=$(((RANDOM%$ongrid)+1))
randnum[1]=${randnum[0]}
while [[ ${randnum[0]} == ${randnum[1]} ]]; do
  randnum[1]=$(((RANDOM%$ongrid)+1))
done
randnum[2]=${randnum[0]}
while [[ ${randnum[0]} == ${randnum[2]} ]] || [[ ${randnum[1]} == ${randnum[2]} ]]; do
  randnum[2]=$(((RANDOM%$ongrid)+1))
done

for ((c=0; c<3; c++)); do
  echo "${randnum[$c]} - ${string:$((randnum[$c]-1)):1}"
done

echo "Building SVG Files..."

pagex=$((width * offsetx + offsetx + offsetx))
pagey=$((height * offsety + offsety + offsety))

outputfile="CodeWord-${puzzlename%.*}"

echo -e "${svgheader[0]}$pagex${svgheader[1]}$pagey${svgheader[2]}$pagex $pagey${svgheader[3]}" > "$outputfile.puzzle.svg"
echo -e "${svgheader[0]}$pagex${svgheader[1]}$pagey${svgheader[2]}$pagex $pagey${svgheader[3]}" > "$outputfile.solution.svg"
echo -e "${svgheader[0]}300${svgheader[1]}80${svgheader[2]}300 80${svgheader[3]}" > "$outputfile.legendbottom.svg"
echo -e "${svgheader[0]}80${svgheader[1]}300${svgheader[2]}80 300${svgheader[3]}" > "$outputfile.legendside.svg"

for ((n=0; n<13; n++)); do
  if [[ $n -lt $ongrid ]]; then
    echo -e "${svgcell[0]}$colwhite${svgcell[1]}$((n*20+svgcellx))${svgcell[2]}$((svgcelly))${svgcell[3]}leg$((n+1))${svgcell[4]}" >> "$outputfile.legendbottom.svg"
    echo -e "${svgcell[0]}$colwhite${svgcell[1]}$((svgcellx))${svgcell[2]}$((n*20+svgcelly))${svgcell[3]}leg$((n+1))${svgcell[4]}" >> "$outputfile.legendside.svg"
    echo -e "${svgnum[0]}$((n*20+svgnumx))$svgnumxdec${svgnum[1]}$((svgnumy))$svgnumydec${svgnum[2]}leg$((n+1))${svgnum[3]}$((n+1))${svgnum[4]}" >> "$outputfile.legendbottom.svg"
    echo -e "${svgnum[0]}$((svgnumx))$svgnumxdec${svgnum[1]}$((n*20+svgnumy))$svgnumydec${svgnum[2]}leg$((n+1))${svgnum[3]}$((n+1))${svgnum[4]}" >> "$outputfile.legendside.svg"
    for ((c=0; c<3; c++)); do
      if [[ $((n+1)) == ${randnum[$c]} ]]; then
        echo -e "${svgval[0]}$((n*20+svgvalx))${svgval[1]}$((svgvaly))${svgval[2]}leg$((n+1))${svgval[3]}${string:$n:1}${svgval[4]}" >> "$outputfile.legendbottom.svg"
        echo -e "${svgval[0]}$((svgvalx))${svgval[1]}$((n*20+svgvaly))${svgval[2]}leg$((n+1))${svgval[3]}${string:$n:1}${svgval[4]}" >> "$outputfile.legendside.svg"
      fi
    done
  else
    echo -e "${svgcell[0]}$colblack${svgcell[1]}$((n*20+svgcellx))${svgcell[2]}$((svgcelly))${svgcell[3]}leg$((n+1))${svgcell[4]}" >> "$outputfile.legendbottom.svg"
    echo -e "${svgcell[0]}$colblack${svgcell[1]}$((svgcellx))${svgcell[2]}$((n*20+svgcelly))${svgcell[3]}leg$((n+1))${svgcell[4]}" >> "$outputfile.legendside.svg"
  fi
done

for ((n=0; n<13; n++)); do
  if [[ $((n+13)) -lt $ongrid ]]; then
    echo -e "${svgcell[0]}$colwhite${svgcell[1]}$((n*20+svgcellx))${svgcell[2]}$((20+svgcelly))${svgcell[3]}leg$((n+14))${svgcell[4]}" >> "$outputfile.legendbottom.svg"
    echo -e "${svgcell[0]}$colwhite${svgcell[1]}$((20+svgcellx))${svgcell[2]}$((n*20+svgcelly))${svgcell[3]}leg$((n+14))${svgcell[4]}" >> "$outputfile.legendside.svg"
    echo -e "${svgnum[0]}$((n*20+svgnumx))$svgnumxdec${svgnum[1]}$((20+svgnumy))$svgnumydec${svgnum[2]}leg$((n+14))${svgnum[3]}$((n+14))${svgnum[4]}" >> "$outputfile.legendbottom.svg"
    echo -e "${svgnum[0]}$((20+svgnumx))$svgnumxdec${svgnum[1]}$((n*20+svgnumy))$svgnumydec${svgnum[2]}leg$((n+14))${svgnum[3]}$((n+14))${svgnum[4]}" >> "$outputfile.legendside.svg"
    for ((c=0; c<3; c++)); do
      if [[ $((n+14)) == ${randnum[$c]} ]]; then
        echo -e "${svgval[0]}$((n*20+svgvalx))${svgval[1]}$((20+svgvaly))${svgval[2]}leg$((n+14))${svgval[3]}${string:$((n+13)):1}${svgval[4]}" >> "$outputfile.legendbottom.svg"
        echo -e "${svgval[0]}$((20+svgvalx))${svgval[1]}$((n*20+svgvaly))${svgval[2]}leg$((n+14))${svgval[3]}${string:$((n+13)):1}${svgval[4]}" >> "$outputfile.legendside.svg"
      fi
    done
  else
    echo -e "${svgcell[0]}$colblack${svgcell[1]}$((n*20+svgcellx))${svgcell[2]}$((20+svgcelly))${svgcell[3]}leg$((n+14))${svgcell[4]}" >> "$outputfile.legendbottom.svg"
    echo -e "${svgcell[0]}$colblack${svgcell[1]}$((20+svgcellx))${svgcell[2]}$((n*20+svgcelly))${svgcell[3]}leg$((n+14))${svgcell[4]}" >> "$outputfile.legendside.svg"
  fi
done

for ((y=0; y<$height; y++)); do
  if [[ $y -lt 10 ]]; then
    idy="0$y"
  else
    idy="$y"
  fi
  for ((x=0; x<$width; x++)); do
    if [[ $x -lt 10 ]]; then
      idx="0$x"
    else
      idx="$x"
    fi
    if [[ ${gridarray[$x,$y]} == $block ]]; then
      echo -e "${svgcell[0]}$colblack${svgcell[1]}$((x*20+svgcellx))${svgcell[2]}$((y*20+svgcelly))${svgcell[3]}$idx$idy${svgcell[4]}" >> "$outputfile.puzzle.svg"
      echo -e "${svgcell[0]}$colblack${svgcell[1]}$((x*20+svgcellx))${svgcell[2]}$((y*20+svgcelly))${svgcell[3]}$idx$idy${svgcell[4]}" >> "$outputfile.solution.svg"
    else
      echo -e "${svgcell[0]}$colwhite${svgcell[1]}$((x*20+svgcellx))${svgcell[2]}$((y*20+svgcelly))${svgcell[3]}$idx$idy${svgcell[4]}" >> "$outputfile.puzzle.svg"
      echo -e "${svgcell[0]}$colwhite${svgcell[1]}$((x*20+svgcellx))${svgcell[2]}$((y*20+svgcelly))${svgcell[3]}$idx$idy${svgcell[4]}" >> "$outputfile.solution.svg"
      if [[ ${gridarray[$x,$y]} != $block ]] && [[ ${gridarray[$x,$y]} != $empty ]]; then
        echo -e "${svgnum[0]}$((x*20+svgnumx))$svgnumxdec${svgnum[1]}$((y*20+svgnumy))$svgnumydec${svgnum[2]}$idx$idy${svgnum[3]}${gridarray[$x,$y]}${svgnum[4]}" >> "$outputfile.puzzle.svg"
        echo -e "${svgnum[0]}$((x*20+svgnumx))$svgnumxdec${svgnum[1]}$((y*20+svgnumy))$svgnumydec${svgnum[2]}$idx$idy${svgnum[3]}${gridarray[$x,$y]}${svgnum[4]}" >> "$outputfile.solution.svg"
      fi
      for ((c=0; c<3; c++)); do
        if [[ ${gridarray[$x,$y]} == ${randnum[$c]} ]]; then
          echo -e "${svgval[0]}$((x*20+svgvalx))${svgval[1]}$((y*20+svgvaly))${svgval[2]}$idx$idy${svgval[3]}${valuearray[$x,$y]}${svgval[4]}" >> "$outputfile.puzzle.svg"
        fi
      done
      echo -e "${svgval[0]}$((x*20+svgvalx))${svgval[1]}$((y*20+svgvaly))${svgval[2]}$idx$idy${svgval[3]}${valuearray[$x,$y]}${svgval[4]}" >> "$outputfile.solution.svg"
    fi
  done
done

echo -e "$svgfooter" >> "$outputfile.puzzle.svg"
echo -e "$svgfooter" >> "$outputfile.solution.svg"
echo -e "$svgfooter" >> "$outputfile.legendbottom.svg"
echo -e "$svgfooter" >> "$outputfile.legendside.svg"

echo "Converting SVG files to PDF files..."

inkscape "$outputfile.puzzle.svg" --export-filename="$outputfile.puzzle.pdf" --export-area-drawing --export-type=pdf --export-text-to-path
inkscape "$outputfile.solution.svg" --export-filename="$outputfile.solution.pdf" --export-area-drawing --export-type=pdf --export-text-to-path
inkscape "$outputfile.legendbottom.svg" --export-filename="$outputfile.legendbottom.pdf" --export-area-drawing --export-type=pdf --export-text-to-path
inkscape "$outputfile.legendside.svg" --export-filename="$outputfile.legendside.pdf" --export-area-drawing --export-type=pdf --export-text-to-path

echo "Cleaning up..."

rm "$outputfile.puzzle.svg" "$outputfile.solution.svg" "$outputfile.legendbottom.svg" "$outputfile.legendside.svg"

echo "DONE!!!"
