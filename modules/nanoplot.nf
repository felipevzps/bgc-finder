process nanoplot {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(reads)

    output:
    path "${sample_name}_nanoplot_output"

    publishDir "1_raw_qc/${run}/${barcode}/${sample_name}", mode: 'copy'
    //publishDir "2_trimmed/${run}/${barcode}/${sample_name}", mode: 'copy', pattern: "trimmed*"

    script:
    """
    echo '/usr/bin/time -v NanoPlot -t 5 --fastq ${reads} --plots dot --legacy dot --N50 -o ${sample_name}_nanoplot_output' > ${sample_name}_nanoplot_output
    """
}
