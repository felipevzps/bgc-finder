process antismash {
    conda "antismash"

    input:
    file(baktaOutput)

    output:
    path("antismash_output")

    script:
    """
    /usr/bin/time -v antismash ${baktaOutput} --output-dir antismash_output --cb-general --cb-knownclusters --pfam2go
    """
}
