"""
Collect cmd line args for processing and file access
Return: 2 file handles
"""

function getfilenames()
	if sizeof(ARGS) > 0

		rdname = ARGS[1]
		wrname = ARGS[2]
	else
		println("2 file names required. Exiting.")
		exit(-1)
  end

		x = open(rdname, "r")
		y = open(wrname, "w")
    return x, y
end

##############################################################################
# Call to format the REMI GDP table to csv
#
##############################################################################
function newstr(fhobj, fileout)
  for line in eachline(fhobj)
	  if line == "\n" 
			continue
		end

    # Convert each line of text to a comma separated string
    # Filter out Dollar format ($ with , in number) and other characters
		fltr = Regex("(\\\$|,|\(|\)|\\n|)") # Nifty regex filter
		line = replace(line, fltr, "")  # Remove unwanted characters

    # Separate the text only string in first column
    textStrObj = match(r"[a-z-; ]+\s+"i, line )
		textStr = textStrObj.match  # access and store substring
		textStr = strip(textStr) # Remove the trailing white space

    # Now process the numeric values in vector
    numStrObj = match(r"([+-]?\d+\s+){4,}", line ) # Match up to 4 number fields
		numStr = numStrObj.match  # access and store substring
		numStr = strip(numStr) # Remove the trailing white space
		numStr = replace(numStr, r"\s+", ",") # Comma separate the number fields
    newStr = string(textStr, ",", numStr, "\n") # Rejoin fields w/ comma sep
		print(fileout, newStr)  # Write String to file
	end
  close(fileout)
  close(fhobj)
return
end

##############################################################################
#  CSV file format import to DataFrame
#
##############################################################################
function dataframeload(x)
  dfhandle = open(x, "r")
	df = readtable(dfhandle)
	#println(df)
	#in_dollars = df * 1000000
	#println(in_dollars)
return
end

##############################################################################
# Main Program
##############################################################################

function main()
  x, y = getfilenames()
	newstr(x, y)
	dfhandle = open("tmp1.txt", "r")
	col_names=[symbol("Sector"),symbol("2020"), symbol("2025"), symbol("2030"), symbol("2035")]
	df = readtable(dfhandle, header=false, names=col_names)
  #println(head(df,4))
	#println(head(df[:Sector]))
	#println(tail(df, 3))
end
##############################################################################
#
##############################################################################
using DataFrames
#using Debug

#dataframeload(ARGS[2])
main()
exit(0)
