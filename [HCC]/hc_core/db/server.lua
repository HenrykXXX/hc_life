-- Abstract layer for db

HC.DB = {}

function HC.DB.Execute(queue, args, cb)
    exports['mysql-async']:mysql_execute(queue, args, cb)
end

function HC.DB.FetchAll(queue, args, cb)
    exports['mysql-async']:mysql_fetch_all(queue, args, cb)
end