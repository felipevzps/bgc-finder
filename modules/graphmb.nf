process graphmb {
    conda "graphmb"

    input:
    tuple val(run), val(barcode), val(sample_name), file(bamFile), file(assemblyFile)

    output:
    path("${sample_name}_graphmb_bins")

    publishDir "9_genome_binning/${run}/${barcode}/GraphMB/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v graphmb --assembly ${assemblyFile} --outdir ${sample_name}_graphmb_bins --depth depth.txt --numcores 10' > ${sample_name}_graphmb_bins
    """
}
