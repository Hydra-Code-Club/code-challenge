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

def weird?(n)
    factors = factors_of(n)
    #remove n from list of divisors
    factors.delete(n)
    return false if factors.sum <= n
    return false if sum_to_n?(factors.sort.reverse, n)
    true
end

def sum_to_n?(factors, n)
    factors.each do |x|
        if x == n
            return true
        end
        if x < n
            remaining_factors = factors.clone
            remaining_factors.delete x
            if sum_to_n?(remaining_factors, n - x)
                return true
            end
        end
    end
    false
end

n = ARGV[0].to_i
(1..n).each do |x|
    if weird?(x)
        puts "#{x} is weird"
        puts factors_of(x)
    end
end
