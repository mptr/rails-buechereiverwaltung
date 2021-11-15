class Author < ApplicationRecord
    include PersonFuncs

    has_and_belongs_to_many :books, through: :authors_books, dependent: :destroy

    validates :affiliation, presence: { message: "ist ein Pflichtfeld!"}

    def self.custom_select(filter)
        authors = Author.order('created_at desc')

        case filter
        when 'no_books'
            authors = authors.select {|a| a.books.empty?}
        end

        return authors
    end
end
