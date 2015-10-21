++++ +++ 7 in 0th cell
>++      2 in 2nd cell

# (debug if debug extension enabled)

Code:   Pseudo code:
>>      Move the pointer to cell2
[-]     Set cell2 to 0 
<<      Move the pointer back to cell0
[       While cell0 is not 0
  -       Subtract 1 from cell0
  >>      Move the pointer to cell2
  +       Add 1 to cell2
  <<      Move the pointer back to cell0
]       End while

# (debug if debug extension enabled)
