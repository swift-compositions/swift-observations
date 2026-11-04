# swift-observations

Use this package when you want a struct, a `~Copyable` struct or a class to report changes to its properties, and to react to the first change of whatever a piece of code read. Mark the type with `@Observable` and read it inside `withObservationTracking(_:onChange:)`. If you write the accessors yourself, call `Observer.Tracking.access(_:_:)` from each read and keep the subscription in an `Observer.Subscription.Token`. If you only need the registrar that delivers will-set and did-set notifications, use swift-observer, which this package re-exports.

## Laws

- `@Observable` tracks every stored `var` without accessors whose name doesn't start with an underscore. `let`, `static`, `class` and `lazy` properties, computed properties and underscore-prefixed properties are left alone.
- Tracked properties are numbered from 0 in declaration order, counting only tracked properties, and that number is the `Observer.Property.ID` used for notifications.
- A tracked property notifies around every in-place modification, with `willSet` before and `didSet` after. A read records an access only.
- `@Observable` adds no registrar if the type already declares `_$registrar`, and no conformance if the type already lists `Observable` or `Observer.Protocol`.
- `withObservationTracking(_:onChange:)` calls `onChange` at most once, on the first `didSet` of any property the body read, on the thread that made the change. Every subscription the call installed is removed before `onChange` runs. To keep watching, track again from `onChange`.
- A body that reads no tracked property installs nothing, and its `onChange` never runs.
- Tracking is per thread. Reads made on another thread during the body are not recorded. When tracking is nested, only the innermost call records a read, and the outer call doesn't see it.
- `Observer.Tracking.access(_:_:)` does nothing outside `withObservationTracking(_:onChange:)`.
- An `Observer.Subscription.Token` unsubscribes when it is destroyed, unless `Observer.Subscription.Token.detach()` took the subscription out first. A second `detach()` returns nil.
