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
│   └── java
│       ├── android-java-test.expected
│       ├── android-java-test.java
│       └── android-java-test.ql
├── cleanActual.sh
├── codeql-pack.lock.yml
├── codeql-pack.yml
├── lang
│   ├── LangTest.java
│   ├── ManualArrayCopy.java
│   ├── lang-test.expected
│   ├── lang-test.ql
│   ├── manual-array-copy.expected
│   └── manual-array-copy.ql
├── launchTests.sh
├── queries-suites
│   ├── android.qls
│   └── lang.qls
└── updateReadme.sh

5 directories, 18 files
```
