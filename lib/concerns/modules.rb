module Concerns

    module Findable

        def find_by_name(name)
            self.all.find {|i| i.name == name}
        end

        def find_or_create_by_name(name_string)
            a = find_by_name(name_string) 
            a ? a : self.create(name_string)
        end
            
    end
end