# A weird number is defined as a number, n, such that:
# - the sum of all its divisors (excluding n itself) is greater than n
# - but no subset of its divisors sums up to exactly n.
# Write a program to find all the weird numbers less than a given input.

# take input 'n'
# test whether each number < n is "weird"
#   find all divisors
#     Add all divisors, is sum > n? if no, false
#   add divisors in every combination, test:
#     Is sum  exactly n? if so, false
#   true
# print all "true" results

def factors_of(n)
    result = []
    (1..n/2).each do |x|
        quotient, remainder = n.divmod x
        if remainder.zero?
            result << quotient
            result << x
        end
    end
    result.uniq
end

def weird?(n, debug=false)
    debug = true if n == 4030
    factors = factors_of(n)
    #remove n from list of divisors
    factors.delete(n)
    puts "factors: #{factors}" if debug
    return false if factors.sum <= n
    summer = Summer.new(debug: debug)
    return false if summer.new_sum_to_n?(factors.sort.reverse, n)
    true
end

class Summer
    def initialize(debug: false)
        @cache = {}
        @debug = debug
    end

    def new_sum_to_n?(factors, n)
        (0..factors.length).each do |l|
          factors.combination(l).each do |b|
            #puts b.join(" ")
            return true if b.sum == n
          end
        end
        false
    end

    def sum_to_n?(factors, n)
        if @cache.keys.include?(factors)
            #puts "Cache hit: #{factors}: #{@cache[factors]}" if @debug
            return @cache[factors]
        else
            puts "Cache miss: n: #{n}, factors: #{factors}" if @debug
        end

        factors.each do |x|
            if x == n
                @cache[factors] = true
                return true
            end
            if x < n
                remaining_factors = factors.clone
                remaining_factors.delete x
                if sum_to_n?(remaining_factors, n - x)
                    @cache[factors] = true
                    return true
                end
            end
        end
        @cache[factors] = false
        false
    end
end

n = ARGV[0].to_i
(1..n).each do |x|
    #puts "...#{x}" if (x % 100).zero?
    #puts "...#{x}" if x > 4000
    if weird?(x)
        puts "#{x} is weird"
    end
end