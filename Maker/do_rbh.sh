#!/bin/bash
function sortBlast {
         sort -k1,1 -k12,12gr -k11,11g -k3,3gr $1 | sort -u -k1,1 --merge > SORTED_$1
}


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration0_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration0_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration0_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration0_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration0_annotation2reference_query.outfmt6 iteration0_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration0_reference2annotation_query.outfmt6 iteration0_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration0_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration0_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration0_annotation2reference_query.outfmt6
sortBlast iteration0_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration0_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration0_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration0_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration0_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration0_annotation2reference_query.outfmt6 iteration0_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration0_reference2annotation_query.outfmt6 iteration0_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration0_annotation2reference_query.query, iteration0_annotation2reference_query.target, iteration0_annotation2reference_query.evalue, iteration0_annotation2reference_query.bit_score, iteration0_reference2annotation_query.query, iteration0_reference2annotation_query.target, iteration0_reference2annotation_query.evalue, iteration0_reference2annotation_query.bit_score
	     FROM iteration0_annotation2reference_query
	     INNER JOIN iteration0_reference2annotation_query
	     ON iteration0_annotation2reference_query.target = iteration0_reference2annotation_query.query
	     WHERE iteration0_annotation2reference_query.query = iteration0_reference2annotation_query.target;' > iteration0_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration0_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=1
#why=`printf '%02d' $ugh`

