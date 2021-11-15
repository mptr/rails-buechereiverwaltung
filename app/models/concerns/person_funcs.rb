module PersonFuncs
    extend ActiveSupport::Concern
    included do
        validates :family_name, :given_name, presence: { message: "ist ein Pflichtfeld" }
    end
    
    def short_name
        self.given_name[0] + ". " + self.family_name
    end

    def full_name
        self.family_name + ", " + self.given_name
    end
end