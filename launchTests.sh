#!/usr/bin/bash

(cd codeql-custom-queries-cpp && ./launchTests.sh)
(cd codeql-custom-queries-java && ./launchTests.sh)
(cd codeql-custom-queries-python && ./launchTests.sh)
(cd codeql-custom-queries-actions && ./launchTests.sh)
(cd codeql-custom-queries-javascript && ./launchTests.sh)

