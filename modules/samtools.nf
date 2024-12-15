process samtools {
    conda "metagenomics"

    input:
    file(samFile)

    output:
    path("mapped_sorted_output.bam")

    script:
    """
    /usr/bin/time -v samtools view -b -o mapped_output.bam ${samFile}
    /usr/bin/time -v samtools sort -o mapped_sorted_output.bam mapped_output.bam
    /usr/bin/time -v samtools index mapped_sorted_output.bam
    """
}
