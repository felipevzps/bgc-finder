process samtools {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(samFile)

    output:
    path("${sample_name}_mapped_sorted_output.bam")

    publishDir "9_genome_binning/${run}/${barcode}/samtools/${sample_name}", mode: 'copy'

    script:
    
    //usr/bin/time -v samtools view -b -o ${sample_name}_mapped_output.bam ${samFile}
    //usr/bin/time -v samtools sort -o ${sample_name}_mapped_sorted_output.bam ${sample_name}_mapped_output.bam
    """
    echo '/usr/bin/time -v samtools index ${sample_name}_mapped_sorted_output.bam' > ${sample_name}_mapped_sorted_output.bam
    """
}
