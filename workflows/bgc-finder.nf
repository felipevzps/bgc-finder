nextflow.enable.dsl = 2

// Define input samples file
params.samples = file('samples.csv')

// Print details of the samples file
println "Samples file: ${params.samples}"

// Include external module scripts
include { nanoplot as raw_nanoplot	} from '../modules/nanoplot.nf'
include { seqkit as raw_seqkit		} from '../modules/seqkit.nf'
include { filtlong      		} from '../modules/filtlong.nf'
include { porechop      		} from '../modules/porechop.nf'
include { nanoplot as trimmed_nanoplot	} from '../modules/nanoplot.nf'
include { seqkit as trimmed_seqkit	} from '../modules/seqkit.nf'
include { metaflye      		} from '../modules/metaflye.nf'
include { whokaryote    		} from '../modules/whokaryote.nf'
include { mapping       		} from '../modules/mapping.nf'
include { samtools      		} from '../modules/samtools.nf'
include { metabat2      		} from '../modules/metabat2.nf'
include { maxbin2       		} from '../modules/maxbin2.nf'
include { concoct       		} from '../modules/concoct.nf'
include { graphmb       		} from '../modules/graphmb.nf'
include { dastool       		} from '../modules/dastool.nf'
include { checkm        		} from '../modules/checkm.nf'
include { gtdb          		} from '../modules/gtdb.nf'
include { bakta         		} from '../modules/bakta.nf'
include { antismash     		} from '../modules/antismash.nf'
include { bigscape      		} from '../modules/bigscape.nf'

workflow {
    // Create samples channel
    samples_channel = Channel.from(file(params.samples).splitCsv(header: true))
        .map { row -> tuple(row.run, row.barcode, row.sample_name, file(row.fastq_path)) }

    // Quality control for raw reads
    raw_nanoplot(samples_channel)
    raw_seqkit(samples_channel)

    // Process reads with Filtlong and Porechop
    filtlong(samples_channel)
    porechop(filtlong.out)

    // Quality control for trimmed reads
    trimmed_nanoplot(porechop.out)
    trimmed_seqkit(porechop.out)

    // Assembly with MetaFlye
    metaflye(porechop.out)

    // Assign taxonomy with WhoKaryote
    whokaryote(metaflye.out)

    // Genome binning
    //mapping(porechop.out, metaflye.out)
    mapping(porechop.out.join(metaflye.out))
    samtools(mapping.out)

    metabat2(samtools.out.join(metaflye.out))
    maxbin2(samtools.out.join(metaflye.out))
    concoct(samtools.out.join(metaflye.out))
    graphmb(samtools.out.join(metaflye.out))

    // Consolidate bins with DAS Tool
    //dastool(metabat2.out.zip(maxbin2.out, concoct.out, graphmb.out))
    dastool(metabat2.out.join(maxbin2.out).join(concoct.out).join(graphmb.out))

    // Evaluate bin quality with CheckM
    checkm(dastool.out)

    // Classify bins with GTDB
    gtdb(dastool.out)

    // Annotate genomes with Bakta
    bakta(dastool.out)

    // Identify BGCs with antiSMASH
    antismash(bakta.out)

    // Visualize BGCs with BiG-SCAPE
    bigscape(antismash.out)
}
