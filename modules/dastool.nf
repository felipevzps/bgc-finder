process dastool {
    conda "metagenomics"

    input:
    file(metabat2Bins)
    file(maxbin2Bins)
    file(concoctBins)
    file(graphmbBins)

    output:
    path("dastool_output")

    script:
    """
    /usr/bin/time -v DAS_Tool -i ${metabat2Bins},${maxbin2Bins},${concoctBins},${graphmbBins} -c assembly.fasta -o dastool_output -t 5
    """
}
