process nanoplot {
    conda "metagenomics"

    input:
    file(readsFile)
    val(outputPrefix)

    output:
    path("${outputPrefix}_nanoplot_output_*")

    script:
    """
    /usr/bin/time -v NanoPlot -t 5 --fastq ${readsFile} --plots dot --legacy dot --N50 -o ${outputPrefix}_nanoplot_output
    """
}
