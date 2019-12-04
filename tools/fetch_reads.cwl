#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "fetch reads: Get raw reads files from ENA."

#baseCommand: [ fetch_reads.py ]
baseCommand: [echo, "$(inputs.runs) > data.txt"]

inputs:
  runs:
    type: string
    inputBinding:
      position: 1
    doc: |
      Download a subset of the reads of a study, otherwise download everything.

outputs:
  reads:
    type: string[]
    outputBinding:
      glob: data.txt
      loadContents: true
