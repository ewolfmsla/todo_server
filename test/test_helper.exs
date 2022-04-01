ExUnit.start()

Mox.defmock(WolfMock, for: WolfBehavior)
Mox.defmock(DatabaseMock, for: Todo.DatabaseBehavior)
