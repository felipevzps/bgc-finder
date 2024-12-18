process nanoplot {
    conda "metagenomics"

    input:
    tuple file(reads), val(sample_name)

    output:
    path "${sample_name}_nanoplot_output_*"

    script:
    """
    /usr/bin/time -v NanoPlot -t 5 --fastq ${reads} --plots dot --legacy dot --N50 -o ${sample_name}_nanoplot_output
    """
}
