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

outputs:
  forward_reads_decontaminated:
    type: File
    format: edam:format_1930
    outputBinding:
      glob: $(inputs.reads1.nameroot).decontaminated.fastq.gz

  reverse_reads_decontaminated:
    type: File
    format: edam:format_1930
    outputBinding:
      glob: $(inputs.reads2.nameroot).decontaminated.fastq.gz