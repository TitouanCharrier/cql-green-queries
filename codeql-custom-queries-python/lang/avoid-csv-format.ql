/**
 * @name Avoid CSV format, prefer a compressed format like Parquet
 * @description CSV files are stored in plain text per row, leading to larger file sizes, slower I/O, and higher energy consumption compared to binary columnar formats. Prefer Parquet or Feather for data-intensive workloads.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id python/lang/avoid-csv-format
 * @tags lang
 */

import python

predicate isCsvMethod(string name) { name = "read_csv" or name = "to_csv" }

from AstNode n, string message
where
  exists(Call call, Attribute attr |
    n = call and
    call.getFunc() = attr and
    isCsvMethod(attr.getName()) and
    message = "Avoid " + attr.getName() + "(): CSV format is slow and energy-intensive. Use Parquet (pd.read_parquet() / df.to_parquet()) for better compression, faster I/O, and lower energy consumption."
  )
  or
  exists(StringLiteral s |
    n = s and
    s.getText().regexpMatch("(?i).*\\.csv") and
    not exists(Call c, Attribute a |
      c.getFunc() = a and
      isCsvMethod(a.getName()) and
      c.getAnArg() = s
    ) and
    message = "Avoid CSV files. Use Parquet format instead for better compression, faster I/O, and lower energy consumption."
  )
select n, message