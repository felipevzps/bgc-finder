process seqkit {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(reads)

    output:
    path "${sample_name}_stats.txt"

    publishDir "1_raw_qc/${run}/${barcode}/${sample_name}", mode: 'copy' 
    //publishDir "2_trimmed/${run}/${barcode}/${sample_name}", mode: 'copy', pattern: "trimmed*"

    script:
    """
    echo '/usr/bin/time -v seqkit stats ${reads} > ${sample_name}_stats.txt' > ${sample_name}_stats.txt
    """
}
