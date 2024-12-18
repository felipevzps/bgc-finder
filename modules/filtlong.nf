process filtlong {
    conda "metagenomics"
    
    input:
    tuple val(run), val(barcode), val(sample_name), file(reads)

    output:
    tuple val(run), val(barcode), val(sample_name), file("${sample_name}_filtlong.fastq")
    //file "${sample_name}_filtlong.fastq"

    publishDir "2_trimmed/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v filtlong --min_length 1000 ${reads} > ${sample_name}_filtlong.fastq' > ${sample_name}_filtlong.fastq
    """
}
