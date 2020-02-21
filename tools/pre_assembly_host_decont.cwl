#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Reads Host Decontamination"

baseCommand: [ echo ]

requirements:
  InlineJavascriptRequirement: {}

inputs:
  forward_reads:
    type: File
    inputBinding:
      prefix: "-1"
  reverse_reads:
    type: File
    inputBinding:
      prefix: "-2"
  reference:
    type: File
    inputBinding:
      prefix: "-r"

outputs:
  forward_reads_decontaminated:
    type: File
    format: edam:format_1930
    outputBinding:
      glob: $(inputs.forward_reads.nameroot).decontaminated.fastq.gz

  reverse_reads_decontaminated:
    type: File
    format: edam:format_1930
    outputBinding:
      glob: $(inputs.reverse_reads.nameroot).decontaminated.fastq.gz
  
  summary:
    type: File
    outputBinding:
      glob: "log.txt"
