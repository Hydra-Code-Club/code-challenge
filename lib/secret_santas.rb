# Criteria
# - A person can't be their own secret santa
# - A person can't be SS to anyone in their family
#   - (family is determined by shared last name)
# - Each person gives to one person
# - No one receives from more than one person
#
# We'll output a chain / list instead of an email
# Demian -> Anna
# Anna -> Jen
# Steven -> Demian
# Geoff -> Steven


# determine whether the problem is solvable

# Scenarios in which its not solvable
# - One family has more members than everyone else in the group

# Idea:
# - Sort into family groups before attempt to choose pairs
# - maintain groups of people who are not yet santas / santees

# Perform legal shuffle operations on the results
# - Can I swap these and still be legal?
# - With enough swaps like this (maybe a randomized # of swaps) you ought to end up with a random solution

class Matcher
  attr_accessor :participants

  def initialize(people)
    @participants = people.map { |p_array| Participant.new(p_array) }
  end

  def get_santa_cycle
    grouped_families = GroupedFamilies.new(group_by_families)
    sequence = []
    loop do
      next_sequence = grouped_families.get_next_sequence
      break unless next_sequence.count > 0
      sequence += next_sequence
    end
    sequence
  end

  def group_by_families
    @participants.group_by { |p| p.family }
  end
end

class GroupedFamilies
  attr_accessor :groups, :ordered_groups, :remainder
  def initialize(groups)
    @groups = groups
    @remainder = []
  end

  def get_next_sequence
    puts "@remainder: #{@remainder}"
    return @remainder if groups.keys.count.zero?
    family1 = @remainder + largest_family
    @remainder = []
    puts "familiy1: #{family1}"
    return family1 if groups.keys.count.zero?
    family2 = largest_family
    puts "familiy2: #{family2}"
    @remainder = family1[family2.count..family1.count-1]
    puts "@remainder: #{@remainder}"
    family1 = family1[0..family2.count-1]
    puts "family1: #{family1}"
    family1.zip(family2).flatten
  end

  def largest_family
    ordered_groups = groups.keys.sort_by { |k| groups[k].count }
    family_name = ordered_groups.pop
    groups.delete(family_name)
  end

  # this only works if everyone you pass in is in the same family
  # and there is no such family in the hash
  def add_to_families(people)
    groups[people.first.family] = people
  end
end

class Participant
  attr_accessor :first, :family, :email, :santee
  def initialize(array)
    @first = array[0]
    @family = array[1]
    @email = array[2]
    @santee = nil
  end

  def santa?
    santee
  end

end

medium_fixture = [
    ["Luke", "Skywalker", "<luke@theforce.net>"],
    ["Leia", "Skywalker", "<leia@therebellion.org>"],
    ["Toula", "Portokalos", "<toula@manhunter.org>"],
    ["Gus", "Portokalos", "<gus@weareallfruit.net>"],
    ["Bruce", "Wayne", "<bruce@imbatman.com>"],
    ["Virgil", "Brigman", "<virgil@rigworkersunion.org>"],
    ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"],
]

large_family_fixture = [
    ["Luke", "Skywalker", "<luke@theforce.net>"],
    ["Leia", "Skywalker", "<leia@therebellion.org>"],
    ["Toula", "Skywalker", "<toula@manhunter.org>"],
    ["Gus", "Skywalker", "<gus@weareallfruit.net>"],
    ["Bruce", "Wayne", "<bruce@imbatman.com>"],
    ["Virgil", "Portokalos", "<virgil@rigworkersunion.org>"],
    ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"],
    ["Demian", "Katz", "<hello@example.com>"]
]

break_it = [
    ["Luke", "Skywalker", "<luke@theforce.net>"],
    ["Leia", "Skywalker", "<leia@therebellion.org>"],
    ["Toula", "Skywalker", "<toula@manhunter.org>"],
    ["Gus", "Skywalker", "<gus@weareallfruit.net>"],
    ["Bruce", "Wayne", "<bruce@imbatman.com>"],
    ["Virgil", "Wayne", "<virgil@rigworkersunion.org>"],
    ["Aeneas", "Wayne", "<virgil@rigworkersunion.org>"],
    ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"],
    ["Lohan", "Brigman", "<lindsey@iseealiens.net>"],
    ["Demian", "Katz", "<hello@example.com>"],
    ["Otto", "Katz", "<hello@example.com>"]
]

current = Matcher.new(large_family_fixture).get_santa_cycle
#current = Matcher.new(break_it).get_santa_cycle
pp current.map { |p| "#{p.first} #{p.family}" }
