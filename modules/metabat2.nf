process metabat2 {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(bamFile), file(assemblyFile)

    output:
    path("${sample_name}_metabat2_bins")

    publishDir "9_genome_binning/${run}/${barcode}/MetaBAT2/${sample_name}", mode: 'copy'

    script:
    """
    /usr/bin/time -v jgi_summarize_bam_contig_depths --outputDepth depth.txt ${bamFile}
    echo '/usr/bin/time -v metabat2 -i ${assemblyFile} -a depth.txt -o ${sample_name}_metabat2_bins -t 5' > ${sample_name}_metabat2_bins
    """
}
