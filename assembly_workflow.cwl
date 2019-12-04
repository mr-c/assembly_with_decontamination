#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs:
    msmemory: int
    msthreads: int
    trimmomatic_summary: string?
    reads1: File
    reads2: File

steps:
  trimmomatic:
    doc: |
      Low quality trimming (low quality ends and sequences with < quality scores
      less than 15 over a 4 nucleotide wide window are removed)
    run: tools/trimmomatic.cwl
    in:
      reads1: reads1
      reads2: reads2      
      phred: { default: '33' }
      leading: { default: 3 }
      trailing: { default: 3 }
      end_mode: { default: PE }
      minlen: { default: 90 }
      slidingwindow: { default: '4:15' }
      summary: trimmomatic_summary
    out: [reads1_trimmed_paired, reads2_trimmed_paired, summary]
  metaspades:
    doc: |
      Assemble the trimmed reads using metaSpades.
      metaSpades will be run in assembly mode (no error correction).
    run: tools/metaspades.cwl
    in:
      forward_reads: trimmomatic/reads1_trimmed_paired
      reverse_reads: trimmomatic/reads2_trimmed_paired
      memory: msmemory
      threads: msthreads
    out: [assembly_dir]

outputs:
  assembly_dir:
    type: Directory
    outputSource: metaspades/assembly_dir
  trimmomatic_log:
    type: File
    outputSource: trimmomatic/summary