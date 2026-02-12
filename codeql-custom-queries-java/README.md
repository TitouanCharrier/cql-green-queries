# Arborescence comme décrit dans la doc 

<href>https://docs.github.com/en/code-security/tutorials/customize-code-scanning/testing-custom-queries </href> 

### Arborescence Type :
```
codeql-custom-queries-java/
├── codeql-pack.yml            
├── android/
│   ├── java/
│   │   └── test_1.ql
│   │   └── test_1.java
│   │   └── test_1.expected
│   └── kotlin/
│       └── test_1.ql
│       └── test_1.java
│       └── test_1.expected
├── lang/
│   ├── example.ql
│   └── manual-array-copy.ql

```

### Arborescence Actuelle :

## Structure du projet
```text
.
├── README.md
├── README.md.tmp
├── android
│   ├── AvoidKeepScreenOn.java
│   ├── avoid-keep-screen-on.expected
│   └── avoid-keep-screen-on.ql
├── cleanActual.sh
├── codeql-pack.lock.yml
├── codeql-pack.yml
├── lang
│   ├── ManualArrayCopy.java
│   ├── manual-array-copy.expected
│   └── manual-array-copy.ql
├── launchTests.sh
├── queries-suites
│   ├── android.qls
│   └── lang.qls
└── updateReadme.sh

4 directories, 15 files
```
