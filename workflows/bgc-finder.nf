nextflow.enable.dsl=2

params {
    samples = file('samples.csv')
}

include { nanoplot	} from '../modules/nanoplot.nf'
include { seqkit	} from '../modules/seqkit.nf'
include { filtlong	} from '../modules/filtlong.nf'
include { porechop	} from '../modules/porechop.nf'
include { metaflye	} from '../modules/metaflye.nf'
include { whokaryote	} from '../modules/whokaryote.nf'
include { mapping	} from '../modules/mapping.nf'
include { samtools      } from '../modules/samtools.nf'
include { metabat2      } from '../modules/metabat2.nf'
include { maxbin2       } from '../modules/maxbin2.nf'
include { concoct       } from '../modules/concoct.nf'
include { graphmb       } from '../modules/graphmb.nf'
include { dastool	} from '../modules/dastool.nf'
include { checkm	} from '../modules/checkm.nf'
include { gtdb		} from '../modules/gtdb.nf'
include { bakta		} from '../modules/bakta.nf'
include { antismash	} from '../modules/antismash.nf'
include { bigscape	} from '../modules/bigscape.nf'

workflow {
    // Read samples.csv
    Channel.from(file(params.samples).read().splitCsv(header: true))
        .map { row -> tuple(row.sample_name, row.fastq_path) }
        .set { samples_channel }

    // Quality Control for raw reads
    samples_channel
        .flatMap { sample_name, reads ->
            nanoplot(reads, "raw_${sample_name}")
            seqkit(reads, "raw_${sample_name}_stats.txt")
        }

    // Processing
    samples_channel
        .map { sample_name, reads ->
            filtlong(reads)
            porechop(filtlong.out)
        }

    // Quality Control for trimmed reads
    samples_channel
        .map { sample_name, reads ->
            nanoplot(porechop.out, "trimmed_${sample_name}")
            seqkit(porechop.out, "trimmed_${sample_name}_stats.txt")
        }

    // Assembly
    samples_channel
        .map { sample_name, reads ->
            metaflye(porechop.out)
        }

    // Taxonomy Assignment
    samples_channel
        .map { sample_name, reads ->
            whokaryote(metaflye.out)
        }

    // Genome Binning
    samples_channel
        .map { sample_name, reads ->
            mapping(porechop.out, metaflye.out)
            samtools(mapping.out)
            metabat2(samtools.out, metaflye.out)
            maxbin2(samtools.out, metaflye.out)
            concoct(samtools.out, metaflye.out)
            graphmb(samtools.out, metaflye.out)
        }

    // Non-Redundant Bin Finding
    samples_channel
        .map { sample_name, reads ->
            dastool(metabat2.out, maxbin2.out, concoct.out, graphmb.out)
        }

    // Evaluate Bins
    samples_channel
        .map { sample_name, reads ->
            checkm(dastool.out)
        }

    // Taxonomic Classification
    samples_channel
        .map { sample_name, reads ->
            gtdb(dastool.out)
        }

    // Genome Annotation
    samples_channel
        .map { sample_name, reads ->
            bakta(dastool.out)
        }

    // BGCs Identification
    samples_channel
        .map { sample_name, reads ->
            antismash(bakta.out)
        }

    // BGCs Visualization
    samples_channel
        .map { sample_name, reads ->
            bigscape(antismash.out)
        }
}
