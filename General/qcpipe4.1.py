#
# last update: 8/16/13
# This is the Quality Check Pipeline
# By Jackie and Mikhail @ ARS USDA in Geneva, NY
#
# Input parameters:
#	filename.fastq.gz // file containing the Illumina reads
#	path			  // path to the directory to save everything, i.e., /home/username/
#	prefix            // string used in naming the files and directories
#	bcfile            // tab-delimited file containing barcodes (i.e., "barcode_id	ACGTTG")
#	R1/R2		 	  // read orientation
#
# Step 1: split the file by barcodes
# 	- do the raw read counts and y/n tallies
# Step 2: run the quality filter on each barcode bin
#	- do the filtered read counts and y/n tallies
# 	- write the read counts and y/n tallies into a file
# Step 3: trim off barcodes in each barcode bin
# Step 4: cutadapt for rcbcrcprBC in R1 and rcbcrcprAC in R2 in paired-end reads
#	- trim for reverse complement of barcode plus reverse complement of prBC if R1
#	- trim for reverse complement of barcode plus reverse complement of prAC if R2
# Step 5: quality statistics

import os
import sys

# command line arguments
seqfile = "" # the compressed raw Illumina sequencing file
path = ""    # path to the directory to save everything
prefix = ""  # needed to create directories
bcfile = ""  # the barcode file
orient = ""	 # read orientation

# these two dictionaries are written into the prefix_counts file
bc_raw = {}  # barcode key -> and a list of 3 numbers: y_count, n_count, total
bc_filt = {} # barcode key -> and a list of 3 numbers: y_count, n_count, total

# usage check
if len(sys.argv) != 6: # self is the extra argument
	print "\n USAGE: python qcpipe3.py <seq.fastq.gz> <path> <prefix> <bcfile> <R1/R2>\n"
	print " filename.fastq.gz // file containing the Illumina reads"
	print " path		   // path to the directory to save everything, i.e., /home/username/"
	print " prefix            // string used in naming the files and directories"
	print " bcfile            // tab-delimited file containing barcodes, i.e., barcode_id	ACGTTG"
	print " R1/R2		   // read orientation\n"
	sys.exit(1)
elif sys.argv[5] != "R1" and sys.argv[5] != "R2":
	print "\n cannot determine the read orientation from this:  " + sys.argv[5] 
	print " USAGE: python qcpipe3.py <seq.fastq.gz> <path> <prefix> <bcfile> <R1/R2>\n"
	print " filename.fastq.gz // file containing the Illumina reads"
	print " path		   // path to the directory to save everything, i.e., /home/username/"
	print " prefix            // string used in naming the files and directories"
	print " bcfile            // tab-delimited file containing barcodes, i.e., barcode_id	ACGTTG"
	print " R1/R2		   // read orientation\n"
	sys.exit(1)
else:
	seqfile = sys.argv[1] # the compressed raw Illumina sequencing file
	path = sys.argv[2]    # path to save everything
	prefix = sys.argv[3]  # combined path and prefix to create directories and save files
	bcfile = sys.argv[4]  # the barcode file
	orient = sys.argv[5]  # read orientation

if not path.endswith("/"):
	path = path + "/"
	
print "\n\n input file: " + seqfile
print " prefix: " + prefix
print " path: " + path
print " barcode file: " + bcfile
print " read orientation: " + orient + "\n"

print " ('_')/"
print "<( . )"
print " /   \\"
print ""
print "\('o')/"
print " ( . )"
print " /   \\"
print ""
print "\('_')"
print " ( . )~"
print " /   \\"
print ""

# create all necessary directories
os.system("mkdir " + path + prefix + "_split") # files split by barcode
os.system("mkdir " + path + prefix + "_filt")  # files filtered for quality
os.system("mkdir " + path + prefix + "_trim")  # files with barcodes trimmed
os.system("mkdir " + path + prefix + "_cut")   # files with cutadapted cutadaptors
os.system("mkdir " + path + prefix + "_stats") # quality stats files

