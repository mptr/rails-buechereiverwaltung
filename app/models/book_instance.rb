class BookInstance < ApplicationRecord
  before_save :reset_after_return, :handle_lending

  belongs_to :book
  has_one :reserved_by
  has_one :lended_by

  validates :purchased_at, :shelfmark, :book_id, presence: { message: "ist ein Pflichtfeld!"}
  validate :ensure_lender_not_blocked


  public def clear_lender_for_blocked
    self.lended_by_id = nil
  end

  def lender
    User.find(self.lended_by_id) if !self.lended_by_id.blank? 
  end

  def reserver
    User.find(self.reserved_by_id) if !self.reserved_by_id.blank? 
  end
  
	def is_overdue
		!!due_at&.to_date&.past?
	end

  def ensure_lender_not_blocked
    if !self.lender.nil? and self.lender.blocked
      errors.add(:base, "Der User kann das Buch nicht ausleihen, er ist blockiert!")
      self.update(lended_by_id: nil)
    end
  end

  def set_checkout_date
      if !self.lended_by_id.blank?

        if !self.returned_at.blank?
          self.returned_at = nil
        end

        if self.checkout_at.blank?
          self.checkout_at = Time.now
        end
        
      end
  end

  def set_returned_at
      if self.lended_by_id.blank? and self.returned_at.blank?
        self.returned_at = Time.now
      end
  end

  def reset_after_return
      if (!self.returned_at.blank? and self.returned_at_was == nil) or self.lended_by_id.blank?
        self.due_at = nil
        self.checkout_at = nil
        self.lended_by_id = nil

        if self.returned_at.blank?
          self.returned_at = Time.now
        end
      end
  end

  def handle_lending 
    if !self.lended_by_id.blank? and self.lended_by_id_changed?
      self.returned_at = nil
      self.checkout_at = Time.now
      self.due_at = self.due_at || 4.weeks.from_now
    end
  end

  def self.custom_select(filter, current_user)
    book_instances = BookInstance.order('created_at desc')

    case filter
    when 'lendable'
        book_instances = book_instances.select {|b| !b.lender and !b.reserver }
    when 'reserved'
        book_instances = book_instances.select {|b| !!b.reserver }
    when 'lended'
        book_instances = book_instances.select {|b| !!b.lender }
    when 'overdue'
        book_instances = book_instances.select {|b| b.is_overdue }
    when 'lended_by_current_user'
        book_instances = book_instances.select {|b| !!b.lender && b.lender.id == current_user.id } unless current_user.nil?
    when 'reserved_by_current_user'
        book_instances = book_instances.select {|b| !!b.reserver && b.reserver.id == current_user.id } unless current_user.nil?
    end

    return book_instances
  end  

end
