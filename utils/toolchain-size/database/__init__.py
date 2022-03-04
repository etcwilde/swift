import sqlite3
import sys


class Database:
    """
    Wrapper around the sqlite database to provide some niceties and safety
    """
    def __init__(self, dbpath):
        self.path = dbpath
        self.handle = None

    def __enter__(self):
        self.open()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.close()
        self.handle = None

    @property
    def is_closed(self):
        return self.handle is None

    def open(self):
        if self.is_closed:
            self.handle = sqlite3.connect(self.path)

    def close(self):
        if not self.is_closed:
            self.handle.close()
            self.handle = None

    def cursor(self):
        if self.is_closed:
            return None
        return self.handle.cursor()

    def executescript(self, script):
        if not self.is_closed:
            self.handle.executescript(script)

    def commit(self):
        if not self.is_closed:
            self.handle.commit()

    def transaction(self):
        return Transaction(self)


class Transaction:
    """
    Wrapper around a transaction in the database
    This transaction is not open, so it can't be used until it is.
    """
    def __init__(self, db):
        self.db = db
        self.rollback = False

    def __enter__(self):
        self.cursor = self.db.cursor()
        return OpenTransaction(self)

    def __exit__(self, exc_type, exc_value, traceback):
        if exc_type is not None:
            self.rollback = True
            # TODO: This should probably forward the database error
            print(traceback, file=sys.stderr)
        if self.cursor is not None:
            if self.rollback:
                self.cursor.execute("ROLLBACK;")
            else:
                self.cursor.execute("COMMIT;")
            self.cursor.close()
            self.cursor = None

    def __del__(self):
        if self.cursor is not None:
            self.cursor.close()
            self.cursor = None


class OpenTransaction:
    """
    Wrapper around an opened transaction in the database.
    This transaction is open, so it can be used.
    This mechanism ensures that the transaction is always either rolled back or
    committed at the end of the scope, ensuring the database doesn't enter a
    locked state from a dangling, unclosed transaction.
    """

    def __init__(self, transaction):
        self.transaction = transaction
        self.transaction.cursor.execute("BEGIN;")

    @property
    def cursor(self):
        return self.transaction.cursor

    def rollback(self):
        """
        Don't apply this transaction.
        The rollback isn't applied until the destruction of the transaction.
        Any changes issued after this point will not take effect.

        :returns: None
        """
        self.transaction.rollback = True

    def create_table(self, name, rows, drop=False):
        """
        Create a new table with the given name and rows

        :name: String, the name of the table
        :rows: [String], the schema of the table
        """
        if drop:
            self.cursor.execute(f"DROP TABLE IF EXISTS {name};")
        query = f"CREATE TABLE {name} (\n  " + ',\n  '.join(rows) + "\n);"
        self.cursor.execute(query)

    def single_query(self, query, args=None):
        """
        Perform a query against the database.
        The transaction must remain alive while the query result iterator
        is alive.

        :query: String, the query to execute once
        :args: (Values,...), A tuple of arguments for a single row
        :returns: QueryResults, an iterator to the results of the query
        """
        if args is None:
            return self.cursor.execute(query)
        else:
            return self.cursor.execute(query, args)

    def multi_query(self, query, args):
        """
        Perform a query with multiple piece of data

        :query: String, The query to execute
        :args:  A sequence of parameter sets for each row
        :returns: None
        """
        return self.cursor.executemany(query, args)


if __name__ == "__main__":
    contestants = [("Janice",), ("Alfred",), ("Tony",), ("Rachel",)]
    with Database(":memory:") as db:
        with db.transaction() as transaction:
            transaction.create_table("contestants",
                                     ["id INTEGER PRIMARY KEY",
                                      "name TEXT NOT NULL"])
            transaction.multi_query("INSERT INTO contestants (name) VALUES (?);",
                                    contestants)

            for rowid, name in \
                    transaction.single_query("SELECT * FROM contestants;"):
                print(name)

        with db.transaction() as transaction:
            for _, name in \
                    transaction.single_query("SELECT * FROM contestants;"):
                print(name)
