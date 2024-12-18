process whokaryote {
    conda "whokaryote"

    input:
    tuple val(run), val(barcode), val(sample_name), file(assemblyFile)

    output:
    path("${sample_name}_whokaryote_output")

    publishDir "7_assign_taxonomy/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v whokaryote.py --contigs ${assemblyFile} --outdir ${sample_name}_whokaryote_output --threads 4' > ${sample_name}_whokaryote_output
    """
}
