class Book < ApplicationRecord

    belongs_to :publisher
    has_and_belongs_to_many :authors, through: :authors_books, null: false
    has_many :book_instances, dependent: :destroy

    validates :title, :pub_year, :edition, :publisher_id, :author_ids, presence: { message: "ist ein Pflichtfeld!"}
    validate :isbn_length

    def isbn_length
        unless isbn.size == 10 or isbn.size == 13
            errors.add(:isbn, "muss entweder Länge 10 oder Länge 13 haben!") 
        end
    end

    def self.custom_select(filter)
        books = Book.order('created_at desc')

        case filter
        when 'no_author'
            books = books.select {|b| b.authors.empty?}
        when 'no_stock'
            books = books.select {|b| b.book_instances.empty?}
        end

        return books
    end
end
