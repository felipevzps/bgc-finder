process seqkit {
    conda "metagenomics"

    input:
    file(readsFile)
    val(outputFile)

    output:
    path("${outputFile}")

    script:
    """
    /usr/bin/time -v seqkit stats ${readsFile} > ${outputFile}
    """
}
