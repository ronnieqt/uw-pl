# ============================================================

from abc import ABC, abstractmethod

# ============================================================

class Expr(ABC):

    @abstractmethod
    def eval(self) -> "Value":
        pass

    @abstractmethod
    def to_string(self) -> str:
        pass

    @abstractmethod
    def has_zero(self) -> bool:
        pass

# ------------------------------------------------------------

class Value(Expr):

    def eval(self) -> "Value":
        return self

    @abstractmethod
    def to_int(self) -> int:
        pass

# ============================================================

class Int(Value):

    def __init__(self, i: int):
        self.i = i

    def to_string(self) -> str:
        return f"{self.i}"

    def has_zero(self) -> bool:
        return self.i == 0

    def to_int(self) -> int:
        return self.i

# ============================================================
    
class Negate(Expr):

    def __init__(self, e: Expr):
        self.e = e
    
    def eval(self) -> Value:
        return Int(-1 * self.e.eval().to_int())

    def to_string(self) -> str:
        return f"-({self.e.to_string()})"

    def has_zero(self) -> bool:
        return self.e.has_zero()

# ------------------------------------------------------------

class Add(Expr):

    def __init__(self, e1: Expr, e2: Expr):
        self.e1 = e1 
        self.e2 = e2

    def eval(self) -> Value:
        return Int(self.e1.eval().to_int() + self.e2.eval().to_int())
    
    def to_string(self) -> str:
        return f"({self.e1.to_string()} + {self.e2.to_string()})"
    
    def has_zero(self) -> bool:
        return self.e1.has_zero() or self.e2.has_zero()

# ============================================================

def _main():
    e = Add(Add(Int(3),Negate(Int(2))),Int(0))
    print(f"Expression : {e.to_string()}")
    print(f"     Value : {e.eval().to_int()}")
    print(f" Has Zero? : {e.has_zero()}")

if __name__ == "__main__":
    _main()

# ============================================================
