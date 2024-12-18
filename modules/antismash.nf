process antismash {
    conda "antismash"

    input:
    tuple val(run), val(barcode), val(sample_name), file(baktaOutput)

    output:
    path("${sample_name}_antismash_output")

    publishDir "14_BGCs/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v antismash ${baktaOutput} --output-dir ${sample_name}_antismash_output --cb-general --cb-knownclusters --pfam2go' > ${sample_name}_antismash_output
    """
}
