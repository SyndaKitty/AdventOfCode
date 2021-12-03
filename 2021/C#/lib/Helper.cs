namespace AOC {
    public static class Helper {
        public static List<int> Primes(int n) {
            if (n <= 1) return new List<int>();
            if (n == 2) return new List<int>{ 2 };

            // Sieve of Erotosthenes
            bool[] isPrime = new bool[n];
            isPrime[2] = true;
            for (int i = 3; i < n; i+=2) {
                isPrime[i] = true;
            }

            for (int i = 3; i * i <= n; i += 2) {
                int index = i * 2;
                while (index < n) {
                    isPrime[index] = false;
                    index += i;
                }
            }

            int approximateCount = n < 128 ? n / 2 : (int)(n * 1.1 / Math.Log(n - 1));
            List<int> result = new List<int>(approximateCount);
            result.Add(2);
            for (int i = 3; i < n; i+= 2) {
                if (isPrime[i]) {
                    result.Add(i);
                }
            }

            return result;
        }

        static int LastUpTo = 0;
        static List<int> CachedPrimes = new List<int>();
        public static bool IsPrime(int n) {
            if (n <= 0) return false;
            if (n > LastUpTo) {
                CachedPrimes = Primes(n * 2);
                LastUpTo = n * 2;
            }
            return CachedPrimes.Contains(n);
        }

        public static void Permute<T>(IEnumerable<T> items, List<T[]> permutations) {
            T[] array = items.ToArray();
            int n = array.Length;
            int[] c = new int[n];

            var newArray = new T[array.Length];
            Array.Copy(array, newArray, array.Length);
            permutations.Add(newArray);

            int i = 1;
            while (i < n) {
                if (c[i] < i) {
                    if (i % 2 == 0) {
                        (array[0], array[i]) = (array[i], array[0]);
                    }
                    else {
                        (array[c[i]], array[i]) = (array[i], array[c[i]]);
                    }

                    newArray = new T[array.Length];
                    Array.Copy(array, newArray, array.Length);
                    permutations.Add(newArray);

                    c[i] += 1;
                    i = 1;
                }
                else {
                    c[i] = 0;
                    i += 1;
                }
            }
        }

        public static IEnumerable<T[]> PermuteEnumerate<T>(IEnumerable<T> items) {
            T[] array = items.ToArray();
            int n = array.Length;
            int[] c = new int[n];

            var newArray = new T[array.Length];
            Array.Copy(array, newArray, array.Length);
            yield return newArray;

            int i = 1;
            while (i < n) {
                if (c[i] < i) {
                    if (i % 2 == 0) {
                        (array[0], array[i]) = (array[i], array[0]);
                    }
                    else {
                        (array[c[i]], array[i]) = (array[i], array[c[i]]);
                    }

                    newArray = new T[array.Length];
                    Array.Copy(array, newArray, array.Length);
                    yield return newArray;

                    c[i] += 1;
                    i = 1;
                }
                else {
                    c[i] = 0;
                    i += 1;
                }
            }
        }

        public static int Spiral(int x, int y) {
            if (x == 0 && y == 0) return 1;
            int r = Math.Max(Math.Abs(x), Math.Abs(y));

            int val = (2 * r + 1) * (2 * r + 1);
            if (-x < y && y <= x) return val - 7 * r + y;
            if (-y <= x && x < y) return val - 5 * r - x;
            if (x <= y && y < -x) return val - 3 * r - y;
            return val - r + x;
        }

        public static List<List<T>> Combinations<T>(IEnumerable<T> items) {
            var result = new List<List<T>>();
            foreach (var combination in CombinationEnumerate(items)) {
                result.Add(combination);
            }
            return result;
        }

        public static IEnumerable<List<T>> CombinationEnumerate<T>(IEnumerable<T> items) {
            var array = items.ToArray();

            int combinationCount = 1 << array.Length;
            for (int i = 0; i < combinationCount; i++) {
                List<T> res = new List<T>();
                for (int j = 0; j < array.Length; j++) {
                    if (((i >> j) & 1) == 1) {
                        res.Add(array[j]);
                    }
                }
                yield return res;
            }
        }
    }
}