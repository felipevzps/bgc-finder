process dastool {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(metabat2Bins), file(maxbin2Bins), file(concoctBins), file(graphmbBins)

    output:
    path("${sample_name}_dastool_output")

    publishDir "10_non-redundant_bins/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v DAS_Tool -i ${metabat2Bins},${maxbin2Bins},${concoctBins},${graphmbBins} -c assembly.fasta -o ${sample_name}_dastool_output -t 5' > ${sample_name}_dastool_output
    """
}
