/**
 * @name Avoid CSV format
 * @description Use Parquet or Feather format instead of CSV for better performance and smaller footprint.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id py/avoid-csv-format
 * @tags efficiency
 * sustainability
 */

import python

predicate isCsvMethod(string name) {
  name = "read_csv" or name = "to_csv"
}

from AstNode n, string message
where
  // Cas 1 : Appels de méthodes read_csv() ou to_csv()
  exists(Call call, Attribute attr |
    n = call and
    call.getFunc() = attr and
    isCsvMethod(attr.getName()) and
    message = "Use Parquet or Feather format instead of calling " + attr.getName() + "."
  )
  or
  // Cas 2 : Littéraux de chaînes de caractères finissant par .csv
  exists(StringLiteral s |
    n = s and
    s.getText().regexpMatch("(?i).*\\.csv") and
    // On évite de lever une double alerte si la chaîne est argument d'un read_csv/to_csv
    not exists(Call c, Attribute a | 
      c.getFunc() = a and 
      isCsvMethod(a.getName()) and 
      c.getAnArg() = s
    ) and
    message = "Use Parquet or Feather format instead of CSV files."
  )
select n, message