cut -f1 iteration0_annotation_to_v2.1_transcriptome.rbh > iteration0_annotation
cut -f2 iteration0_annotation_to_v2.1_transcriptome.rbh > iteration0_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration0_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration0_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration0_annotation iteration0_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration0_reference iteration0_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration0_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration0_annotation)
             AND target NOT IN (SELECT * FROM iteration0_reference)
             AND query NOT IN (SELECT * FROM iteration0_reference)
             AND query NOT IN (SELECT * FROM iteration0_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration0_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration0_annotation)
             AND target NOT IN (SELECT * FROM iteration0_reference)
             AND query NOT IN (SELECT * FROM iteration0_reference)
             AND query NOT IN (SELECT * FROM iteration0_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration1_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration1_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration1_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration1_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration1_annotation2reference_query.outfmt6 iteration1_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration1_reference2annotation_query.outfmt6 iteration1_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration1_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration1_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration1_annotation2reference_query.outfmt6
sortBlast iteration1_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration1_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration1_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration1_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration1_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration1_annotation2reference_query.outfmt6 iteration1_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration1_reference2annotation_query.outfmt6 iteration1_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration1_annotation2reference_query.query, iteration1_annotation2reference_query.target, iteration1_annotation2reference_query.evalue, iteration1_annotation2reference_query.bit_score, iteration1_reference2annotation_query.query, iteration1_reference2annotation_query.target, iteration1_reference2annotation_query.evalue, iteration1_reference2annotation_query.bit_score
	     FROM iteration1_annotation2reference_query
	     INNER JOIN iteration1_reference2annotation_query
	     ON iteration1_annotation2reference_query.target = iteration1_reference2annotation_query.query
	     WHERE iteration1_annotation2reference_query.query = iteration1_reference2annotation_query.target;' > iteration1_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration1_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=2
#why=`printf '%02d' $ugh`

cut -f1 iteration1_annotation_to_v2.1_transcriptome.rbh > iteration1_annotation
cut -f2 iteration1_annotation_to_v2.1_transcriptome.rbh > iteration1_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration1_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration1_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration1_annotation iteration1_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration1_reference iteration1_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration1_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration1_annotation)
             AND target NOT IN (SELECT * FROM iteration1_reference)
             AND query NOT IN (SELECT * FROM iteration1_reference)
             AND query NOT IN (SELECT * FROM iteration1_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration1_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration1_annotation)
             AND target NOT IN (SELECT * FROM iteration1_reference)
             AND query NOT IN (SELECT * FROM iteration1_reference)
             AND query NOT IN (SELECT * FROM iteration1_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration2_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration2_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration2_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration2_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration2_annotation2reference_query.outfmt6 iteration2_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration2_reference2annotation_query.outfmt6 iteration2_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration2_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration2_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration2_annotation2reference_query.outfmt6
sortBlast iteration2_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration2_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration2_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration2_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration2_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration2_annotation2reference_query.outfmt6 iteration2_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration2_reference2annotation_query.outfmt6 iteration2_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration2_annotation2reference_query.query, iteration2_annotation2reference_query.target, iteration2_annotation2reference_query.evalue, iteration2_annotation2reference_query.bit_score, iteration2_reference2annotation_query.query, iteration2_reference2annotation_query.target, iteration2_reference2annotation_query.evalue, iteration2_reference2annotation_query.bit_score
	     FROM iteration2_annotation2reference_query
	     INNER JOIN iteration2_reference2annotation_query
	     ON iteration2_annotation2reference_query.target = iteration2_reference2annotation_query.query
	     WHERE iteration2_annotation2reference_query.query = iteration2_reference2annotation_query.target;' > iteration2_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration2_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=3
#why=`printf '%02d' $ugh`

cut -f1 iteration2_annotation_to_v2.1_transcriptome.rbh > iteration2_annotation
cut -f2 iteration2_annotation_to_v2.1_transcriptome.rbh > iteration2_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration2_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration2_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration2_annotation iteration2_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration2_reference iteration2_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration2_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration2_annotation)
             AND target NOT IN (SELECT * FROM iteration2_reference)
             AND query NOT IN (SELECT * FROM iteration2_reference)
             AND query NOT IN (SELECT * FROM iteration2_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration2_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration2_annotation)
             AND target NOT IN (SELECT * FROM iteration2_reference)
             AND query NOT IN (SELECT * FROM iteration2_reference)
             AND query NOT IN (SELECT * FROM iteration2_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration3_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration3_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration3_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration3_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration3_annotation2reference_query.outfmt6 iteration3_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration3_reference2annotation_query.outfmt6 iteration3_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration3_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration3_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration3_annotation2reference_query.outfmt6
sortBlast iteration3_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration3_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration3_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration3_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration3_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration3_annotation2reference_query.outfmt6 iteration3_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration3_reference2annotation_query.outfmt6 iteration3_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration3_annotation2reference_query.query, iteration3_annotation2reference_query.target, iteration3_annotation2reference_query.evalue, iteration3_annotation2reference_query.bit_score, iteration3_reference2annotation_query.query, iteration3_reference2annotation_query.target, iteration3_reference2annotation_query.evalue, iteration3_reference2annotation_query.bit_score
	     FROM iteration3_annotation2reference_query
	     INNER JOIN iteration3_reference2annotation_query
	     ON iteration3_annotation2reference_query.target = iteration3_reference2annotation_query.query
	     WHERE iteration3_annotation2reference_query.query = iteration3_reference2annotation_query.target;' > iteration3_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration3_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=4
#why=`printf '%02d' $ugh`

cut -f1 iteration3_annotation_to_v2.1_transcriptome.rbh > iteration3_annotation
cut -f2 iteration3_annotation_to_v2.1_transcriptome.rbh > iteration3_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration3_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration3_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration3_annotation iteration3_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration3_reference iteration3_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration3_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration3_annotation)
             AND target NOT IN (SELECT * FROM iteration3_reference)
             AND query NOT IN (SELECT * FROM iteration3_reference)
             AND query NOT IN (SELECT * FROM iteration3_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration3_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration3_annotation)
             AND target NOT IN (SELECT * FROM iteration3_reference)
             AND query NOT IN (SELECT * FROM iteration3_reference)
             AND query NOT IN (SELECT * FROM iteration3_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration4_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration4_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration4_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration4_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration4_annotation2reference_query.outfmt6 iteration4_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration4_reference2annotation_query.outfmt6 iteration4_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration4_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration4_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration4_annotation2reference_query.outfmt6
sortBlast iteration4_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration4_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration4_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration4_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration4_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration4_annotation2reference_query.outfmt6 iteration4_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration4_reference2annotation_query.outfmt6 iteration4_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration4_annotation2reference_query.query, iteration4_annotation2reference_query.target, iteration4_annotation2reference_query.evalue, iteration4_annotation2reference_query.bit_score, iteration4_reference2annotation_query.query, iteration4_reference2annotation_query.target, iteration4_reference2annotation_query.evalue, iteration4_reference2annotation_query.bit_score
	     FROM iteration4_annotation2reference_query
	     INNER JOIN iteration4_reference2annotation_query
	     ON iteration4_annotation2reference_query.target = iteration4_reference2annotation_query.query
	     WHERE iteration4_annotation2reference_query.query = iteration4_reference2annotation_query.target;' > iteration4_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration4_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=5
#why=`printf '%02d' $ugh`

cut -f1 iteration4_annotation_to_v2.1_transcriptome.rbh > iteration4_annotation
cut -f2 iteration4_annotation_to_v2.1_transcriptome.rbh > iteration4_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration4_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration4_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration4_annotation iteration4_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration4_reference iteration4_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration4_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration4_annotation)
             AND target NOT IN (SELECT * FROM iteration4_reference)
             AND query NOT IN (SELECT * FROM iteration4_reference)
             AND query NOT IN (SELECT * FROM iteration4_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration4_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration4_annotation)
             AND target NOT IN (SELECT * FROM iteration4_reference)
             AND query NOT IN (SELECT * FROM iteration4_reference)
             AND query NOT IN (SELECT * FROM iteration4_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration5_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration5_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration5_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration5_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration5_annotation2reference_query.outfmt6 iteration5_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration5_reference2annotation_query.outfmt6 iteration5_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration5_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration5_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration5_annotation2reference_query.outfmt6
sortBlast iteration5_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration5_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration5_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration5_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration5_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration5_annotation2reference_query.outfmt6 iteration5_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration5_reference2annotation_query.outfmt6 iteration5_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration5_annotation2reference_query.query, iteration5_annotation2reference_query.target, iteration5_annotation2reference_query.evalue, iteration5_annotation2reference_query.bit_score, iteration5_reference2annotation_query.query, iteration5_reference2annotation_query.target, iteration5_reference2annotation_query.evalue, iteration5_reference2annotation_query.bit_score
	     FROM iteration5_annotation2reference_query
	     INNER JOIN iteration5_reference2annotation_query
	     ON iteration5_annotation2reference_query.target = iteration5_reference2annotation_query.query
	     WHERE iteration5_annotation2reference_query.query = iteration5_reference2annotation_query.target;' > iteration5_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration5_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=6
#why=`printf '%02d' $ugh`

cut -f1 iteration5_annotation_to_v2.1_transcriptome.rbh > iteration5_annotation
cut -f2 iteration5_annotation_to_v2.1_transcriptome.rbh > iteration5_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration5_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration5_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration5_annotation iteration5_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration5_reference iteration5_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration5_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration5_annotation)
             AND target NOT IN (SELECT * FROM iteration5_reference)
             AND query NOT IN (SELECT * FROM iteration5_reference)
             AND query NOT IN (SELECT * FROM iteration5_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration5_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration5_annotation)
             AND target NOT IN (SELECT * FROM iteration5_reference)
             AND query NOT IN (SELECT * FROM iteration5_reference)
             AND query NOT IN (SELECT * FROM iteration5_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration6_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration6_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration6_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration6_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration6_annotation2reference_query.outfmt6 iteration6_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration6_reference2annotation_query.outfmt6 iteration6_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration6_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration6_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration6_annotation2reference_query.outfmt6
sortBlast iteration6_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration6_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration6_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration6_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration6_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration6_annotation2reference_query.outfmt6 iteration6_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration6_reference2annotation_query.outfmt6 iteration6_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration6_annotation2reference_query.query, iteration6_annotation2reference_query.target, iteration6_annotation2reference_query.evalue, iteration6_annotation2reference_query.bit_score, iteration6_reference2annotation_query.query, iteration6_reference2annotation_query.target, iteration6_reference2annotation_query.evalue, iteration6_reference2annotation_query.bit_score
	     FROM iteration6_annotation2reference_query
	     INNER JOIN iteration6_reference2annotation_query
	     ON iteration6_annotation2reference_query.target = iteration6_reference2annotation_query.query
	     WHERE iteration6_annotation2reference_query.query = iteration6_reference2annotation_query.target;' > iteration6_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration6_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=7
#why=`printf '%02d' $ugh`

cut -f1 iteration6_annotation_to_v2.1_transcriptome.rbh > iteration6_annotation
cut -f2 iteration6_annotation_to_v2.1_transcriptome.rbh > iteration6_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration6_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration6_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration6_annotation iteration6_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration6_reference iteration6_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration6_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration6_annotation)
             AND target NOT IN (SELECT * FROM iteration6_reference)
             AND query NOT IN (SELECT * FROM iteration6_reference)
             AND query NOT IN (SELECT * FROM iteration6_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration6_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration6_annotation)
             AND target NOT IN (SELECT * FROM iteration6_reference)
             AND query NOT IN (SELECT * FROM iteration6_reference)
             AND query NOT IN (SELECT * FROM iteration6_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration7_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration7_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration7_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration7_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration7_annotation2reference_query.outfmt6 iteration7_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration7_reference2annotation_query.outfmt6 iteration7_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration7_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration7_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration7_annotation2reference_query.outfmt6
sortBlast iteration7_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration7_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration7_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration7_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration7_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration7_annotation2reference_query.outfmt6 iteration7_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration7_reference2annotation_query.outfmt6 iteration7_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration7_annotation2reference_query.query, iteration7_annotation2reference_query.target, iteration7_annotation2reference_query.evalue, iteration7_annotation2reference_query.bit_score, iteration7_reference2annotation_query.query, iteration7_reference2annotation_query.target, iteration7_reference2annotation_query.evalue, iteration7_reference2annotation_query.bit_score
	     FROM iteration7_annotation2reference_query
	     INNER JOIN iteration7_reference2annotation_query
	     ON iteration7_annotation2reference_query.target = iteration7_reference2annotation_query.query
	     WHERE iteration7_annotation2reference_query.query = iteration7_reference2annotation_query.target;' > iteration7_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration7_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=8
#why=`printf '%02d' $ugh`

cut -f1 iteration7_annotation_to_v2.1_transcriptome.rbh > iteration7_annotation
cut -f2 iteration7_annotation_to_v2.1_transcriptome.rbh > iteration7_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration7_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration7_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration7_annotation iteration7_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration7_reference iteration7_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration7_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration7_annotation)
             AND target NOT IN (SELECT * FROM iteration7_reference)
             AND query NOT IN (SELECT * FROM iteration7_reference)
             AND query NOT IN (SELECT * FROM iteration7_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration7_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration7_annotation)
             AND target NOT IN (SELECT * FROM iteration7_reference)
             AND query NOT IN (SELECT * FROM iteration7_reference)
             AND query NOT IN (SELECT * FROM iteration7_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration8_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration8_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration8_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration8_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration8_annotation2reference_query.outfmt6 iteration8_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration8_reference2annotation_query.outfmt6 iteration8_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration8_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration8_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration8_annotation2reference_query.outfmt6
sortBlast iteration8_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration8_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration8_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration8_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration8_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration8_annotation2reference_query.outfmt6 iteration8_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration8_reference2annotation_query.outfmt6 iteration8_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration8_annotation2reference_query.query, iteration8_annotation2reference_query.target, iteration8_annotation2reference_query.evalue, iteration8_annotation2reference_query.bit_score, iteration8_reference2annotation_query.query, iteration8_reference2annotation_query.target, iteration8_reference2annotation_query.evalue, iteration8_reference2annotation_query.bit_score
	     FROM iteration8_annotation2reference_query
	     INNER JOIN iteration8_reference2annotation_query
	     ON iteration8_annotation2reference_query.target = iteration8_reference2annotation_query.query
	     WHERE iteration8_annotation2reference_query.query = iteration8_reference2annotation_query.target;' > iteration8_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration8_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=9
#why=`printf '%02d' $ugh`

cut -f1 iteration8_annotation_to_v2.1_transcriptome.rbh > iteration8_annotation
cut -f2 iteration8_annotation_to_v2.1_transcriptome.rbh > iteration8_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration8_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration8_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration8_annotation iteration8_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration8_reference iteration8_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration8_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration8_annotation)
             AND target NOT IN (SELECT * FROM iteration8_reference)
             AND query NOT IN (SELECT * FROM iteration8_reference)
             AND query NOT IN (SELECT * FROM iteration8_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration8_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration8_annotation)
             AND target NOT IN (SELECT * FROM iteration8_reference)
             AND query NOT IN (SELECT * FROM iteration8_reference)
             AND query NOT IN (SELECT * FROM iteration8_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration9_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration9_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration9_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration9_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration9_annotation2reference_query.outfmt6 iteration9_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration9_reference2annotation_query.outfmt6 iteration9_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration9_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration9_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration9_annotation2reference_query.outfmt6
sortBlast iteration9_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration9_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration9_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration9_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration9_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration9_annotation2reference_query.outfmt6 iteration9_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration9_reference2annotation_query.outfmt6 iteration9_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration9_annotation2reference_query.query, iteration9_annotation2reference_query.target, iteration9_annotation2reference_query.evalue, iteration9_annotation2reference_query.bit_score, iteration9_reference2annotation_query.query, iteration9_reference2annotation_query.target, iteration9_reference2annotation_query.evalue, iteration9_reference2annotation_query.bit_score
	     FROM iteration9_annotation2reference_query
	     INNER JOIN iteration9_reference2annotation_query
	     ON iteration9_annotation2reference_query.target = iteration9_reference2annotation_query.query
	     WHERE iteration9_annotation2reference_query.query = iteration9_reference2annotation_query.target;' > iteration9_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration9_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=10
#why=`printf '%02d' $ugh`

cut -f1 iteration9_annotation_to_v2.1_transcriptome.rbh > iteration9_annotation
cut -f2 iteration9_annotation_to_v2.1_transcriptome.rbh > iteration9_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration9_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration9_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration9_annotation iteration9_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration9_reference iteration9_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration9_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration9_annotation)
             AND target NOT IN (SELECT * FROM iteration9_reference)
             AND query NOT IN (SELECT * FROM iteration9_reference)
             AND query NOT IN (SELECT * FROM iteration9_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration9_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration9_annotation)
             AND target NOT IN (SELECT * FROM iteration9_reference)
             AND query NOT IN (SELECT * FROM iteration9_reference)
             AND query NOT IN (SELECT * FROM iteration9_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration10_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration10_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration10_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration10_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration10_annotation2reference_query.outfmt6 iteration10_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration10_reference2annotation_query.outfmt6 iteration10_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration10_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration10_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration10_annotation2reference_query.outfmt6
sortBlast iteration10_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration10_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration10_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration10_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration10_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration10_annotation2reference_query.outfmt6 iteration10_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration10_reference2annotation_query.outfmt6 iteration10_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration10_annotation2reference_query.query, iteration10_annotation2reference_query.target, iteration10_annotation2reference_query.evalue, iteration10_annotation2reference_query.bit_score, iteration10_reference2annotation_query.query, iteration10_reference2annotation_query.target, iteration10_reference2annotation_query.evalue, iteration10_reference2annotation_query.bit_score
	     FROM iteration10_annotation2reference_query
	     INNER JOIN iteration10_reference2annotation_query
	     ON iteration10_annotation2reference_query.target = iteration10_reference2annotation_query.query
	     WHERE iteration10_annotation2reference_query.query = iteration10_reference2annotation_query.target;' > iteration10_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration10_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=11
#why=`printf '%02d' $ugh`

cut -f1 iteration10_annotation_to_v2.1_transcriptome.rbh > iteration10_annotation
cut -f2 iteration10_annotation_to_v2.1_transcriptome.rbh > iteration10_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration10_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration10_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration10_annotation iteration10_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration10_reference iteration10_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration10_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration10_annotation)
             AND target NOT IN (SELECT * FROM iteration10_reference)
             AND query NOT IN (SELECT * FROM iteration10_reference)
             AND query NOT IN (SELECT * FROM iteration10_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration10_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration10_annotation)
             AND target NOT IN (SELECT * FROM iteration10_reference)
             AND query NOT IN (SELECT * FROM iteration10_reference)
             AND query NOT IN (SELECT * FROM iteration10_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration11_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration11_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration11_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration11_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration11_annotation2reference_query.outfmt6 iteration11_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration11_reference2annotation_query.outfmt6 iteration11_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration11_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration11_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration11_annotation2reference_query.outfmt6
sortBlast iteration11_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration11_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration11_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration11_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration11_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration11_annotation2reference_query.outfmt6 iteration11_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration11_reference2annotation_query.outfmt6 iteration11_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration11_annotation2reference_query.query, iteration11_annotation2reference_query.target, iteration11_annotation2reference_query.evalue, iteration11_annotation2reference_query.bit_score, iteration11_reference2annotation_query.query, iteration11_reference2annotation_query.target, iteration11_reference2annotation_query.evalue, iteration11_reference2annotation_query.bit_score
	     FROM iteration11_annotation2reference_query
	     INNER JOIN iteration11_reference2annotation_query
	     ON iteration11_annotation2reference_query.target = iteration11_reference2annotation_query.query
	     WHERE iteration11_annotation2reference_query.query = iteration11_reference2annotation_query.target;' > iteration11_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration11_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=12
#why=`printf '%02d' $ugh`

cut -f1 iteration11_annotation_to_v2.1_transcriptome.rbh > iteration11_annotation
cut -f2 iteration11_annotation_to_v2.1_transcriptome.rbh > iteration11_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration11_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration11_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration11_annotation iteration11_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration11_reference iteration11_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration11_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration11_annotation)
             AND target NOT IN (SELECT * FROM iteration11_reference)
             AND query NOT IN (SELECT * FROM iteration11_reference)
             AND query NOT IN (SELECT * FROM iteration11_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration11_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration11_annotation)
             AND target NOT IN (SELECT * FROM iteration11_reference)
             AND query NOT IN (SELECT * FROM iteration11_reference)
             AND query NOT IN (SELECT * FROM iteration11_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration12_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration12_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration12_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration12_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration12_annotation2reference_query.outfmt6 iteration12_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration12_reference2annotation_query.outfmt6 iteration12_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration12_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration12_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration12_annotation2reference_query.outfmt6
sortBlast iteration12_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration12_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration12_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration12_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration12_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration12_annotation2reference_query.outfmt6 iteration12_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration12_reference2annotation_query.outfmt6 iteration12_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration12_annotation2reference_query.query, iteration12_annotation2reference_query.target, iteration12_annotation2reference_query.evalue, iteration12_annotation2reference_query.bit_score, iteration12_reference2annotation_query.query, iteration12_reference2annotation_query.target, iteration12_reference2annotation_query.evalue, iteration12_reference2annotation_query.bit_score
	     FROM iteration12_annotation2reference_query
	     INNER JOIN iteration12_reference2annotation_query
	     ON iteration12_annotation2reference_query.target = iteration12_reference2annotation_query.query
	     WHERE iteration12_annotation2reference_query.query = iteration12_reference2annotation_query.target;' > iteration12_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration12_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=13
#why=`printf '%02d' $ugh`

cut -f1 iteration12_annotation_to_v2.1_transcriptome.rbh > iteration12_annotation
cut -f2 iteration12_annotation_to_v2.1_transcriptome.rbh > iteration12_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration12_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration12_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration12_annotation iteration12_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration12_reference iteration12_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration12_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration12_annotation)
             AND target NOT IN (SELECT * FROM iteration12_reference)
             AND query NOT IN (SELECT * FROM iteration12_reference)
             AND query NOT IN (SELECT * FROM iteration12_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration12_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration12_annotation)
             AND target NOT IN (SELECT * FROM iteration12_reference)
             AND query NOT IN (SELECT * FROM iteration12_reference)
             AND query NOT IN (SELECT * FROM iteration12_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration13_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration13_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration13_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration13_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration13_annotation2reference_query.outfmt6 iteration13_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration13_reference2annotation_query.outfmt6 iteration13_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration13_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration13_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration13_annotation2reference_query.outfmt6
sortBlast iteration13_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration13_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration13_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration13_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration13_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration13_annotation2reference_query.outfmt6 iteration13_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration13_reference2annotation_query.outfmt6 iteration13_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration13_annotation2reference_query.query, iteration13_annotation2reference_query.target, iteration13_annotation2reference_query.evalue, iteration13_annotation2reference_query.bit_score, iteration13_reference2annotation_query.query, iteration13_reference2annotation_query.target, iteration13_reference2annotation_query.evalue, iteration13_reference2annotation_query.bit_score
	     FROM iteration13_annotation2reference_query
	     INNER JOIN iteration13_reference2annotation_query
	     ON iteration13_annotation2reference_query.target = iteration13_reference2annotation_query.query
	     WHERE iteration13_annotation2reference_query.query = iteration13_reference2annotation_query.target;' > iteration13_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration13_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=14
#why=`printf '%02d' $ugh`

cut -f1 iteration13_annotation_to_v2.1_transcriptome.rbh > iteration13_annotation
cut -f2 iteration13_annotation_to_v2.1_transcriptome.rbh > iteration13_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration13_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration13_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration13_annotation iteration13_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration13_reference iteration13_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration13_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration13_annotation)
             AND target NOT IN (SELECT * FROM iteration13_reference)
             AND query NOT IN (SELECT * FROM iteration13_reference)
             AND query NOT IN (SELECT * FROM iteration13_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration13_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration13_annotation)
             AND target NOT IN (SELECT * FROM iteration13_reference)
             AND query NOT IN (SELECT * FROM iteration13_reference)
             AND query NOT IN (SELECT * FROM iteration13_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration14_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration14_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration14_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration14_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration14_annotation2reference_query.outfmt6 iteration14_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration14_reference2annotation_query.outfmt6 iteration14_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration14_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration14_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration14_annotation2reference_query.outfmt6
sortBlast iteration14_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration14_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration14_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration14_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration14_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration14_annotation2reference_query.outfmt6 iteration14_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration14_reference2annotation_query.outfmt6 iteration14_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration14_annotation2reference_query.query, iteration14_annotation2reference_query.target, iteration14_annotation2reference_query.evalue, iteration14_annotation2reference_query.bit_score, iteration14_reference2annotation_query.query, iteration14_reference2annotation_query.target, iteration14_reference2annotation_query.evalue, iteration14_reference2annotation_query.bit_score
	     FROM iteration14_annotation2reference_query
	     INNER JOIN iteration14_reference2annotation_query
	     ON iteration14_annotation2reference_query.target = iteration14_reference2annotation_query.query
	     WHERE iteration14_annotation2reference_query.query = iteration14_reference2annotation_query.target;' > iteration14_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration14_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=15
#why=`printf '%02d' $ugh`

cut -f1 iteration14_annotation_to_v2.1_transcriptome.rbh > iteration14_annotation
cut -f2 iteration14_annotation_to_v2.1_transcriptome.rbh > iteration14_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration14_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration14_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration14_annotation iteration14_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration14_reference iteration14_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration14_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration14_annotation)
             AND target NOT IN (SELECT * FROM iteration14_reference)
             AND query NOT IN (SELECT * FROM iteration14_reference)
             AND query NOT IN (SELECT * FROM iteration14_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration14_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration14_annotation)
             AND target NOT IN (SELECT * FROM iteration14_reference)
             AND query NOT IN (SELECT * FROM iteration14_reference)
             AND query NOT IN (SELECT * FROM iteration14_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration15_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration15_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration15_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration15_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration15_annotation2reference_query.outfmt6 iteration15_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration15_reference2annotation_query.outfmt6 iteration15_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration15_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration15_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration15_annotation2reference_query.outfmt6
sortBlast iteration15_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration15_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration15_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration15_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration15_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration15_annotation2reference_query.outfmt6 iteration15_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration15_reference2annotation_query.outfmt6 iteration15_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration15_annotation2reference_query.query, iteration15_annotation2reference_query.target, iteration15_annotation2reference_query.evalue, iteration15_annotation2reference_query.bit_score, iteration15_reference2annotation_query.query, iteration15_reference2annotation_query.target, iteration15_reference2annotation_query.evalue, iteration15_reference2annotation_query.bit_score
	     FROM iteration15_annotation2reference_query
	     INNER JOIN iteration15_reference2annotation_query
	     ON iteration15_annotation2reference_query.target = iteration15_reference2annotation_query.query
	     WHERE iteration15_annotation2reference_query.query = iteration15_reference2annotation_query.target;' > iteration15_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration15_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=16
#why=`printf '%02d' $ugh`

cut -f1 iteration15_annotation_to_v2.1_transcriptome.rbh > iteration15_annotation
cut -f2 iteration15_annotation_to_v2.1_transcriptome.rbh > iteration15_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration15_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration15_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration15_annotation iteration15_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration15_reference iteration15_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration15_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration15_annotation)
             AND target NOT IN (SELECT * FROM iteration15_reference)
             AND query NOT IN (SELECT * FROM iteration15_reference)
             AND query NOT IN (SELECT * FROM iteration15_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration15_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration15_annotation)
             AND target NOT IN (SELECT * FROM iteration15_reference)
             AND query NOT IN (SELECT * FROM iteration15_reference)
             AND query NOT IN (SELECT * FROM iteration15_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration16_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration16_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration16_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration16_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration16_annotation2reference_query.outfmt6 iteration16_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration16_reference2annotation_query.outfmt6 iteration16_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration16_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration16_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration16_annotation2reference_query.outfmt6
sortBlast iteration16_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration16_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration16_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration16_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration16_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration16_annotation2reference_query.outfmt6 iteration16_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration16_reference2annotation_query.outfmt6 iteration16_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration16_annotation2reference_query.query, iteration16_annotation2reference_query.target, iteration16_annotation2reference_query.evalue, iteration16_annotation2reference_query.bit_score, iteration16_reference2annotation_query.query, iteration16_reference2annotation_query.target, iteration16_reference2annotation_query.evalue, iteration16_reference2annotation_query.bit_score
	     FROM iteration16_annotation2reference_query
	     INNER JOIN iteration16_reference2annotation_query
	     ON iteration16_annotation2reference_query.target = iteration16_reference2annotation_query.query
	     WHERE iteration16_annotation2reference_query.query = iteration16_reference2annotation_query.target;' > iteration16_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration16_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=17
#why=`printf '%02d' $ugh`

cut -f1 iteration16_annotation_to_v2.1_transcriptome.rbh > iteration16_annotation
cut -f2 iteration16_annotation_to_v2.1_transcriptome.rbh > iteration16_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration16_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration16_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration16_annotation iteration16_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration16_reference iteration16_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration16_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration16_annotation)
             AND target NOT IN (SELECT * FROM iteration16_reference)
             AND query NOT IN (SELECT * FROM iteration16_reference)
             AND query NOT IN (SELECT * FROM iteration16_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration16_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration16_annotation)
             AND target NOT IN (SELECT * FROM iteration16_reference)
             AND query NOT IN (SELECT * FROM iteration16_reference)
             AND query NOT IN (SELECT * FROM iteration16_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration17_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration17_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration17_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration17_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration17_annotation2reference_query.outfmt6 iteration17_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration17_reference2annotation_query.outfmt6 iteration17_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration17_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration17_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration17_annotation2reference_query.outfmt6
sortBlast iteration17_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration17_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration17_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration17_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration17_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration17_annotation2reference_query.outfmt6 iteration17_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration17_reference2annotation_query.outfmt6 iteration17_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration17_annotation2reference_query.query, iteration17_annotation2reference_query.target, iteration17_annotation2reference_query.evalue, iteration17_annotation2reference_query.bit_score, iteration17_reference2annotation_query.query, iteration17_reference2annotation_query.target, iteration17_reference2annotation_query.evalue, iteration17_reference2annotation_query.bit_score
	     FROM iteration17_annotation2reference_query
	     INNER JOIN iteration17_reference2annotation_query
	     ON iteration17_annotation2reference_query.target = iteration17_reference2annotation_query.query
	     WHERE iteration17_annotation2reference_query.query = iteration17_reference2annotation_query.target;' > iteration17_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration17_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=18
#why=`printf '%02d' $ugh`

cut -f1 iteration17_annotation_to_v2.1_transcriptome.rbh > iteration17_annotation
cut -f2 iteration17_annotation_to_v2.1_transcriptome.rbh > iteration17_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration17_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration17_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration17_annotation iteration17_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration17_reference iteration17_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration17_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration17_annotation)
             AND target NOT IN (SELECT * FROM iteration17_reference)
             AND query NOT IN (SELECT * FROM iteration17_reference)
             AND query NOT IN (SELECT * FROM iteration17_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration17_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration17_annotation)
             AND target NOT IN (SELECT * FROM iteration17_reference)
             AND query NOT IN (SELECT * FROM iteration17_reference)
             AND query NOT IN (SELECT * FROM iteration17_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration18_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration18_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration18_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration18_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration18_annotation2reference_query.outfmt6 iteration18_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration18_reference2annotation_query.outfmt6 iteration18_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration18_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration18_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration18_annotation2reference_query.outfmt6
sortBlast iteration18_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration18_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration18_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration18_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration18_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration18_annotation2reference_query.outfmt6 iteration18_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration18_reference2annotation_query.outfmt6 iteration18_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration18_annotation2reference_query.query, iteration18_annotation2reference_query.target, iteration18_annotation2reference_query.evalue, iteration18_annotation2reference_query.bit_score, iteration18_reference2annotation_query.query, iteration18_reference2annotation_query.target, iteration18_reference2annotation_query.evalue, iteration18_reference2annotation_query.bit_score
	     FROM iteration18_annotation2reference_query
	     INNER JOIN iteration18_reference2annotation_query
	     ON iteration18_annotation2reference_query.target = iteration18_reference2annotation_query.query
	     WHERE iteration18_annotation2reference_query.query = iteration18_reference2annotation_query.target;' > iteration18_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration18_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=19
#why=`printf '%02d' $ugh`

cut -f1 iteration18_annotation_to_v2.1_transcriptome.rbh > iteration18_annotation
cut -f2 iteration18_annotation_to_v2.1_transcriptome.rbh > iteration18_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration18_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration18_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration18_annotation iteration18_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration18_reference iteration18_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration18_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration18_annotation)
             AND target NOT IN (SELECT * FROM iteration18_reference)
             AND query NOT IN (SELECT * FROM iteration18_reference)
             AND query NOT IN (SELECT * FROM iteration18_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration18_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration18_annotation)
             AND target NOT IN (SELECT * FROM iteration18_reference)
             AND query NOT IN (SELECT * FROM iteration18_reference)
             AND query NOT IN (SELECT * FROM iteration18_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration19_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration19_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration19_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration19_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration19_annotation2reference_query.outfmt6 iteration19_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration19_reference2annotation_query.outfmt6 iteration19_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration19_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration19_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration19_annotation2reference_query.outfmt6
sortBlast iteration19_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration19_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration19_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration19_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration19_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration19_annotation2reference_query.outfmt6 iteration19_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration19_reference2annotation_query.outfmt6 iteration19_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration19_annotation2reference_query.query, iteration19_annotation2reference_query.target, iteration19_annotation2reference_query.evalue, iteration19_annotation2reference_query.bit_score, iteration19_reference2annotation_query.query, iteration19_reference2annotation_query.target, iteration19_reference2annotation_query.evalue, iteration19_reference2annotation_query.bit_score
	     FROM iteration19_annotation2reference_query
	     INNER JOIN iteration19_reference2annotation_query
	     ON iteration19_annotation2reference_query.target = iteration19_reference2annotation_query.query
	     WHERE iteration19_annotation2reference_query.query = iteration19_reference2annotation_query.target;' > iteration19_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration19_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=20
#why=`printf '%02d' $ugh`

cut -f1 iteration19_annotation_to_v2.1_transcriptome.rbh > iteration19_annotation
cut -f2 iteration19_annotation_to_v2.1_transcriptome.rbh > iteration19_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration19_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration19_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration19_annotation iteration19_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration19_reference iteration19_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration19_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration19_annotation)
             AND target NOT IN (SELECT * FROM iteration19_reference)
             AND query NOT IN (SELECT * FROM iteration19_reference)
             AND query NOT IN (SELECT * FROM iteration19_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration19_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration19_annotation)
             AND target NOT IN (SELECT * FROM iteration19_reference)
             AND query NOT IN (SELECT * FROM iteration19_reference)
             AND query NOT IN (SELECT * FROM iteration19_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration20_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration20_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration20_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration20_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration20_annotation2reference_query.outfmt6 iteration20_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration20_reference2annotation_query.outfmt6 iteration20_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration20_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration20_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration20_annotation2reference_query.outfmt6
sortBlast iteration20_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration20_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration20_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration20_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration20_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration20_annotation2reference_query.outfmt6 iteration20_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration20_reference2annotation_query.outfmt6 iteration20_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration20_annotation2reference_query.query, iteration20_annotation2reference_query.target, iteration20_annotation2reference_query.evalue, iteration20_annotation2reference_query.bit_score, iteration20_reference2annotation_query.query, iteration20_reference2annotation_query.target, iteration20_reference2annotation_query.evalue, iteration20_reference2annotation_query.bit_score
	     FROM iteration20_annotation2reference_query
	     INNER JOIN iteration20_reference2annotation_query
	     ON iteration20_annotation2reference_query.target = iteration20_reference2annotation_query.query
	     WHERE iteration20_annotation2reference_query.query = iteration20_reference2annotation_query.target;' > iteration20_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration20_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=21
#why=`printf '%02d' $ugh`

cut -f1 iteration20_annotation_to_v2.1_transcriptome.rbh > iteration20_annotation
cut -f2 iteration20_annotation_to_v2.1_transcriptome.rbh > iteration20_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration20_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration20_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration20_annotation iteration20_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration20_reference iteration20_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration20_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration20_annotation)
             AND target NOT IN (SELECT * FROM iteration20_reference)
             AND query NOT IN (SELECT * FROM iteration20_reference)
             AND query NOT IN (SELECT * FROM iteration20_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration20_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration20_annotation)
             AND target NOT IN (SELECT * FROM iteration20_reference)
             AND query NOT IN (SELECT * FROM iteration20_reference)
             AND query NOT IN (SELECT * FROM iteration20_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration21_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration21_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration21_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration21_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration21_annotation2reference_query.outfmt6 iteration21_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration21_reference2annotation_query.outfmt6 iteration21_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration21_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration21_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration21_annotation2reference_query.outfmt6
sortBlast iteration21_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration21_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration21_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration21_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration21_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration21_annotation2reference_query.outfmt6 iteration21_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration21_reference2annotation_query.outfmt6 iteration21_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration21_annotation2reference_query.query, iteration21_annotation2reference_query.target, iteration21_annotation2reference_query.evalue, iteration21_annotation2reference_query.bit_score, iteration21_reference2annotation_query.query, iteration21_reference2annotation_query.target, iteration21_reference2annotation_query.evalue, iteration21_reference2annotation_query.bit_score
	     FROM iteration21_annotation2reference_query
	     INNER JOIN iteration21_reference2annotation_query
	     ON iteration21_annotation2reference_query.target = iteration21_reference2annotation_query.query
	     WHERE iteration21_annotation2reference_query.query = iteration21_reference2annotation_query.target;' > iteration21_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration21_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=22
#why=`printf '%02d' $ugh`

cut -f1 iteration21_annotation_to_v2.1_transcriptome.rbh > iteration21_annotation
cut -f2 iteration21_annotation_to_v2.1_transcriptome.rbh > iteration21_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration21_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration21_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration21_annotation iteration21_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration21_reference iteration21_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration21_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration21_annotation)
             AND target NOT IN (SELECT * FROM iteration21_reference)
             AND query NOT IN (SELECT * FROM iteration21_reference)
             AND query NOT IN (SELECT * FROM iteration21_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration21_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration21_annotation)
             AND target NOT IN (SELECT * FROM iteration21_reference)
             AND query NOT IN (SELECT * FROM iteration21_reference)
             AND query NOT IN (SELECT * FROM iteration21_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration22_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration22_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration22_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration22_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration22_annotation2reference_query.outfmt6 iteration22_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration22_reference2annotation_query.outfmt6 iteration22_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration22_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration22_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration22_annotation2reference_query.outfmt6
sortBlast iteration22_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration22_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration22_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration22_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration22_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration22_annotation2reference_query.outfmt6 iteration22_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration22_reference2annotation_query.outfmt6 iteration22_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration22_annotation2reference_query.query, iteration22_annotation2reference_query.target, iteration22_annotation2reference_query.evalue, iteration22_annotation2reference_query.bit_score, iteration22_reference2annotation_query.query, iteration22_reference2annotation_query.target, iteration22_reference2annotation_query.evalue, iteration22_reference2annotation_query.bit_score
	     FROM iteration22_annotation2reference_query
	     INNER JOIN iteration22_reference2annotation_query
	     ON iteration22_annotation2reference_query.target = iteration22_reference2annotation_query.query
	     WHERE iteration22_annotation2reference_query.query = iteration22_reference2annotation_query.target;' > iteration22_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration22_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=23
#why=`printf '%02d' $ugh`

cut -f1 iteration22_annotation_to_v2.1_transcriptome.rbh > iteration22_annotation
cut -f2 iteration22_annotation_to_v2.1_transcriptome.rbh > iteration22_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration22_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration22_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration22_annotation iteration22_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration22_reference iteration22_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration22_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration22_annotation)
             AND target NOT IN (SELECT * FROM iteration22_reference)
             AND query NOT IN (SELECT * FROM iteration22_reference)
             AND query NOT IN (SELECT * FROM iteration22_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration22_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration22_annotation)
             AND target NOT IN (SELECT * FROM iteration22_reference)
             AND query NOT IN (SELECT * FROM iteration22_reference)
             AND query NOT IN (SELECT * FROM iteration22_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration23_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration23_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration23_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration23_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration23_annotation2reference_query.outfmt6 iteration23_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration23_reference2annotation_query.outfmt6 iteration23_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration23_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration23_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration23_annotation2reference_query.outfmt6
sortBlast iteration23_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration23_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration23_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration23_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration23_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration23_annotation2reference_query.outfmt6 iteration23_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration23_reference2annotation_query.outfmt6 iteration23_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration23_annotation2reference_query.query, iteration23_annotation2reference_query.target, iteration23_annotation2reference_query.evalue, iteration23_annotation2reference_query.bit_score, iteration23_reference2annotation_query.query, iteration23_reference2annotation_query.target, iteration23_reference2annotation_query.evalue, iteration23_reference2annotation_query.bit_score
	     FROM iteration23_annotation2reference_query
	     INNER JOIN iteration23_reference2annotation_query
	     ON iteration23_annotation2reference_query.target = iteration23_reference2annotation_query.query
	     WHERE iteration23_annotation2reference_query.query = iteration23_reference2annotation_query.target;' > iteration23_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration23_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=24
#why=`printf '%02d' $ugh`

cut -f1 iteration23_annotation_to_v2.1_transcriptome.rbh > iteration23_annotation
cut -f2 iteration23_annotation_to_v2.1_transcriptome.rbh > iteration23_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration23_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration23_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration23_annotation iteration23_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration23_reference iteration23_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration23_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration23_annotation)
             AND target NOT IN (SELECT * FROM iteration23_reference)
             AND query NOT IN (SELECT * FROM iteration23_reference)
             AND query NOT IN (SELECT * FROM iteration23_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration23_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration23_annotation)
             AND target NOT IN (SELECT * FROM iteration23_reference)
             AND query NOT IN (SELECT * FROM iteration23_reference)
             AND query NOT IN (SELECT * FROM iteration23_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration24_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration24_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration24_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration24_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration24_annotation2reference_query.outfmt6 iteration24_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration24_reference2annotation_query.outfmt6 iteration24_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration24_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration24_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration24_annotation2reference_query.outfmt6
sortBlast iteration24_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration24_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration24_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration24_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration24_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration24_annotation2reference_query.outfmt6 iteration24_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration24_reference2annotation_query.outfmt6 iteration24_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration24_annotation2reference_query.query, iteration24_annotation2reference_query.target, iteration24_annotation2reference_query.evalue, iteration24_annotation2reference_query.bit_score, iteration24_reference2annotation_query.query, iteration24_reference2annotation_query.target, iteration24_reference2annotation_query.evalue, iteration24_reference2annotation_query.bit_score
	     FROM iteration24_annotation2reference_query
	     INNER JOIN iteration24_reference2annotation_query
	     ON iteration24_annotation2reference_query.target = iteration24_reference2annotation_query.query
	     WHERE iteration24_annotation2reference_query.query = iteration24_reference2annotation_query.target;' > iteration24_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration24_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=25
#why=`printf '%02d' $ugh`

cut -f1 iteration24_annotation_to_v2.1_transcriptome.rbh > iteration24_annotation
cut -f2 iteration24_annotation_to_v2.1_transcriptome.rbh > iteration24_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration24_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration24_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration24_annotation iteration24_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration24_reference iteration24_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration24_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration24_annotation)
             AND target NOT IN (SELECT * FROM iteration24_reference)
             AND query NOT IN (SELECT * FROM iteration24_reference)
             AND query NOT IN (SELECT * FROM iteration24_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration24_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration24_annotation)
             AND target NOT IN (SELECT * FROM iteration24_reference)
             AND query NOT IN (SELECT * FROM iteration24_reference)
             AND query NOT IN (SELECT * FROM iteration24_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6


## IMPORT ALL BLAST

sed -i 's/\t/|/g' iteration25_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' iteration25_reference2annotation_query.outfmt6

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration25_TOTAL_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration25_TOTAL_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import iteration25_annotation2reference_query.outfmt6 iteration25_TOTAL_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import iteration25_reference2annotation_query.outfmt6 iteration25_TOTAL_reference2annotation_query'

sed -i 's/|/\t/g' iteration25_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration25_reference2annotation_query.outfmt6

## SORT BLAST

sortBlast iteration25_annotation2reference_query.outfmt6
sortBlast iteration25_reference2annotation_query.outfmt6

sed -i 's/\t/|/g' SORTED_iteration25_annotation2reference_query.outfmt6
sed -i 's/\t/|/g' SORTED_iteration25_reference2annotation_query.outfmt6

## LOAD BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration25_annotation2reference_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration25_reference2annotation_query(query, target, percent_id, length, mismatches, gap_opens, query_start, query_end, target_start, target_end, evalue NUM, bit_score);'

sqlite3 iterative_rbh.sqlite '.import SORTED_iteration25_annotation2reference_query.outfmt6 iteration25_annotation2reference_query'
sqlite3 iterative_rbh.sqlite '.import SORTED_iteration25_reference2annotation_query.outfmt6 iteration25_reference2annotation_query'

## RBH

sqlite3 iterative_rbh.sqlite 'SELECT iteration25_annotation2reference_query.query, iteration25_annotation2reference_query.target, iteration25_annotation2reference_query.evalue, iteration25_annotation2reference_query.bit_score, iteration25_reference2annotation_query.query, iteration25_reference2annotation_query.target, iteration25_reference2annotation_query.evalue, iteration25_reference2annotation_query.bit_score
	     FROM iteration25_annotation2reference_query
	     INNER JOIN iteration25_reference2annotation_query
	     ON iteration25_annotation2reference_query.target = iteration25_reference2annotation_query.query
	     WHERE iteration25_annotation2reference_query.query = iteration25_reference2annotation_query.target;' > iteration25_annotation_to_v2.1_transcriptome.rbh

sed -i 's/|/\t/g' iteration25_annotation_to_v2.1_transcriptome.rbh

## GET ANNOTATION, TARGET

ugh=26
#why=`printf '%02d' $ugh`

cut -f1 iteration25_annotation_to_v2.1_transcriptome.rbh > iteration25_annotation
cut -f2 iteration25_annotation_to_v2.1_transcriptome.rbh > iteration25_reference

## FILTER BLAST

sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration25_annotation(id);'
sqlite3 iterative_rbh.sqlite 'CREATE TABLE iteration25_reference(id);'

sqlite3 iterative_rbh.sqlite '.import iteration25_annotation iteration25_annotation'
sqlite3 iterative_rbh.sqlite '.import iteration25_reference iteration25_reference'

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration25_TOTAL_annotation2reference_query
             WHERE target NOT IN (SELECT * FROM iteration25_annotation)
             AND target NOT IN (SELECT * FROM iteration25_reference)
             AND query NOT IN (SELECT * FROM iteration25_reference)
             AND query NOT IN (SELECT * FROM iteration25_annotation);' > iteration$ugh\_annotation2reference_query.outfmt6

sqlite3 iterative_rbh.sqlite 'SELECT * FROM iteration25_TOTAL_reference2annotation_query
             WHERE target NOT IN (SELECT * FROM iteration25_annotation)
             AND target NOT IN (SELECT * FROM iteration25_reference)
             AND query NOT IN (SELECT * FROM iteration25_reference)
             AND query NOT IN (SELECT * FROM iteration25_annotation);' > iteration$ugh\_reference2annotation_query.outfmt6

sed -i 's/|/\t/g' iteration$ugh\_annotation2reference_query.outfmt6
sed -i 's/|/\t/g' iteration$ugh\_reference2annotation_query.outfmt6
