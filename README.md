> [!WARNING]  
> Edit Licence to follow the GSF way of doing things.
> Edit Code of conduct to add the mean of contact in case of problem.

# Green Code Scan Rules

---
Java/Kotlin :

[![Publish CodeQL Java Pack](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishJavaPack.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishJavaPack.yml)
[![CodeQL Unitary Analysis - Java](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunJavaTest.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunJavaTest.yml)

Python:

[![Publish CodeQL Python Pack](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishPythonPack.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishPythonPack.yml)
[![CodeQL Unitary Analysis - Python](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunPythonTest.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunPythonTest.yml)

C/C++ :

[![Publish CodeQL Cpp Pack](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishCppPack.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishCppPack.yml)
[![CodeQL Unitary Analysis - CPP](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunCppTest.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunCppTest.yml)

Javascript/TypeScript :

[![Publish CodeQL JavaScript Pack](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishJavascriptPack.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/PublishJavascriptPack.yml)
[![CodeQL Unitary Analysis - JavaScript](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunJavascriptTest.yml/badge.svg)](https://github.com/TitouanCharrier/cql-green-queries/actions/workflows/RunJavascriptTest.yml)

---

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

env:
  TARGET_LANGUAGE: "java" # To change depending of your project

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

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
        languages: ${{ env.TARGET_LANGUAGE }}
        packs: titouancharrier/cql-green-queries-${{ env.TARGET_LANGUAGE }}

    - name: Autobuild
      uses: github/codeql-action/autobuild@v3

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v3
      with:
        category: "/language:${{ env.TARGET_LANGUAGE }}"

```

---

## Contribute

If you wish to contribute refer to the [contributing file](CONTRIBUTING.md).

---

## Licence

This project is under the GPL3 Licence.
