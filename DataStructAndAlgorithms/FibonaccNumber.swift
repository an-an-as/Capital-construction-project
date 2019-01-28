// Fibonacci Number
// F(2) = F(1) + F(0) = 1 + 0 = 1.
func fib(_ N: Int) -> Int {
    if(N < 2) { return N }
    return fib(N - 1) + fib(N - 2)
}
print(fib(4)) // 第4项

let fibonacci = sequence(state: (0, 1)) { (state: inout(Int, Int)) -> Int? in
    let next = state.0
    state = (state.1, state.0 + state.1)
    return next
}
let result = Array(fibonacci.prefix(3))
print(result)
