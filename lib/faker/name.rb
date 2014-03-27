module Faker
  class Name < Base
    class << self
      def boy_name
        fetch('name.boy_name')
      end
			
      def girl_name
        fetch('name.girl_name')
      end
			
      def kid_name
        parse('name.kid_name')
      end
			
			def boy_names(n)
				return unique(n) {boy_name}
			end
			
			def girl_names(n)
				return unique(n) {girl_name}
			end
						
      def kid_names(n)
				return unique(n) {kid_name}
      end
			
			def unique(n)
				ns = []
				begin
					nm = yield
					if !ns.include?(nm) then
						ns << nm
						n = n - 1
					end
				end while n > 0
				return ns
			end
			
    end
  end
end