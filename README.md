> [!WARNING]  
> Edit Licence to follow the GSF way of doing things.
> Edit Code of conduct to add the mean of contact in case of problem.

# Green Code Scan Rules

---
Build :
[![Publish CodeQL Java Pack](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishJavaPack.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishJavaPack.yml)

---
Test :
[![CodeQL Unitary Analysis - Java](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunJavaTest.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunJavaTest.yml)

This repository have rules which check if your code is eco-friendly (or not). It use CodeQL to find parts of your code that are not good for environment (useless process, memory leak,...).

## Project Map

The rules are put in different folders for each language. Each folder have special queries to detect environnemental unfriendly behavior.

* **Java/Kotlin**
* **C/C++**
* **Javascript/Typescript**
* **Python**
* **Action/Yml**

---

## How to use in your Github

To use copy this code into a Github Action. Precise which language (java by default).

```yaml
name: "CodeQL Analysis"

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
  schedule:
    - cron: '30 1 * * 1' # Run every Monday at 01:30
  workflow_dispatch:
    inputs:
      language:
        description: 'Select the language to scan for green rules'
        required: true
        default: 'java'
        type: choice
        options:
        - java
        - cpp
        - javascript
        - python
        - action

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    steps:
    - name: Checkout repository
      uses: actions/checkout@v4

    - name: Initialize CodeQL
      uses: github/codeql-action/init@v3
      with:
        # It use the language you choose in the button
        languages: ${{ github.event.inputs.language || 'java' }} # change to specify your repo language
        # It look into the folder cql-green-queries-<language>
        packs: titouancharrier/cql-green-queries-${{ github.event.inputs.language || 'java' }}

    - name: Autobuild
      uses: github/codeql-action/autobuild@v3

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v3
      with:
        category: "/language:${{ github.event.inputs.language || 'java' }}"

```

---

## Contribute

If you wish to contribute refer to the [contributing file](CONTRIBUTING.md).

## Licence

This project is under the GPL3 Licence.