# read the barcode file and save the contents into a dictionary
# the barcode identifiers are then used to access the files created by the barcode splitter 
barcodes = {}
if os.path.isfile(bcfile):
	try:
		barcode_file = open(bcfile, "r")
		contents = barcode_file.readlines()
		barcode_file.close()
	except IOError:
		print " yikes! :( can't open the barcode file\n"
		sys.exit(1)
else:
	print " yikes! :( can't find the barcode file\n"
	sys.exit(1)
		
for line in contents:
	line = line.strip('\n')
	line_data = line.split('\t')
	barcodes.update({line_data[0]: line_data[1]})

# the result of opening and saving the barcodes 
print " stored", len(barcodes), "barcodes"


### there's some functions defined here ------------------------------------------------------ ###
### ------------------------------------------------------------------------------------------ ###

# 	The function reads through a fastq file and counts the numbers of Y's and N's at the end
# of the first line of each sequencing read. Y's mean that the reads did not pass the quality
# filtering, N's mean that they did, N's are good, Y's aren't.
# 	The function saves the results
# into two dictionaries: bc_raw and bc_filt. The flag parameter tells which files to read,
# either raw sequencing files, or the ones that have been passed through the fastx_quality_filter.
def tally(flag):
	for k, v in barcodes.items():
		filename = None
		if flag == "raw":
			filename = path + prefix + "_split/" + prefix + "_" + k + ".fq"
		elif flag == "filt":
			filename = path + prefix + "_filt/" + prefix + "_" + k + "_filt.fq"
		#print filename
		if os.path.isfile(filename):
			if os.path.getsize(filename) > 0:
				#print " ... current file: " + filename
				try:
					current_file = open(filename, "r")
					c = 0 # to count the lines
					total = 0 # to count the reads
					y_count = 0;
					n_count = 0;
					for line in current_file:
						if c == 0:
							total += 1 # increment the read counter every 4 lines
							if line.split(":")[7] == "N":
								n_count += 1
							elif line.split(":")[7] == "Y":
								y_count += 1
						if c == 3:
							c = 0 # reset the line counter
						else:
							c += 1
					current_file.close()
					if flag == "raw":
						bc_raw.update({k: [y_count, n_count, total]})
					elif flag == "filt":
						bc_filt.update({k: [y_count, n_count, total]})
					#print total, " reads in ", filename
				except IOError:
					print " yikes! :( for some reason can't open this file: ", current_file, "\n"
					continue
			else:
				continue
		else:
			continue

# The function saves the counts generated by the tally() function into a tab-delimited files. 
def write_counts():
	out = open(path + prefix + "_counts", "w")
	
	# header line
	out.write("\n" + path + prefix + "_counts")
	out.write("\nbarcode id\t" + "raw_y\t" + "raw_n\t" + "raw_t\t" + "filt_y\t" + "filt_n\t" + "filt_t\n")
	
	for k, v in barcodes.items():
		if k in bc_raw.keys() and k in bc_filt.keys():
			out.write(k + "\t" + str(bc_raw[k][0]) + "\t" + str(bc_raw[k][1]) + "\t" + str(bc_raw[k][2]) + "\t" + str(bc_filt[k][0]) + "\t" + str(bc_filt[k][1]) + "\t" + str(bc_filt[k][2]) + "\n")
		else:
			out.write(k + "\t" + "0\t0\t0\t0\t0\t0\n")
	
	out.close()

# The function returns a complement of a sequence	
def complement(sequence):
    comp = ""
    for nuc in sequence:
        if nuc == "A":
            comp += "T"
        elif nuc == "T":
            comp += "A"
        elif nuc == "C":
            comp += "G"
        elif nuc == "G":
            comp += "C"
            
    return comp

# The function returns a reverse complement of a sequence
def rev_complement(sequence):
    comp = complement(sequence)
    return comp[::-1]
	
