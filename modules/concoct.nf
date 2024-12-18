process concoct {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(bamFile), file(assemblyFile)

    output:
    path("${sample_name}_concoct_bins")

    publishDir "9_genome_binning/${run}/${barcode}/CONCOCT/${sample_name}", mode: 'copy'

    script:
    """
    /usr/bin/time -v cut_up_fasta.py ${assemblyFile} -c 10000 -o 0 --merge_last -b contigs_10K.bed > contigs_10K.fa
    /usr/bin/time -v concoct_coverage_table.py contigs_10K.bed ${bamFile} > coverage_table.tsv
    echo '/usr/bin/time -v concoct --composition_file contigs_10K.fa --coverage_file coverage_table.tsv -b ${sample_name}_concoct_output -t 5' > ${sample_name}_concoct_bins
    """
}
