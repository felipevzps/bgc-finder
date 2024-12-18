process maxbin2 {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(bamFile), file(assemblyFile)

    output:
    path("${sample_name}_maxbin2_bins")

    publishDir "9_genome_binning/${run}/${barcode}/MaxBin2/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v run_MaxBin.pl -contig ${assemblyFile} -abund depth.txt -out ${sample_name}_maxbin2_bins -thread 5' > ${sample_name}_maxbin2_bins
    """
}
