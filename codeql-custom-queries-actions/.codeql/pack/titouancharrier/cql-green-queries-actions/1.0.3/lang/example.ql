/**
 * @name Hello World GitHub Actions
 * @description Liste tous les fichiers de workflow GitHub Actions détectés.
 * @kind table
 * @id github-actions/hello-world
 */


import actions

from Workflow w
where w.getName() = "test"
select w, w.getAJob()
