/**
 * @name Pandas - Avoid Reading Unnecessary Columns in CSV Files
 * @description Reading CSV files without explicitly specifying which columns to load leads to unnecessary data loading and increases memory and energy consumption. Always use the `usecols` parameter in pandas.read_csv() to select only the required columns.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id lang/avoid-csv-format
 * @tags efficiency
 *       sustainability
 */

import python

predicate isCsvMethod(string name) { name = "read_csv" or name = "to_csv" }

from AstNode n, string message
where
  exists(Call call, Attribute attr |
    n = call and
    call.getFunc() = attr and
    isCsvMethod(attr.getName()) and
    message = "Use Parquet or Feather format instead of calling " + attr.getName() + "."
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
    message = "Use Parquet or Feather format instead of CSV files."
  )
select n, message
