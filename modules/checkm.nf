process checkm {
    conda "checkm"

    input:
    file(dastoolBins)

    output:
    path("checkm_output")

    script:
    """
    /usr/bin/time -v checkm lineage_wf -x fa -t 10 --tab_table ${dastoolBins} checkm_output -f checkm_output.tsv
    """
}
