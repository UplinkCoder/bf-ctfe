# bf-ctfe
## Usage

```
enum addOne = ",+.";

import bf_executor;

static assert (execute!addOne(cast(ubyte[])"a") == cast(ubyte[])"b");
```

---

The Programm has to be a CT constant
the arguments to the programm however can be runtime values.

