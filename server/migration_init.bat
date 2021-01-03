REM call rest_migration
call typeorm migration:generate -n init
REM call typeorm migration:create -n populate\