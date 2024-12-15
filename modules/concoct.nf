process concoct {
    conda "metagenomics"

    input:
    file(bamFile)
    file(assemblyFile)

    output:
    path("concoct_bins")

    script:
    """
    /usr/bin/time -v cut_up_fasta.py ${assemblyFile} -c 10000 -o 0 --merge_last -b contigs_10K.bed > contigs_10K.fa
    /usr/bin/time -v concoct_coverage_table.py contigs_10K.bed ${bamFile} > coverage_table.tsv
    /usr/bin/time -v concoct --composition_file contigs_10K.fa --coverage_file coverage_table.tsv -b concoct_output -t 5
    """
}
