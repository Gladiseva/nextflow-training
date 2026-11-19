#!/usr/bin/env nextflow

/*
 * Call variants with GATK HaplotypeCaller
 */
process GATK_HAPLOTYPECALLER {

    container "community.wave.seqera.io/library/gatk4:4.5.0.0--730ee8817e436867"
    conda 'bioconda::gatk4=4.6.2.0'

    input:
    tuple path(bam), path(bam_bai)
    path ref_fasta
    path ref_index
    path ref_dict
    path interval_list_bed


    output:
    path "${bam}.vcf", emit: vcf
    path "${bam}.vcf.idx", emit: idx

    script:
    """
    gatk HaplotypeCaller -R ${ref_fasta} -I ${bam} -O ${bam}.vcf -L ${interval_list_bed}
    """
}
