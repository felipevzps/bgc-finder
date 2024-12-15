process SEQKIT_STATS {
	tag "$meta.id"
	label 'process_low'

	conda "${moduleDir}/environment.yml"

	input:
	tuple val(meta), path(reads)

	output:
	tuple val(meta), path("*.tsv"), emit: stats
	path "versions.yml"           , emit: versions

	when:
	task.ext.when == null || task.ext.when

	script:
	def args = task.ext.args ?: '--all'
	def prefix = task.ext.prefix ?: "${meta.id}"
	"""
	seqkit stats \\
		--tabular \\
		$args \\
		$reads > '${prefix}.tsv'

	cat <<-END_VERSIONS > versions.yml
	"${task.process}":
		seqkit: \$( seqkit version | sed 's/seqkit v//' )
	END_VERSIONS
	"""
}
