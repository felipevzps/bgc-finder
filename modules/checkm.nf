process checkm {
    conda "checkm"

    input:
    tuple val(run), val(barcode), val(sample_name), file(dastoolBins)

    output:
    path("${sample_name}_checkm_output")

    publishDir "11_checkm/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v checkm lineage_wf -x fa -t 10 --tab_table ${dastoolBins} ${sample_name}_checkm_output -f ${sample_name}_checkm_output.tsv' > ${sample_name}_checkm_output
    """
}
