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

class Participants
  attr_accessor :participants

  def initialize
    @participants = [
        ["Luke", "Skywalker", "<luke@theforce.net>"],
        ["Leia", "Skywalker", "<leia@therebellion.org>"],
        ["Toula", "Portokalos", "<toula@manhunter.org>"],
        ["Gus", "Portokalos", "<gus@weareallfruit.net>"],
        ["Bruce", "Wayne", "<bruce@imbatman.com>"],
        ["Virgil", "Brigman", "<virgil@rigworkersunion.org>"],
        ["Lindsey", "Brigman", "<lindsey@iseealiens.net>"],
    ].map { |p_array| Participant.new(p_array) }
  end

  def available_santas

  end

  def available_santees

  end

  def create_initial_order
  end

  def group_by_families
    hash = @participants.group_by { |p| p.family }
    all_families = hash.keys.sort_by { |k| hash[k].count }.reverse
    cycle = []
    loop do
      remaining_families = []
      all_families.each do |family|
        cycle << hash[family].pop
        if hash[family].length > 0
          remaining_families << family
        end
      end
      all_families = remaining_families
      break if all_families.size == 0
    end
    cycle
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

current = Participants.new.group_by_families
pp current.map { |p| "#{p.first} #{p.family}" }
