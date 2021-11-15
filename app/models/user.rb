class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    include PersonFuncs

    before_save :reset_lent_books, if: :blocked?

    has_many :lent_books, :foreign_key => 'lended_by_id', class_name: 'BookInstance', :dependent => :restrict_with_error
    has_many :reserved_books, :foreign_key => 'reserved_by_id', class_name: 'BookInstance', :dependent => :nullify
    
    validates :family_name, :given_name, :email, presence: { message: "ist ein Pflichtfeld!"}
    #validates :password, presence: { message: "ist ein Pflichtfeld!"}, length: { minimum: 8, message: "muss mindestens 8 Stellen lang sein!" }
    
    def reset_lent_books
        if !self.lent_books.blank?
            self.lent_books.each do |book|
                book.update(lended_by_id: nil)
            end
        end
    end

    def self.custom_select(filter)
        users = User.order('created_at desc')

        case filter
        when 'has_reservations'
            users = users.select {|u| !u.reserved_books.empty? }
        when 'has_lendings'
            users = users.select {|u| !u.lent_books.empty? }
        when 'has_overdue'
            users = users.select {|u| !u.lent_books.select {|lb| lb.is_overdue }.empty? }
        end

        return users
    end
end
