module Faker
  class Number < Base
    class << self
			#return unique random ints in a array or int
			#a = get_ints(5, 10) return a array
			#a, b, c = get_ints(5, 10) return a =3, b=5, c=7
			#a, b, *c = get_ints(5, 10) return a =3, b=5, c=[7, 1, 2]
			#get_ints(5, (10..20))
			def ints(n=1, range=(2 .. 10))
				return rand(range) if n==1
				ints = []
				n.times do
					begin
						i = rand(range)
					end while ints.include?(i) or i <= 1
					ints << i
				end
				return ints
			end

    end
  end
end