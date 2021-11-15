class Publisher < ApplicationRecord
    has_many :books, dependent: :destroy

    validates :name, :address, presence: { message: "ist ein Pflichtfeld!"}

    def self.custom_select(filter)
        publishers = Publisher.order('created_at desc')
        case filter
        when 'no_books'
            publishers = publishers.select {|pub| pub.books.empty? }
        end
        return publishers
    end
end
