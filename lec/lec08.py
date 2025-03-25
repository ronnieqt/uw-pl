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
# Abstract Method and High-Order Function

class NTimesBase(ABC):

    def __init__(self, n: int):
        assert n >= 0
        self.n = n

    @abstractmethod
    def f(self, x: int) -> int:
        pass

    def run(self, x: int) -> int:
        for _ in range(self.n):
            x = self.f(x)
        return x

class IncrementNTimes(NTimesBase):

    def f(self, x: int) -> int:
        return x + 1

class DoubleNTimes(NTimesBase):

    def f(self, x: int) -> int:
        return 2*x

# ============================================================

def _main():
    print("===== Part 1 =====")
    e = Add(Add(Int(3),Negate(Int(2))),Int(0))
    print(f"Expression : {e.to_string()}")
    print(f"     Value : {e.eval().to_int()}")
    print(f" Has Zero? : {e.has_zero()}")
    print("===== Part 2 =====")
    print(f"IncrementNTimes : {IncrementNTimes(10).run(5)}")
    print(f"DoubleNTimes    : {DoubleNTimes(3).run(2)}")

if __name__ == "__main__":
    _main()

# ============================================================