### ------------------------------------------------------------------------------------------ ###
### ------------------------------------------------------------------------------------------ ###

		
# --------------------------------------- step 1: split the file by barcodes	
print " running fastx_barcode_splitter.pl ..."
if os.path.isfile(seqfile):
	os.system("gunzip -c " + seqfile + " | fastx_barcode_splitter.pl -prefix " + path + prefix + "_split/" + prefix + "_ -bcfile " + bcfile + " -suffix .fq -exact -bol")
else:
	print " yikes! :( can't find the Illumina sequencing file\n"
	sys.exit(1)

# do the raw read counts and y/n tallies
print " performing the raw read counts and y/n tallies ..."
tally("raw")


# --------------------------------------- step 2: run the quality filter on each barcode bin
print " running fastq_quality_filter ..."
for k, v in barcodes.items():
	filename = path + prefix + "_split/" + prefix + "_" + k + ".fq"
	if os.path.isfile(filename):
		if os.path.getsize(filename) > 0:
			#print " ... current file: " + filename
			os.system("fastq_quality_filter -Q33 -q 25 -p 25 -i " + filename + " -o " + path + prefix + "_filt/" + prefix + "_" + k + "_filt.fq")
		else:
			# this means that the initial barcode bin file created by the barcode splitter is empty
			continue
	else:
		# we shouldn't get to this point but just in case
		# this means that the file was not created by the barcode splitter
		continue

# do the filtered read counts and y/n tallies
print " performing the filtered read counts and y/n tallies ..."
tally("filt")
		
# write the read counts and y/n tallies into a file
print " writing the counts and tallies into a file ..."
write_counts()
		

# --------------------------------------- step 3: trim off barcodes in each barcode bin
print " running fastx_trimmer ... "
for k, v in barcodes.items():
	filename = path + prefix + "_filt/" + prefix + "_" + k + "_filt.fq"
	if os.path.isfile(filename):
		if os.path.getsize(filename) > 0:
			#print " ... current file: " + filename
			os.system("fastx_trimmer -Q33 -f 7 -i " + filename + " -o " + path + prefix + "_trim/" + prefix + "_" + k + "_trim.fq")
		else:
			continue
	else:
		continue

		
# --------------------------------------- step 4: cutadapt for rcbcrcprBC in R1 and rcbcrcprAC in R2 in paired-end reads 
print " running cutadapt ... "
rcprAC = "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT"
rcprBC = "AGATCGGAAGAGCGGTTCAGCAGGAATGCCGAGACCGATCTCGTATGCCGTCTTCTGCTTG"
for k, v in barcodes.items():
	filename = path + prefix + "_trim/" + prefix + "_" + k + "_trim.fq"
	if os.path.isfile(filename):
		if os.path.getsize(filename) > 0:
			#print " ... current file: " + filename
			tocut = ""
			if orient == "R1":
				tocut = rev_complement(v) + rcprBC
			elif orient == "R2":
				tocut = rev_complement(v) + rcprAC				
			os.system("cutadapt -a " + tocut + " --minimum-len 25 -O 3 " + filename + " -o " + path + prefix + "_cut/" + prefix + "_" + k + "_cut.fq")
		else:
			continue
	else:
		continue

		
# --------------------------------------- step 5: quality statistics
print " running fastx_quality_stats ... "
for k, v in barcodes.items():
	filename = path + prefix + "_cut/" + prefix + "_" + k + "_cut.fq"
	if os.path.isfile(filename):
		if os.path.getsize(filename) > 0:
			#print " ... current file: " + filename
			os.system("fastx_quality_stats -Q33 -i " + filename + " -o " + path + prefix + "_stats/" + prefix + "_" + k + "_stats.tab")
		else:
			continue
	else:
		continue

print ""
print " ('_')/"
print "<( . )"
print " /   \\"
print ""
print " ... all done :)"
