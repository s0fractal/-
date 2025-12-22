// 🛑 QUANTUM STATE: COLLAPSED FROM Y.sigma
// 🌊 FREQUENCY: ts | ENERGY: 7
// The Z-Combinator (Strict Y) allows recursion without named functions.
type Func<A, B> = (x: A) => B;
type RecursiveFunc<A, B> = (f: Func<A, B>) => Func<A, B>;

export const Y = <A, B>(f: RecursiveFunc<A, B>): Func<A, B> => {
  const g = (h: any) => (x: A) => f(h(h))(x);
  return g(g);
};

// Example Usage (Factorial):
// const fact = Y(f => n => n <= 1 ? 1 : n * f(n - 1));
